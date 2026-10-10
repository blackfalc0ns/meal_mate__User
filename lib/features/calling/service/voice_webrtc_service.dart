import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import '../domain/entities/voice_ice_server_entity.dart';

typedef OnLocalIceCandidateCallback = void Function(RTCIceCandidate candidate);
typedef OnConnectionStateChangeCallback = void Function(RTCPeerConnectionState state);

@lazySingleton
class VoiceWebRtcService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  final List<RTCIceCandidate> _earlyIceCandidates = [];
  bool _isRemoteDescriptionSet = false;

  bool _isMuted = false;
  bool _isSpeakerOn = false;

  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isInitialized => _peerConnection != null;

  OnLocalIceCandidateCallback? onLocalIceCandidate;
  OnConnectionStateChangeCallback? onConnectionStateChange;

  Future<void> initializePeerConnection({
    required List<VoiceIceServerEntity> iceServers,
  }) async {
    await cleanup();

    final rtcIceServers = <Map<String, dynamic>>[];
    for (final server in iceServers) {
      if (server.urls.isEmpty) continue;
      final serverMap = <String, dynamic>{
        'urls': server.urls.length == 1 ? server.urls.first : server.urls,
      };
      if (server.username != null && server.username!.isNotEmpty) {
        serverMap['username'] = server.username;
      }
      if (server.credential != null && server.credential!.isNotEmpty) {
        serverMap['credential'] = server.credential;
      }
      rtcIceServers.add(serverMap);
    }

    final configuration = <String, dynamic>{
      'iceServers': rtcIceServers,
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null && candidate.candidate!.isNotEmpty) {
        onLocalIceCandidate?.call(candidate);
      }
    };

    _peerConnection!.onConnectionState = (state) {
      debugPrint('[WebRTC] Connection state: $state');
      onConnectionStateChange?.call(state);
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    for (final track in _localStream!.getAudioTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }
  }

  Future<String> handleRemoteOfferAndCreateAnswer(String offerSdp) async {
    final pc = _peerConnection;
    if (pc == null) {
      throw StateError('Peer connection not initialized');
    }

    final remoteDesc = RTCSessionDescription(offerSdp, 'offer');
    await pc.setRemoteDescription(remoteDesc);
    _isRemoteDescriptionSet = true;

    // Drain queued early ICE candidates
    for (final candidate in _earlyIceCandidates) {
      try {
        await pc.addCandidate(candidate);
      } catch (e) {
        debugPrint('[WebRTC] Error adding buffered ICE candidate: $e');
      }
    }
    _earlyIceCandidates.clear();

    final answer = await pc.createAnswer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 0,
    });
    await pc.setLocalDescription(answer);

    return answer.sdp ?? '';
  }

  Future<void> addRemoteIceCandidate({
    required String candidateStr,
    String? sdpMid,
    int? sdpMLineIndex,
  }) async {
    final candidate = RTCIceCandidate(candidateStr, sdpMid, sdpMLineIndex);

    if (!_isRemoteDescriptionSet || _peerConnection == null) {
      _earlyIceCandidates.add(candidate);
      return;
    }

    try {
      await _peerConnection!.addCandidate(candidate);
    } catch (e) {
      debugPrint('[WebRTC] Error adding ICE candidate: $e');
    }
  }

  Future<void> setMicrophoneMute(bool muted) async {
    _isMuted = muted;
    if (_localStream != null) {
      for (final track in _localStream!.getAudioTracks()) {
        track.enabled = !muted;
      }
    }
  }

  Future<void> setSpeakerphoneOn(bool enableSpeaker) async {
    _isSpeakerOn = enableSpeaker;
    if (_localStream != null) {
      for (final track in _localStream!.getAudioTracks()) {
        track.enableSpeakerphone(enableSpeaker);
      }
    }
  }

  Future<void> cleanup() async {
    _isRemoteDescriptionSet = false;
    _earlyIceCandidates.clear();

    if (_localStream != null) {
      for (final track in _localStream!.getTracks()) {
        try {
          track.stop();
        } catch (_) {}
      }
      try {
        await _localStream!.dispose();
      } catch (_) {}
      _localStream = null;
    }

    if (_peerConnection != null) {
      try {
        await _peerConnection!.close();
        await _peerConnection!.dispose();
      } catch (_) {}
      _peerConnection = null;
    }

    _isMuted = false;
    _isSpeakerOn = false;
  }
}
