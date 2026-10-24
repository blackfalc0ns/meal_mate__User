package kw.mealmate.meal_meat_user

import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val RINGTONE_CHANNEL = "kw.mealmate/ringtone"
    private var ringtone: Ringtone? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RINGTONE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startRingtone" -> {
                    try {
                        stopRingtoneInternal()
                        val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                        ringtone = RingtoneManager.getRingtone(applicationContext, uri)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            ringtone?.audioAttributes = AudioAttributes.Builder()
                                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                .build()
                        }
                        ringtone?.play()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("RINGTONE_ERROR", e.message, null)
                    }
                }
                "stopRingtone" -> {
                    stopRingtoneInternal()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun stopRingtoneInternal() {
        try {
            if (ringtone?.isPlaying == true) {
                ringtone?.stop()
            }
            ringtone = null
        } catch (_: Exception) {}
    }

    override fun onDestroy() {
        stopRingtoneInternal()
        super.onDestroy()
    }
}
