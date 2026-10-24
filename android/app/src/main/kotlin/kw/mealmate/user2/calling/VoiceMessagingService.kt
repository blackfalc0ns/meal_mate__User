package kw.mealmate.user2.calling

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class VoiceMessagingService : FlutterFirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        NativeCallCoordinator.getInstance(applicationContext).handlePush(remoteMessage.data)
        super.onMessageReceived(remoteMessage)
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
    }
}
