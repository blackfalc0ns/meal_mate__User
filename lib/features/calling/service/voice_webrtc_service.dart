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
  MediaStream? _remoteStream;

  final List<RTCIceCandidate> _earlyIceCandidates = [];
  bool _isRemoteDescriptionSet = false;

  bool _isMuted = false;
  bool _isSpeakerOn = false;
  int _resourceEpoch = 0;

  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isInitialized => _peerConnection != null;
  bool get isRemoteDescriptionSet => _isRemoteDescriptionSet;
  int get bufferedCandidatesCount => _earlyIceCandidates.length;

  OnLocalIceCandidateCallback? onLocalIceCandidate;
  OnConnectionStateChangeCallback? onConnectionStateChange;

  Future<void> initializePeerConnection({
    required List<VoiceIceServerEntity> iceServers,
  }) async {
    await cleanup();
    final epoch = _resourceEpoch;

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

    debugPrint('[WebRTC] Initializing PeerConnection with ${rtcIceServers.length} ICE server configs');

    final configuration = <String, dynamic>{
      'iceServers': rtcIceServers,
      'sdpSemantics': 'unified-plan',
    };

    final pc = await createPeerConnection(configuration);
    if (epoch != _resourceEpoch) {
      await pc.close();
      await pc.dispose();
      return;
    }
    _peerConnection = pc;

    _peerConnection!.onIceCandidate = (candidate) {
      if (epoch != _resourceEpoch) return;
      if (candidate.candidate != null && candidate.candidate!.isNotEmpty) {
        debugPrint('[WebRTC] Generated local ICE candidate (mid: ${candidate.sdpMid}, mLine: ${candidate.sdpMLineIndex})');
        onLocalIceCandidate?.call(candidate);
      }
    };

    _peerConnection!.onConnectionState = (state) {
      if (epoch != _resourceEpoch) return;
      debugPrint('[WebRTC] Connection state: $state');
      onConnectionStateChange?.call(state);
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (epoch != _resourceEpoch) return;
      debugPrint('[WebRTC] Remote track received: kind=${event.track.kind}, id=${event.track.id}, enabled=${event.track.enabled}');
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
      }
    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      if (epoch != _resourceEpoch) return;
      debugPrint('[WebRTC] Remote stream added: id=${stream.id}, tracks=${stream.getAudioTracks().length}');
      _remoteStream = stream;
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': false,
      });
      if (epoch != _resourceEpoch) {
        for (final track in stream.getTracks()) {
          track.stop();
        }
        await stream.dispose();
        return;
      }
      _localStream = stream;

      final audioTracks = _localStream!.getAudioTracks();
      debugPrint('[WebRTC] Local audio stream acquired with ${audioTracks.length} audio tracks');
      for (final track in audioTracks) {
        if (epoch != _resourceEpoch) return;
        await _peerConnection!.addTrack(track, _localStream!);
      }
    } catch (e) {
      debugPrint('[WebRTC] Failed to acquire local audio stream or add audio track: $e');
      if (epoch == _resourceEpoch) await cleanup();
      rethrow;
    }
  }

  Future<String> handleRemoteOfferAndCreateAnswer(String offerSdp) async {
    final pc = _peerConnection;
    if (pc == null) {
      throw StateError('Peer connection not initialized');
    }

    debugPrint('[WebRTC] Setting remote description from offer (sdp length: ${offerSdp.length})');
    final remoteDesc = RTCSessionDescription(offerSdp, 'offer');
    await pc.setRemoteDescription(remoteDesc);
    _isRemoteDescriptionSet = true;

    // Drain queued early ICE candidates
    debugPrint('[WebRTC] Draining ${_earlyIceCandidates.length} buffered ICE candidates');
    for (final candidate in _earlyIceCandidates) {
      try {
        await pc.addCandidate(candidate);
        debugPrint('[WebRTC] Added buffered candidate (mid: ${candidate.sdpMid}, mLine: ${candidate.sdpMLineIndex})');
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
    debugPrint('[WebRTC] Answer created and local description set');

    return answer.sdp ?? '';
  }

  Future<void> addRemoteIceCandidate({
    required String candidateStr,
    String? sdpMid,
    int? sdpMLineIndex,
  }) async {
    final candidate = RTCIceCandidate(candidateStr, sdpMid, sdpMLineIndex);

    if (!_isRemoteDescriptionSet || _peerConnection == null) {
      if (!_earlyIceCandidates.any((c) => c.candidate == candidateStr)) {
        _earlyIceCandidates.add(candidate);
        debugPrint('[WebRTC] Buffered early ICE candidate (mid: $sdpMid, mLine: $sdpMLineIndex, queue: ${_earlyIceCandidates.length})');
      }
      return;
    }

    try {
      await _peerConnection!.addCandidate(candidate);
      debugPrint('[WebRTC] Added remote ICE candidate (mid: $sdpMid, mLine: $sdpMLineIndex)');
    } catch (e) {
      debugPrint('[WebRTC] Error adding ICE candidate: $e');
    }
  }

  Future<void> setMicrophoneMute(bool muted) async {
    _isMuted = muted;
    debugPrint('[WebRTC] setMicrophoneMute: $muted');
    if (_localStream != null) {
      for (final track in _localStream!.getAudioTracks()) {
        track.enabled = !muted;
      }
    }
  }

  Future<void> setSpeakerphoneOn(bool enableSpeaker) async {
    _isSpeakerOn = enableSpeaker;
    debugPrint('[WebRTC] setSpeakerphoneOn: $enableSpeaker');
    try {
      Helper.setSpeakerphoneOn(enableSpeaker);
    } catch (e) {
      debugPrint('[WebRTC] Helper.setSpeakerphoneOn failed: $e');
    }
    if (_localStream != null) {
      for (final track in _localStream!.getAudioTracks()) {
        try {
          track.enableSpeakerphone(enableSpeaker);
        } catch (_) {}
      }
    }
  }

  Future<void> cleanup() async {
    _resourceEpoch++;
    debugPrint('[WebRTC] Cleaning up WebRTC resources');
    _isRemoteDescriptionSet = false;
    _earlyIceCandidates.clear();

    final localStream = _localStream;
    final remoteStream = _remoteStream;
    final peerConnection = _peerConnection;
    _localStream = null;
    _remoteStream = null;
    _peerConnection = null;

    if (localStream != null) {
      for (final track in localStream.getTracks()) {
        try {
          track.stop();
        } catch (_) {}
      }
      try {
        await localStream.dispose();
      } catch (_) {}
    }

    if (remoteStream != null) {
      try {
        await remoteStream.dispose();
      } catch (_) {}
    }

    if (peerConnection != null) {
      try {
        await peerConnection.close();
        await peerConnection.dispose();
      } catch (_) {}
    }

    _isMuted = false;
    _isSpeakerOn = false;
  }
}
