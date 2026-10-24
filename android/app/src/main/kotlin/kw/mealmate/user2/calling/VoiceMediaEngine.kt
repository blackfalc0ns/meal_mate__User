package kw.mealmate.user2.calling

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import org.webrtc.*
import org.webrtc.audio.JavaAudioDeviceModule
import java.util.UUID

/** Owns the actual microphone, RTP transport and remote audio playback. */
class VoiceMediaEngine(
    private val context: Context,
    private val signalRClient: VoiceSignalingClient,
    private val factoryProvider: (() -> PeerConnectionFactory)? = null,
    private val dispatch: ((() -> Unit) -> Unit) = { action -> Handler(Looper.getMainLooper()).post(action) }
) {
    companion object { private const val TAG = "VoiceMediaEngine" }
    interface Listener {
        fun onLocalMediaConnected()
        fun onMediaDisconnected()
        fun onMediaFailed()
    }
    var listener: Listener? = null
    private var activeCallId: String? = null
    private var activeGeneration = 0
    private var epoch = 0
    private var factory: PeerConnectionFactory? = null
    private var peer: PeerConnection? = null
    private var audioSource: AudioSource? = null
    private var localAudio: AudioTrack? = null
    private var remoteDescriptionSet = false
    private var connected = false
    private var muted = false
    private var localAnswer: String? = null
    private val queuedCandidates = mutableListOf<IceCandidate>()
    private val localCandidates = mutableListOf<IceCandidate>()

    fun startAnswerSession(callId: String, generation: Int, iceServers: List<NativeIceServer>, offer: String) {
        stop()
        activeCallId = callId
        activeGeneration = generation
        val sessionEpoch = epoch
        if (iceServers.isEmpty()) { fail("No ICE servers supplied"); return }
        try {
            val rtcFactory = factoryProvider?.invoke() ?: createFactory()
            factory = rtcFactory
            val config = PeerConnection.RTCConfiguration(iceServers.map {
                PeerConnection.IceServer.builder(it.urls)
                    .setUsername(it.username.orEmpty()).setPassword(it.credential.orEmpty()).createIceServer()
            }).apply {
                sdpSemantics = PeerConnection.SdpSemantics.UNIFIED_PLAN
                bundlePolicy = PeerConnection.BundlePolicy.MAXBUNDLE
                rtcpMuxPolicy = PeerConnection.RtcpMuxPolicy.REQUIRE
            }
            val observer = object : PeerConnection.Observer {
                override fun onSignalingChange(state: PeerConnection.SignalingState) {}
                override fun onIceConnectionChange(state: PeerConnection.IceConnectionState) {}
                override fun onIceConnectionReceivingChange(receiving: Boolean) {}
                override fun onIceGatheringChange(state: PeerConnection.IceGatheringState) {}
                override fun onIceCandidatesRemoved(candidates: Array<out IceCandidate>) {}
                override fun onAddStream(stream: MediaStream) {}
                override fun onRemoveStream(stream: MediaStream) {}
                override fun onDataChannel(channel: DataChannel) {}
                override fun onRenegotiationNeeded() {}
                override fun onAddTrack(receiver: RtpReceiver, streams: Array<out MediaStream>) {}
                override fun onTrack(transceiver: RtpTransceiver) {
                    dispatch {
                        if (epoch == sessionEpoch) (transceiver.receiver.track() as? AudioTrack)?.setEnabled(true)
                    }
                }
                override fun onIceCandidate(candidate: IceCandidate) {
                    dispatch {
                        if (epoch == sessionEpoch) {
                            localCandidates.add(candidate)
                            sendCandidate(callId, candidate)
                        }
                    }
                }
                override fun onConnectionChange(state: PeerConnection.PeerConnectionState) {
                    dispatch {
                        if (epoch != sessionEpoch) return@dispatch
                        when (state) {
                            PeerConnection.PeerConnectionState.CONNECTED -> if (!connected) {
                                connected = true
                                Log.i(TAG, "Native audio transport connected")
                                listener?.onLocalMediaConnected()
                            }
                            PeerConnection.PeerConnectionState.DISCONNECTED -> {
                                connected = false
                                listener?.onMediaDisconnected()
                            }
                            PeerConnection.PeerConnectionState.FAILED -> fail("ICE/DTLS connection failed")
                            else -> Unit
                        }
                    }
                }
            }
            val connection = rtcFactory.createPeerConnection(config, observer)
                ?: error("Unable to create audio peer connection")
            peer = connection
            audioSource = rtcFactory.createAudioSource(MediaConstraints().apply {
                mandatory.add(MediaConstraints.KeyValuePair("googEchoCancellation", "true"))
                mandatory.add(MediaConstraints.KeyValuePair("googNoiseSuppression", "true"))
                mandatory.add(MediaConstraints.KeyValuePair("googAutoGainControl", "true"))
            })
            localAudio = rtcFactory.createAudioTrack("user-audio", audioSource).apply { setEnabled(!muted) }
            check(connection.addTrack(localAudio, listOf("user-stream")) != null) { "Unable to add microphone track" }
            connection.setRemoteDescription(object : SimpleSdpObserver() {
                override fun onSetSuccess() { dispatch {
                    if (epoch != sessionEpoch) return@dispatch
                    remoteDescriptionSet = true
                    queuedCandidates.forEach { connection.addIceCandidate(it) }; queuedCandidates.clear()
                    connection.createAnswer(object : SimpleSdpObserver() {
                        override fun onCreateSuccess(sdp: SessionDescription) { dispatch {
                            if (epoch != sessionEpoch) return@dispatch
                            val optimizedSdp = SessionDescription(sdp.type, optimizeOpusSdp(sdp.description))
                            connection.setLocalDescription(object : SimpleSdpObserver() {
                                override fun onSetSuccess() { dispatch {
                                    if (epoch == sessionEpoch) { localAnswer = optimizedSdp.description; resendAnswer() }
                                } }
                                override fun onSetFailure(error: String) { failIfCurrent(sessionEpoch, error) }
                            }, optimizedSdp)
                        } }
                        override fun onCreateFailure(error: String) { failIfCurrent(sessionEpoch, error) }
                    }, MediaConstraints())
                } }
                override fun onSetFailure(error: String) { failIfCurrent(sessionEpoch, error) }
            }, SessionDescription(SessionDescription.Type.OFFER, offer))
        } catch (error: Exception) { fail(error.message ?: "Cannot initialize native audio") }
    }

    private fun optimizeOpusSdp(sdp: String): String {
        return if (!sdp.contains("minptime=10")) {
            sdp.replace(Regex("(a=fmtp:\\d+ [^\\r\\n]+)"), "$1;minptime=10;useinbandfec=1;stereo=0;sprop-stereo=0;cbr=1")
        } else {
            sdp
        }
    }

    private fun createFactory(): PeerConnectionFactory {
        PeerConnectionFactory.initialize(PeerConnectionFactory.InitializationOptions.builder(context).createInitializationOptions())
        val audioModule = JavaAudioDeviceModule.builder(context)
            .setUseHardwareAcousticEchoCanceler(true)
            .setUseHardwareNoiseSuppressor(true)
            .createAudioDeviceModule()
        return try {
            PeerConnectionFactory.builder().setAudioDeviceModule(audioModule).createPeerConnectionFactory()
        } finally { audioModule.release() }
    }

    fun handleRemoteCandidate(
        callId: String, candidate: String, generation: Int,
        sdpMid: String? = null, sdpMLineIndex: Int? = null
    ) {
        if (callId != activeCallId || generation != activeGeneration || candidate.isBlank()) return
        val ice = IceCandidate(sdpMid, sdpMLineIndex ?: 0, candidate)
        if (remoteDescriptionSet) peer?.addIceCandidate(ice) else queuedCandidates.add(ice)
    }

    fun setMuted(value: Boolean) { muted = value; localAudio?.setEnabled(!value) }

    /** Resend the same SDP after rebinding; do not replace the live peer connection. */
    fun resendAnswer() {
        val callId = activeCallId ?: return
        val sdp = localAnswer ?: return
        if (!signalRClient.sendAnswer(callId, sdp, UUID.randomUUID().toString(), activeGeneration)) {
            Log.w(TAG, "Answer delivery deferred until signaling is rebound")
        }
        localCandidates.forEach { sendCandidate(callId, it) }
    }

    private fun sendCandidate(callId: String, candidate: IceCandidate) {
        signalRClient.sendIceCandidate(callId, org.json.JSONObject().put("candidate", candidate.sdp)
            .put("sdpMid", candidate.sdpMid).put("sdpMLineIndex", candidate.sdpMLineIndex),
            UUID.randomUUID().toString(), activeGeneration)
    }

    private fun failIfCurrent(sessionEpoch: Int, error: String) {
        dispatch { if (epoch == sessionEpoch) fail(error) }
    }
    private fun fail(error: String) {
        Log.e(TAG, error)
        stop()
        listener?.onMediaFailed()
    }

    fun stop() {
        epoch++
        activeCallId = null
        connected = false
        remoteDescriptionSet = false
        localAnswer = null
        queuedCandidates.clear()
        localCandidates.clear()
        val oldPeer = peer
        peer = null
        oldPeer?.close()
        oldPeer?.dispose()
        localAudio?.dispose()
        localAudio = null
        audioSource?.dispose()
        audioSource = null
        factory?.dispose()
        factory = null
    }

    private open class SimpleSdpObserver : SdpObserver {
        override fun onCreateSuccess(sdp: SessionDescription) {}
        override fun onSetSuccess() {}
        override fun onCreateFailure(error: String) {}
        override fun onSetFailure(error: String) {}
    }
}

data class NativeIceServer(val urls: List<String>, val username: String? = null, val credential: String? = null)
