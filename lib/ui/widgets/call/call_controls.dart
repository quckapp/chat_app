import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class CallControls extends StatelessWidget {
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isVideoEnabled;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onSpeakerToggle;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onEndCall;

  const CallControls({
    super.key,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isVideoEnabled = false,
    this.onMuteToggle,
    this.onSpeakerToggle,
    this.onVideoToggle,
    this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: isMuted ? Icons.mic_off : Icons.mic,
              label: isMuted ? 'Unmute' : 'Mute',
              isActive: isMuted,
              onPressed: onMuteToggle,
            ),
            _buildControlButton(
              icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
              label: 'Video',
              isActive: isVideoEnabled,
              onPressed: onVideoToggle,
            ),
            _buildControlButton(
              icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
              label: 'Speaker',
              isActive: isSpeakerOn,
              onPressed: onSpeakerToggle,
            ),
            _buildEndCallButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.call_end, color: Colors.white, size: 24),
            onPressed: onEndCall,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'End',
          style: AppTypography.labelSmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
