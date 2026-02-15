import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/attachment.dart';

/// Widget to display audio/voice messages
class AudioMessage extends StatefulWidget {
  final Attachment audio;
  final bool isSent;

  const AudioMessage({
    super.key,
    required this.audio,
    required this.isSent,
  });

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool _isPlaying = false;
  double _progress = 0.0;
  int _currentSeconds = 0;
  Timer? _progressTimer;

  int get _duration => widget.audio.duration ?? 0;

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;

      if (_isPlaying) {
        // Simulate playback with timer
        _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (_currentSeconds >= _duration) {
            _stopPlayback();
          } else {
            setState(() {
              _currentSeconds = (_progress * _duration).round();
              _progress += 0.1 / _duration;
              if (_progress > 1.0) _progress = 1.0;
            });
          }
        });
      } else {
        _progressTimer?.cancel();
      }
    });
  }

  void _stopPlayback() {
    _progressTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _progress = 0.0;
      _currentSeconds = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayDuration = _isPlaying ? _currentSeconds : _duration;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.isSent
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.isSent ? Colors.white : AppColors.primary,
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Waveform and progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Waveform visualization
                SizedBox(
                  height: 28,
                  child: _AudioWaveform(
                    progress: _progress,
                    isSent: widget.isSent,
                  ),
                ),

                const SizedBox(height: 4),

                // Duration
                Text(
                  _formatDuration(displayDuration),
                  style: TextStyle(
                    color: widget.isSent
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Speed button
          GestureDetector(
            onTap: () {
              // TODO: Cycle playback speed
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.isSent
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '1x',
                style: TextStyle(
                  color: widget.isSent ? Colors.white : AppColors.grey700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Waveform visualization for audio messages
class _AudioWaveform extends StatelessWidget {
  final double progress;
  final bool isSent;

  const _AudioWaveform({
    required this.progress,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    // Generate sample waveform data
    const barCount = 40;
    final bars = List.generate(barCount, (i) {
      // Create a pseudo-random pattern based on index
      final height = 0.3 + 0.7 * ((i * 7 + 13) % 10) / 10;
      return height;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(barCount, (index) {
        final isPlayed = index / barCount <= progress;
        final barHeight = bars[index] * 24;

        return Container(
          width: 2,
          height: barHeight,
          decoration: BoxDecoration(
            color: isPlayed
                ? (isSent ? Colors.white : AppColors.primary)
                : (isSent ? Colors.white.withValues(alpha: 0.3) : AppColors.grey300),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

/// Voice recorder widget for input
class VoiceRecorder extends StatefulWidget {
  final void Function(String path, int duration)? onRecordComplete;
  final VoidCallback? onCancel;

  const VoiceRecorder({
    super.key,
    this.onRecordComplete,
    this.onCancel,
  });

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordingSeconds++);
    });

    // TODO: Start actual audio recording
  }

  void _stopRecording() {
    _timer?.cancel();
    _pulseController.stop();

    setState(() => _isRecording = false);

    // TODO: Stop recording and get file path
    widget.onRecordComplete?.call('/path/to/recording.m4a', _recordingSeconds);
  }

  void _cancelRecording() {
    _timer?.cancel();
    _pulseController.stop();

    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
    });

    widget.onCancel?.call();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      return GestureDetector(
        onLongPress: _startRecording,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cancel button
          GestureDetector(
            onTap: _cancelRecording,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            ),
          ),

          const SizedBox(width: 12),

          // Recording indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.5 + 0.5 * _pulseController.value),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // Duration
          Text(
            _formatDuration(_recordingSeconds),
            style: TextStyle(
              color: AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 16),

          // Send button
          GestureDetector(
            onTap: _stopRecording,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
