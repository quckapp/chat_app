import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../services/livekit_service.dart';
import '../../widgets/call/call_controls.dart';

/// Full-screen call UI backed by a LiveKit room connection.
///
/// Expects a pre-fetched [token] and the LiveKit server [livekitUrl].
/// Connects on init and pops the route when the room disconnects.
class LiveKitCallScreen extends StatefulWidget {
  final String callId;
  final String livekitUrl;
  final String token;
  final String roomName;
  final bool isVideoCall;

  const LiveKitCallScreen({
    super.key,
    required this.callId,
    required this.livekitUrl,
    required this.token,
    required this.roomName,
    this.isVideoCall = true,
  });

  @override
  State<LiveKitCallScreen> createState() => _LiveKitCallScreenState();
}

class _LiveKitCallScreenState extends State<LiveKitCallScreen> {
  final LiveKitService _livekitService = LiveKitService();
  bool _isConnecting = true;
  bool _isMicEnabled = true;
  bool _isCameraEnabled = true;
  String? _errorMessage;
  final List<RemoteParticipant> _remoteParticipants = [];

  @override
  void initState() {
    super.initState();
    _isCameraEnabled = widget.isVideoCall;
    _connectToRoom();
  }

  Future<void> _connectToRoom() async {
    try {
      final room = await _livekitService.connect(
        url: widget.livekitUrl,
        token: widget.token,
        enableVideo: widget.isVideoCall,
        enableAudio: true,
      );

      _livekitService.onRoomEvent((event) {
        if (event is ParticipantConnectedEvent) {
          setState(() {
            _remoteParticipants.add(event.participant);
          });
        } else if (event is ParticipantDisconnectedEvent) {
          setState(() {
            _remoteParticipants.remove(event.participant);
          });
        } else if (event is RoomDisconnectedEvent) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        } else if (event is TrackSubscribedEvent ||
            event is TrackUnsubscribedEvent ||
            event is TrackMutedEvent ||
            event is TrackUnmutedEvent) {
          // Refresh UI when tracks change
          if (mounted) setState(() {});
        }
      });

      // Add existing remote participants
      setState(() {
        _remoteParticipants.addAll(room.remoteParticipants.values);
        _isConnecting = false;
      });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _errorMessage = 'Failed to connect: $e';
      });
    }
  }

  @override
  void dispose() {
    _livekitService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnecting) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote participants grid
            _buildParticipantGrid(),

            // Local participant (small overlay)
            if (widget.isVideoCall)
              Positioned(
                right: 16,
                top: 16,
                width: 120,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildLocalVideo(),
                ),
              ),

            // Reuse the existing CallControls widget from the app
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CallControls(
                isMuted: !_isMicEnabled,
                isVideoEnabled: _isCameraEnabled,
                isSpeakerOn: false,
                onMuteToggle: _onToggleMicrophone,
                onVideoToggle: widget.isVideoCall ? _onToggleCamera : null,
                onSpeakerToggle: null,
                onEndCall: _onEndCall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantGrid() {
    if (_remoteParticipants.isEmpty) {
      return const Center(
        child: Text(
          'Waiting for others to join...',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 120),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _remoteParticipants.length > 1 ? 2 : 1,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _remoteParticipants.length,
      itemBuilder: (context, index) {
        final participant = _remoteParticipants[index];
        return _buildRemoteParticipant(participant);
      },
    );
  }

  Widget _buildRemoteParticipant(RemoteParticipant participant) {
    final videoTrack = participant.videoTrackPublications
        .where((pub) => pub.subscribed && pub.track != null)
        .map((pub) => pub.track as VideoTrack)
        .firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (videoTrack != null)
              VideoTrackRenderer(videoTrack)
            else
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Text(
                    participant.identity.isNotEmpty
                        ? participant.identity[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            // Name label
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  participant.identity,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVideo() {
    final room = _livekitService.room;
    if (room == null) return const SizedBox.shrink();

    final videoTrack = room.localParticipant?.videoTrackPublications
        .where((pub) => pub.track != null)
        .map((pub) => pub.track as VideoTrack)
        .firstOrNull;

    return GestureDetector(
      onTap: () => _livekitService.switchCamera(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: videoTrack != null
              ? VideoTrackRenderer(
                  videoTrack,
                  mirrorMode: VideoViewMirrorMode.mirror,
                )
              : const Center(
                  child: Icon(Icons.videocam_off, color: Colors.white54, size: 32),
                ),
        ),
      ),
    );
  }

  Future<void> _onToggleMicrophone() async {
    await _livekitService.toggleMicrophone();
    setState(() => _isMicEnabled = !_isMicEnabled);
  }

  Future<void> _onToggleCamera() async {
    await _livekitService.toggleCamera();
    setState(() => _isCameraEnabled = !_isCameraEnabled);
  }

  Future<void> _onEndCall() async {
    await _livekitService.disconnect();
    if (mounted) Navigator.of(context).pop();
  }
}
