package kw.mealmate.user2.calling.ui

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.*
import kw.mealmate.user2.calling.CallPhase
import kw.mealmate.user2.calling.NativeCallCoordinator
import kw.mealmate.user2.calling.NativeCallSnapshot
import java.util.UUID

class IncomingCallActivity : ComponentActivity() {

    private lateinit var coordinator: NativeCallCoordinator

    private val permissionLauncher = registerForActivityResult(androidx.activity.result.contract.ActivityResultContracts.RequestPermission()) { granted ->
        if(granted) answerCurrentCall()
    }
    private fun answerCurrentCall() {
        if(androidx.core.content.ContextCompat.checkSelfPermission(this, android.Manifest.permission.RECORD_AUDIO) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
            permissionLauncher.launch(android.Manifest.permission.RECORD_AUDIO); return
        }
        val snapshot = coordinator.currentSnapshot
        if(snapshot.callId != intent.getStringExtra("callId") || snapshot.lifecycleId != intent.getStringExtra("lifecycleId")) return
        coordinator.answer(snapshot.callId.orEmpty(), snapshot.lifecycleId.orEmpty(), UUID.randomUUID().toString())
    }
    override fun onResume() {
        super.onResume()
        if(intent.action == kw.mealmate.user2.calling.CallNotificationController.ACTION_ANSWER) {
            intent.action = null
            answerCurrentCall()
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        coordinator = NativeCallCoordinator.getInstance(this)

        setupLockScreenFlags()

        val callId = intent.getStringExtra("callId") ?: ""
        val lifecycleId = intent.getStringExtra("lifecycleId") ?: ""

        setContent {
            CallTheme {
                var snapshot by remember { mutableStateOf(coordinator.currentSnapshot) }

                DisposableEffect(coordinator) {
                    val listener: (NativeCallSnapshot) -> Unit = { newSnap ->
                        snapshot = newSnap
                        if (newSnap.phase == CallPhase.ENDED || newSnap.phase == CallPhase.IDLE) {
                            finish()
                        }
                    }
                    coordinator.stateMachine.addListener(listener)
                    onDispose {
                        coordinator.stateMachine.removeListener(listener)
                    }
                }

                if (snapshot.phase == CallPhase.CONNECTED || snapshot.phase == CallPhase.CONNECTING) {
                    ActiveCallScreen(
                        callerDisplay = snapshot.callerDisplay,
                        elapsedSeconds = snapshot.elapsedSeconds,
                        isMuted = snapshot.isMuted,
                        isSpeaker = snapshot.audioRouteId == "speaker",
                        onToggleMute = {
                            val activeId = snapshot.callId ?: callId
                            val activeLc = snapshot.lifecycleId ?: lifecycleId
                            coordinator.setMuted(activeId, activeLc, UUID.randomUUID().toString(), !snapshot.isMuted)
                        },
                        onToggleSpeaker = {
                            val activeId = snapshot.callId ?: callId
                            val activeLc = snapshot.lifecycleId ?: lifecycleId
                            val nextRoute = if (snapshot.audioRouteId == "speaker") "earpiece" else "speaker"
                            coordinator.setAudioRoute(activeId, activeLc, UUID.randomUUID().toString(), nextRoute)
                        },
                        onEndCall = {
                            val activeId = snapshot.callId ?: callId
                            val activeLc = snapshot.lifecycleId ?: lifecycleId
                            coordinator.end(activeId, activeLc, UUID.randomUUID().toString())
                            finish()
                        }
                    )
                } else {
                    IncomingCallScreen(
                        callerDisplay = snapshot.callerDisplay,
                        onAnswer = {
                            val activeId = snapshot.callId ?: callId
                            val activeLc = snapshot.lifecycleId ?: lifecycleId
                            answerCurrentCall()
                        },
                        onDecline = {
                            val activeId = snapshot.callId ?: callId
                            val activeLc = snapshot.lifecycleId ?: lifecycleId
                            coordinator.reject(activeId, activeLc, UUID.randomUUID().toString())
                            finish()
                        }
                    )
                }
            }
        }
    }

    private fun setupLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.attributes.layoutInDisplayCutoutMode =
                WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }
        androidx.core.view.WindowCompat.setDecorFitsSystemWindows(window, false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }
}
