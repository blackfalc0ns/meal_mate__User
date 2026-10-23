package kw.mealmate.user2.calling

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import java.util.UUID

class VoiceCallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val coordinator = NativeCallCoordinator.getInstance(context)
        val callId = intent.getStringExtra("callId") ?: return
        val lifecycleId = intent.getStringExtra("lifecycleId") ?: return
        val requestId = UUID.randomUUID().toString()

        when (intent.action) {
            CallNotificationController.ACTION_ANSWER -> {
                coordinator.answer(callId, lifecycleId, requestId)
            }
            CallNotificationController.ACTION_DECLINE -> {
                coordinator.reject(callId, lifecycleId, requestId)
            }
            CallNotificationController.ACTION_HANGUP -> {
                coordinator.end(callId, lifecycleId, requestId)
            }
        }
    }
}
