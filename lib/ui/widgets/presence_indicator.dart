import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../models/presence.dart';

/// A small dot indicator showing user online/offline status
/// Uses AnimatedContainer for smooth color transitions
class PresenceIndicator extends StatelessWidget {
  final String userId;
  final double size;
  final bool showBorder;
  final bool enablePulse;
  final Duration transitionDuration;

  const PresenceIndicator({
    super.key,
    required this.userId,
    this.size = 12,
    this.showBorder = true,
    this.enablePulse = false,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PresenceBloc, PresenceState>(
      builder: (context, state) {
        final presence = state.getPresence(userId);
        final status = presence?.status ?? PresenceStatus.offline;
        final isOnline = status == PresenceStatus.online;

        Widget indicator = AnimatedContainer(
          duration: transitionDuration,
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            shape: BoxShape.circle,
            border: showBorder
                ? Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  )
                : null,
          ),
        );

        if (enablePulse && isOnline) {
          indicator = _PulsingIndicator(
            size: size,
            color: _getStatusColor(status),
            child: indicator,
          );
        }

        return indicator;
      },
    );
  }

  Color _getStatusColor(PresenceStatus status) {
    switch (status) {
      case PresenceStatus.online:
        return Colors.green;
      case PresenceStatus.away:
        return Colors.orange;
      case PresenceStatus.offline:
        return Colors.grey;
    }
  }
}

/// Internal pulsing indicator widget
class _PulsingIndicator extends StatefulWidget {
  final Widget child;
  final double size;
  final Color color;

  const _PulsingIndicator({
    required this.child,
    required this.size,
    required this.color,
  });

  @override
  State<_PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<_PulsingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: widget.size * _pulseAnimation.value,
                height: widget.size * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(_opacityAnimation.value),
                ),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

/// Presence indicator that can be positioned on an avatar
class PresenceIndicatorPositioned extends StatelessWidget {
  final String userId;
  final Widget child;
  final double indicatorSize;

  const PresenceIndicatorPositioned({
    super.key,
    required this.userId,
    required this.child,
    this.indicatorSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          bottom: 0,
          child: PresenceIndicator(
            userId: userId,
            size: indicatorSize,
          ),
        ),
      ],
    );
  }
}
