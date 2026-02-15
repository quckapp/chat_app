import 'dart:async';
import 'package:flutter/material.dart';

/// Pulsing animation for notifications, unread indicators, etc.
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool enabled;
  final Curve curve;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.enabled = true,
    this.curve = Curves.easeInOut,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Glow pulse effect
class GlowPulse extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double minRadius;
  final double maxRadius;
  final Duration duration;
  final bool enabled;

  const GlowPulse({
    super.key,
    required this.child,
    this.glowColor = Colors.blue,
    this.minRadius = 0,
    this.maxRadius = 20,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<GlowPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _radiusAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _radiusAnimation = Tween<double>(
      begin: widget.minRadius,
      end: widget.maxRadius,
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

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(GlowPulse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_opacityAnimation.value),
                blurRadius: _radiusAnimation.value,
                spreadRadius: _radiusAnimation.value / 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Ripple effect animation
class RippleEffect extends StatefulWidget {
  final Widget child;
  final Color rippleColor;
  final double size;
  final Duration duration;
  final bool enabled;
  final int rippleCount;

  const RippleEffect({
    super.key,
    required this.child,
    this.rippleColor = Colors.blue,
    this.size = 100,
    this.duration = const Duration(milliseconds: 2000),
    this.enabled = true,
    this.rippleCount = 3,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scaleAnimations;
  late final List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(widget.rippleCount, (index) {
      return AnimationController(
        vsync: this,
        duration: widget.duration,
      );
    });

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    if (widget.enabled) {
      _startRipples();
    }
  }

  void _startRipples() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * (widget.duration.inMilliseconds ~/ widget.rippleCount)), () {
        if (mounted && widget.enabled) {
          _controllers[i].repeat();
        }
      });
    }
  }

  @override
  void didUpdateWidget(RippleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startRipples();
      } else {
        for (final controller in _controllers) {
          controller.stop();
          controller.value = 0;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.enabled)
            ..._controllers.asMap().entries.map((entry) {
              final index = entry.key;
              return AnimatedBuilder(
                animation: _controllers[index],
                builder: (context, _) {
                  return Container(
                    width: widget.size * _scaleAnimations[index].value,
                    height: widget.size * _scaleAnimations[index].value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.rippleColor.withOpacity(_opacityAnimations[index].value),
                        width: 2,
                      ),
                    ),
                  );
                },
              );
            }),
          widget.child,
        ],
      ),
    );
  }
}

/// Unread badge with pulse
class UnreadBadge extends StatelessWidget {
  final int count;
  final Color color;
  final bool pulse;

  const UnreadBadge({
    super.key,
    required this.count,
    this.color = Colors.red,
    this.pulse = true,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 20),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );

    if (pulse) {
      return PulseAnimation(
        minScale: 1.0,
        maxScale: 1.1,
        child: badge,
      );
    }

    return badge;
  }
}

/// Online status indicator with pulse
class OnlinePulseIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final bool isOnline;
  final bool showPulse;

  const OnlinePulseIndicator({
    super.key,
    this.size = 12,
    this.color = Colors.green,
    this.isOnline = true,
    this.showPulse = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? color : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );

    if (isOnline && showPulse) {
      return GlowPulse(
        glowColor: color,
        minRadius: 0,
        maxRadius: size / 2,
        child: indicator,
      );
    }

    return indicator;
  }
}

/// Reactive pulse that responds to stream events
class ReactivePulse extends StatefulWidget {
  final Widget child;
  final Stream<void>? triggerStream;
  final Duration pulseDuration;
  final double maxScale;

  const ReactivePulse({
    super.key,
    required this.child,
    this.triggerStream,
    this.pulseDuration = const Duration(milliseconds: 300),
    this.maxScale = 1.2,
  });

  @override
  State<ReactivePulse> createState() => _ReactivePulseState();
}

class _ReactivePulseState extends State<ReactivePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.maxScale),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.maxScale, end: 1.0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _subscription = widget.triggerStream?.listen((_) {
      _controller.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(ReactivePulse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.triggerStream != oldWidget.triggerStream) {
      _subscription?.cancel();
      _subscription = widget.triggerStream?.listen((_) {
        _controller.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
