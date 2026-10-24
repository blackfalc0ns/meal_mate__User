package kw.mealmate.user2.calling

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class VoiceCallService : Service() {
    private var activeCallId: String? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val callId = intent?.getStringExtra("callId")
        activeCallId = callId
        val callerName = intent?.getStringExtra("callerName") ?: "Delivery Driver"

        val notification = NotificationCompat.Builder(this, CallNotificationController.CHANNEL_ONGOING_CALLS)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentTitle("Active Call")
            .setContentText("Voice call with $callerName in progress")
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            } else {
                0
            }
            startForeground(SERVICE_NOTIFICATION_ID, notification, type)
        } else {
            startForeground(SERVICE_NOTIFICATION_ID, notification)
        }

        return START_NOT_STICKY
    }

    override fun onDestroy() {
        stopForeground(true)
        NativeCallCoordinator.getInstance(applicationContext).serviceStopped(activeCallId)
        super.onDestroy()
    }

    companion object {
        private const val SERVICE_NOTIFICATION_ID = CallNotificationController.NOTIFICATION_ID_CALL

        fun start(context: Context, callId: String, callerName: String) {
            val intent = Intent(context, VoiceCallService::class.java).apply {
                putExtra("callId", callId)
                putExtra("callerName", callerName)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            val intent = Intent(context, VoiceCallService::class.java)
            context.stopService(intent)
        }
    }
}
