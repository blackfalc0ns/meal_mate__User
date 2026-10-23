package kw.mealmate.user2.calling

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.media.Ringtone
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.Person

class CallNotificationController(private val context: Context) {
    private var foregroundRingtone: Ringtone? = null
    private var ringingCallId: String? = null
    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    init {
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .build()

            val incomingChannel = NotificationChannel(
                CHANNEL_INCOMING_CALLS,
                "Incoming Delivery Calls",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows notifications for incoming delivery driver calls"
                setSound(ringtoneUri, audioAttributes)
                enableVibration(true)
            }

            val ongoingChannel = NotificationChannel(
                CHANNEL_ONGOING_CALLS,
                "Ongoing Calls",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Active voice call indicator"
            }

            notificationManager.createNotificationChannel(incomingChannel)
            notificationManager.createNotificationChannel(ongoingChannel)
        }
    }

    fun isAppInForeground(): Boolean {
        return try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as? android.app.ActivityManager
                ?: return false
            val appProcesses = activityManager.runningAppProcesses ?: return false
            val packageName = context.packageName
            appProcesses.any { process ->
                process.processName == packageName &&
                process.importance == android.app.ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
            }
        } catch (_: Exception) {
            false
        }
    }

    fun showIncomingCall(snapshot: NativeCallSnapshot): Boolean {
        if (isAppInForeground()) {
            if (ringingCallId != snapshot.callId) {
                stopForegroundRingtone()
                val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                foregroundRingtone = RingtoneManager.getRingtone(context, ringtoneUri)?.apply {
                    audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                    play()
                }
                ringingCallId = snapshot.callId
            }
            return true
        }
        stopForegroundRingtone()
        if(!androidx.core.app.NotificationManagerCompat.from(context).areNotificationsEnabled()) return false
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && notificationManager.getNotificationChannel(CHANNEL_INCOMING_CALLS)?.importance == NotificationManager.IMPORTANCE_NONE) return false
        val caller = Person.Builder()
            .setName(snapshot.callerDisplay?.callerName ?: "Delivery Driver")
            .setImportant(true)
            .build()

        val answerIntent = Intent(context, kw.mealmate.user2.calling.ui.IncomingCallActivity::class.java).apply {
            action = ACTION_ANSWER
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            putExtra("callId", snapshot.callId)
            putExtra("lifecycleId", snapshot.lifecycleId)
        }
        val answerPendingIntent = PendingIntent.getActivity(
            context,
            REQUEST_CODE_ANSWER,
            answerIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val declineIntent = Intent(context, VoiceCallReceiver::class.java).apply {
            action = ACTION_DECLINE
            putExtra("callId", snapshot.callId)
            putExtra("lifecycleId", snapshot.lifecycleId)
        }
        val declinePendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE_DECLINE,
            declineIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val fullScreenIntent = Intent(context, Class.forName("kw.mealmate.user2.calling.ui.IncomingCallActivity")).apply {
            putExtra("callId", snapshot.callId)
            putExtra("lifecycleId", snapshot.lifecycleId)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        val fullScreenPendingIntent = PendingIntent.getActivity(
            context,
            REQUEST_CODE_FULLSCREEN,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notificationBuilder = NotificationCompat.Builder(context, CHANNEL_INCOMING_CALLS)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentTitle("Incoming Delivery Call")
            .setContentText(snapshot.callerDisplay?.callerName ?: "Delivery Driver is calling")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setAutoCancel(false)
            .setOngoing(true)
            .setFullScreenIntent(fullScreenPendingIntent, true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            notificationBuilder.setStyle(
                NotificationCompat.CallStyle.forIncomingCall(
                    caller,
                    declinePendingIntent,
                    answerPendingIntent
                )
            )
        } else {
            notificationBuilder.addAction(android.R.drawable.ic_menu_close_clear_cancel, "Decline", declinePendingIntent)
            notificationBuilder.addAction(android.R.drawable.ic_menu_call, "Answer", answerPendingIntent)
        }

        notificationManager.notify(NOTIFICATION_ID_CALL, notificationBuilder.build())
        return true
    }

    fun showActiveCall(snapshot: NativeCallSnapshot) {
        stopForegroundRingtone()
        val caller = Person.Builder()
            .setName(snapshot.callerDisplay?.callerName ?: "Delivery Driver")
            .build()

        val hangupIntent = Intent(context, VoiceCallReceiver::class.java).apply {
            action = ACTION_HANGUP
            putExtra("callId", snapshot.callId)
            putExtra("lifecycleId", snapshot.lifecycleId)
        }
        val hangupPendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE_HANGUP,
            hangupIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notificationBuilder = NotificationCompat.Builder(context, CHANNEL_ONGOING_CALLS)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentTitle("MealMate Voice Call")
            .setContentText("Connected with ${snapshot.callerDisplay?.callerName ?: "Delivery Driver"}")
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_CALL)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            notificationBuilder.setStyle(
                NotificationCompat.CallStyle.forOngoingCall(
                    caller,
                    hangupPendingIntent
                )
            )
        } else {
            notificationBuilder.addAction(android.R.drawable.ic_menu_close_clear_cancel, "End", hangupPendingIntent)
        }

        notificationManager.notify(NOTIFICATION_ID_CALL, notificationBuilder.build())
    }

    fun dismiss(callId: String?) {
        stopForegroundRingtone()
        notificationManager.cancel(NOTIFICATION_ID_CALL)
    }

    fun stopForegroundRingtone() {
        foregroundRingtone?.stop()
        foregroundRingtone = null
        ringingCallId = null
    }

    companion object {
        const val CHANNEL_INCOMING_CALLS = "mealmate_incoming_calls"
        const val CHANNEL_ONGOING_CALLS = "mealmate_ongoing_calls"
        const val NOTIFICATION_ID_CALL = 2001

        const val ACTION_ANSWER = "kw.mealmate.user2.calling.ACTION_ANSWER"
        const val ACTION_DECLINE = "kw.mealmate.user2.calling.ACTION_DECLINE"
        const val ACTION_HANGUP = "kw.mealmate.user2.calling.ACTION_HANGUP"

        const val REQUEST_CODE_ANSWER = 101
        const val REQUEST_CODE_DECLINE = 102
        const val REQUEST_CODE_HANGUP = 103
        const val REQUEST_CODE_FULLSCREEN = 104
    }
}
