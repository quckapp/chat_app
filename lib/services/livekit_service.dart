import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

/// Service for managing LiveKit video/audio call connections.
///
/// Wraps the LiveKit SDK to provide a clean interface for connecting to
/// rooms, managing local media tracks, and listening to room events.
class LiveKitService {
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  bool _usingFrontCamera = true;

  Room? get room => _room;
  bool get isConnected => _room?.connectionState == ConnectionState.connected;

  /// Connect to a LiveKit room with the given token.
  /// The token is obtained from the BFF: POST /api/v1/calls/:id/token
  Future<Room> connect({
    required String url,
    required String token,
    bool enableVideo = true,
    bool enableAudio = true,
  }) async {
    debugPrint('LiveKitService: Connecting to $url');

    _room = Room(
      roomOptions: RoomOptions(
        defaultCameraCaptureOptions: CameraCaptureOptions(
          maxFrameRate: 30,
        ),
        defaultAudioCaptureOptions: const AudioCaptureOptions(
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
        ),
        defaultVideoPublishOptions: const VideoPublishOptions(
          simulcast: true,
        ),
      ),
    );
    _listener = _room!.createListener();

    final connectOptions = ConnectOptions(
      autoSubscribe: true,
    );

    await _room!.connect(
      url,
      token,
      connectOptions: connectOptions,
    );

    debugPrint('LiveKitService: Connected to room');

    // Enable local tracks
    if (enableAudio) {
      await _room!.localParticipant?.setMicrophoneEnabled(true);
    }
    if (enableVideo) {
      await _room!.localParticipant?.setCameraEnabled(true);
    }

    return _room!;
  }

  /// Disconnect from the current room.
  Future<void> disconnect() async {
    debugPrint('LiveKitService: Disconnecting');
    await _room?.disconnect();
    _listener?.dispose();
    _room = null;
    _listener = null;
  }

  /// Toggle microphone on/off.
  Future<void> toggleMicrophone() async {
    if (_room == null) return;
    final participant = _room!.localParticipant;
    if (participant == null) return;

    final enabled = participant.isMicrophoneEnabled();
    await participant.setMicrophoneEnabled(!enabled);
    debugPrint('LiveKitService: Microphone ${!enabled ? "enabled" : "disabled"}');
  }

  /// Toggle camera on/off.
  Future<void> toggleCamera() async {
    if (_room == null) return;
    final participant = _room!.localParticipant;
    if (participant == null) return;

    final enabled = participant.isCameraEnabled();
    await participant.setCameraEnabled(!enabled);
    debugPrint('LiveKitService: Camera ${!enabled ? "enabled" : "disabled"}');
  }

  /// Switch between front and back camera.
  ///
  /// Disables the camera and re-enables it with the opposite facing mode.
  Future<void> switchCamera() async {
    if (_room == null) return;
    final participant = _room!.localParticipant;
    if (participant == null) return;

    _usingFrontCamera = !_usingFrontCamera;
    await participant.setCameraEnabled(false);
    await participant.setCameraEnabled(true, cameraCaptureOptions: CameraCaptureOptions(
      cameraPosition: _usingFrontCamera ? CameraPosition.front : CameraPosition.back,
    ));
    debugPrint('LiveKitService: Switched to ${_usingFrontCamera ? "front" : "back"} camera');
  }

  /// Toggle screen sharing.
  Future<void> toggleScreenShare() async {
    if (_room == null) return;
    final participant = _room!.localParticipant;
    if (participant == null) return;

    final enabled = participant.isScreenShareEnabled();
    await participant.setScreenShareEnabled(!enabled);
    debugPrint('LiveKitService: Screen share ${!enabled ? "enabled" : "disabled"}');
  }

  /// Listen to room events.
  void onRoomEvent(void Function(RoomEvent event) callback) {
    _listener?.on<RoomEvent>((event) {
      callback(event);
    });
  }

  /// Dispose resources.
  void dispose() {
    debugPrint('LiveKitService: Disposing');
    _listener?.dispose();
    _room?.disconnect();
    _room = null;
    _listener = null;
  }
}
