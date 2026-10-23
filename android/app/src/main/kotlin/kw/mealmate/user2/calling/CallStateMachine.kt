package kw.mealmate.user2.calling

import java.util.UUID
import java.util.concurrent.atomic.AtomicInteger

class CallStateMachine(
    val engineInstanceId: String = UUID.randomUUID().toString()
) {
    private val revisionCounter = AtomicInteger(0)

    @Volatile
    var currentSnapshot: NativeCallSnapshot = NativeCallSnapshot(
        engineInstanceId = engineInstanceId,
        revision = revisionCounter.incrementAndGet(),
        phase = CallPhase.IDLE
    )
        private set

    private val listeners = mutableListOf<(NativeCallSnapshot) -> Unit>()
    private val terminalCalls = mutableSetOf<String>()
    private val processedRequestIds = mutableMapOf<String, String>()

    @Synchronized
    fun addListener(listener: (NativeCallSnapshot) -> Unit) {
        listeners.add(listener)
        listener(currentSnapshot)
    }

    @Synchronized
    fun removeListener(listener: (NativeCallSnapshot) -> Unit) {
        listeners.remove(listener)
    }

    @Synchronized
    fun onIncomingRinging(
        callId: String,
        lifecycleId: String = UUID.randomUUID().toString(),
        sequence: Int = 1,
        callerDisplay: CallerDisplay? = null,
        micStatus: MicrophonePermissionStatus = MicrophonePermissionStatus.NOT_DETERMINED
    ): Boolean {
        if (callId in terminalCalls) return false
        // If same call is already ringing or active, ignore duplicate
        if (currentSnapshot.callId == callId && currentSnapshot.phase != CallPhase.ENDED && currentSnapshot.phase != CallPhase.IDLE) {
            if (callerDisplay != null && callerDisplay.callerName.isNotBlank() &&
                callerDisplay.callerName.lowercase() != "null" &&
                callerDisplay != currentSnapshot.callerDisplay) {
                updateSnapshot {
                    it.copy(revision = revisionCounter.incrementAndGet(), callerDisplay = callerDisplay)
                }
            }
            return false
        }

        // If another call is currently active or ringing, ignore second call or mark busy
        if (currentSnapshot.phase != CallPhase.IDLE && currentSnapshot.phase != CallPhase.ENDED) {
            return false
        }

        processedRequestIds.clear()
        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                callId = callId,
                lifecycleId = lifecycleId,
                serverSequence = sequence,
                negotiationGeneration = 0,
                phase = CallPhase.RINGING,
                serverStatus = "ringing",
                microphonePermission = micStatus,
                isMuted = false,
                audioRouteId = "earpiece",
                mediaTransportConnected = false,
                audioSessionActive = false,
                connectedAtUtc = null,
                elapsedSeconds = 0,
                errorCode = null,
                callerDisplay = callerDisplay
            )
        }
        return true
    }

    @Synchronized
    fun onUserAnswer(
        callId: String,
        lifecycleId: String,
        requestId: String
    ): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false
        if (processedRequestIds.containsKey(requestId)) return false

        if (currentSnapshot.phase != CallPhase.RINGING && currentSnapshot.phase != CallPhase.PERMISSION_REQUIRED) {
            return false
        }

        processedRequestIds[requestId] = "answer"

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                phase = CallPhase.ANSWERING
            )
        }
        return true
    }

    @Synchronized
    fun onServerAccepted(
        callId: String,
        lifecycleId: String,
        connectedAtUtc: String? = null
    ): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                phase = if (it.mediaTransportConnected && it.audioSessionActive) CallPhase.CONNECTED else CallPhase.CONNECTING,
                serverStatus = "accepted",
                connectedAtUtc = connectedAtUtc
            )
        }
        return true
    }

    @Synchronized
    fun onMediaConnected(
        callId: String,
        lifecycleId: String,
        generation: Int
    ): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false
        if (currentSnapshot.negotiationGeneration != generation) return false

        updateSnapshot {
            val isReady = it.serverStatus == "accepted"
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                negotiationGeneration = generation,
                mediaTransportConnected = true,
                audioSessionActive = true,
                connectedAtUtc = it.connectedAtUtc ?: java.time.Instant.now().toString(),
                phase = if (isReady) CallPhase.CONNECTED else CallPhase.CONNECTING
            )
        }
        return true
    }

    @Synchronized
    fun onPermissionRequired(callId: String, lifecycleId: String): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                phase = CallPhase.PERMISSION_REQUIRED,
                microphonePermission = MicrophonePermissionStatus.DENIED
            )
        }
        return true
    }

    @Synchronized
    fun onMuteToggled(
        callId: String,
        lifecycleId: String,
        requestId: String,
        muted: Boolean
    ): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false
        processedRequestIds[requestId] = "mute"

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                isMuted = muted
            )
        }
        return true
    }

    @Synchronized
    fun onAudioRouteChanged(
        callId: String,
        lifecycleId: String,
        requestId: String,
        routeId: String
    ): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false
        processedRequestIds[requestId] = "route"

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                audioRouteId = routeId
            )
        }
        return true
    }

    @Synchronized
    fun onCallEnding(callId: String, lifecycleId: String, reason: String? = null): Boolean {
        if (!validateActiveCall(callId, lifecycleId)) return false

        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                phase = CallPhase.ENDING,
                errorCode = reason
            )
        }
        return true
    }

    @Synchronized
    fun onCallEnded(callId: String, lifecycleId: String, reason: String? = null) {
        if (currentSnapshot.callId != callId || currentSnapshot.lifecycleId != lifecycleId) {
            return
        }

        rememberTerminal(callId)
        updateSnapshot {
            it.copy(
                revision = revisionCounter.incrementAndGet(),
                phase = CallPhase.ENDED,
                serverStatus = "ended",
                mediaTransportConnected = false,
                audioSessionActive = false,
                errorCode = reason
            )
        }
    }

    @Synchronized
    fun resetToIdle() {
        processedRequestIds.clear()
        updateSnapshot {
            NativeCallSnapshot(
                engineInstanceId = engineInstanceId,
                revision = revisionCounter.incrementAndGet(),
                phase = CallPhase.IDLE
            )
        }
    }

    @Synchronized fun updateElapsed() {
        val start = currentSnapshot.connectedAtUtc ?: return
        if(currentSnapshot.phase !in listOf(CallPhase.CONNECTED,CallPhase.RECONNECTING)) return
        val elapsed = runCatching { java.time.Duration.between(java.time.Instant.parse(start),java.time.Instant.now()).seconds.toInt().coerceAtLeast(0) }.getOrDefault(0)
        updateSnapshot { it.copy(elapsedSeconds=elapsed,revision=revisionCounter.incrementAndGet()) }
    }
    @Synchronized fun onServerSequence(callId: String, lifecycleId: String, sequence: Int) {
        if(!validateActiveCall(callId,lifecycleId) || sequence <= currentSnapshot.serverSequence) return
        updateSnapshot { it.copy(serverSequence = sequence, revision = revisionCounter.incrementAndGet()) }
    }
    @Synchronized fun rememberTerminal(callId: String) {
        terminalCalls.add(callId)
        if(terminalCalls.size > 256) terminalCalls.remove(terminalCalls.first())
    }
    @Synchronized fun onNegotiationGeneration(generation: Int) {
        if(generation <= currentSnapshot.negotiationGeneration) return
        updateSnapshot { it.copy(negotiationGeneration = generation, mediaTransportConnected = false,
            phase = if(it.phase == CallPhase.CONNECTED) CallPhase.RECONNECTING else it.phase,
            revision = revisionCounter.incrementAndGet()) }
    }
    @Synchronized fun onMediaDisconnected() {
        if(currentSnapshot.phase != CallPhase.CONNECTED) return
        updateSnapshot { it.copy(phase = CallPhase.RECONNECTING, mediaTransportConnected = false, revision = revisionCounter.incrementAndGet()) }
    }
    private fun validateActiveCall(callId: String, lifecycleId: String): Boolean {
        if (currentSnapshot.callId != callId || currentSnapshot.lifecycleId != lifecycleId) {
            return false
        }
        if (currentSnapshot.phase == CallPhase.ENDED || currentSnapshot.phase == CallPhase.IDLE || currentSnapshot.phase == CallPhase.ENDING) {
            return false
        }
        return true
    }

    private inline fun updateSnapshot(transform: (NativeCallSnapshot) -> NativeCallSnapshot) {
        val next = transform(currentSnapshot)
        currentSnapshot = next
        notifyListeners(next)
    }

    private fun notifyListeners(snapshot: NativeCallSnapshot) {
        for (listener in listeners) {
            try {
                listener(snapshot)
            } catch (_: Exception) {}
        }
    }
}
