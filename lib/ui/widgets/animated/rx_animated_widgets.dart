import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/animation/rx_animation.dart';

/// StreamBuilder wrapper for RxDart animation streams
class RxAnimatedBuilder extends StatelessWidget {
  final Stream<double> animation;
  final Widget Function(BuildContext context, double value, Widget? child) builder;
  final Widget? child;
  final double initialValue;

  const RxAnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
    this.initialValue = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: animation,
      initialData: initialValue,
      builder: (context, snapshot) {
        return builder(context, snapshot.data ?? initialValue, child);
      },
    );
  }
}

/// Fade animation using RxDart
class RxFadeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool visible;
  final VoidCallback? onComplete;

  const RxFadeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.visible = true,
    this.onComplete,
  });

  @override
  State<RxFadeTransition> createState() => _RxFadeTransitionState();
}

class _RxFadeTransitionState extends State<RxFadeTransition>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final StreamSubscription<AnimationStatus> _statusSubscription;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
    );

    _statusSubscription = _controller.statusStream.listen((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.onComplete?.call();
      }
    });

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(RxFadeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RxAnimatedBuilder(
      animation: _controller.valueStream,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Slide animation using RxDart
class RxSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;
  final Offset endOffset;
  final bool animate;

  const RxSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.beginOffset = const Offset(0, 0.2),
    this.endOffset = Offset.zero,
    this.animate = true,
  });

  @override
  State<RxSlideTransition> createState() => _RxSlideTransitionState();
}

class _RxSlideTransitionState extends State<RxSlideTransition>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<Offset> _offsetStream;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
    );

    _offsetStream = _controller.offsetTween(widget.beginOffset, widget.endOffset);

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset>(
      stream: _offsetStream,
      initialData: widget.animate ? widget.beginOffset : widget.endOffset,
      builder: (context, snapshot) {
        return FractionalTranslation(
          translation: snapshot.data ?? widget.endOffset,
          child: widget.child,
        );
      },
    );
  }
}

/// Scale animation using RxDart
class RxScaleTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double beginScale;
  final double endScale;
  final Alignment alignment;
  final bool animate;

  const RxScaleTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.alignment = Alignment.center,
    this.animate = true,
  });

  @override
  State<RxScaleTransition> createState() => _RxScaleTransitionState();
}

class _RxScaleTransitionState extends State<RxScaleTransition>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<double> _scaleStream;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
    );

    _scaleStream = _controller.doubleTween(widget.beginScale, widget.endScale);

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _scaleStream,
      initialData: widget.animate ? widget.beginScale : widget.endScale,
      builder: (context, snapshot) {
        return Transform.scale(
          scale: snapshot.data ?? widget.endScale,
          alignment: widget.alignment,
          child: widget.child,
        );
      },
    );
  }
}

/// Combined fade and slide animation
class RxFadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset slideOffset;
  final bool visible;
  final VoidCallback? onComplete;

  const RxFadeSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.slideOffset = const Offset(0, 0.1),
    this.visible = true,
    this.onComplete,
  });

  @override
  State<RxFadeSlideTransition> createState() => _RxFadeSlideTransitionState();
}

class _RxFadeSlideTransitionState extends State<RxFadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<({double opacity, Offset offset})> _combinedStream;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
    );

    // Combine opacity and offset into single stream
    _combinedStream = Rx.combineLatest2(
      _controller.valueStream,
      _controller.offsetTween(widget.slideOffset, Offset.zero),
      (opacity, offset) => (opacity: opacity, offset: offset),
    );

    _controller.statusStream.listen((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.onComplete?.call();
      }
    });

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(RxFadeSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return StreamBuilder<({double opacity, Offset offset})>(
      stream: _combinedStream,
      initialData: (
        opacity: widget.visible ? 1.0 : 0.0,
        offset: widget.visible ? Offset.zero : widget.slideOffset,
      ),
      builder: (context, snapshot) {
        final data = snapshot.data!;
        return Opacity(
          opacity: data.opacity,
          child: FractionalTranslation(
            translation: data.offset,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Staggered list item with RxDart
class RxStaggeredListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Curve curve;
  final Offset slideOffset;

  const RxStaggeredListItem({
    super.key,
    required this.child,
    required this.index,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0, 0.1),
  });

  @override
  State<RxStaggeredListItem> createState() => _RxStaggeredListItemState();
}

class _RxStaggeredListItemState extends State<RxStaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<({double opacity, Offset offset})> _animationStream;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.itemDuration,
      curve: widget.curve,
    );

    _animationStream = Rx.combineLatest2(
      _controller.valueStream,
      _controller.offsetTween(widget.slideOffset, Offset.zero),
      (opacity, offset) => (opacity: opacity, offset: offset),
    );

    // Start animation after stagger delay
    final delay = widget.staggerDelay * widget.index;
    _delayTimer = Timer(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<({double opacity, Offset offset})>(
      stream: _animationStream,
      initialData: (opacity: 0.0, offset: widget.slideOffset),
      builder: (context, snapshot) {
        final data = snapshot.data!;
        return Opacity(
          opacity: data.opacity,
          child: FractionalTranslation(
            translation: data.offset,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Pulse animation using RxDart with BehaviorSubject
class RxPulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool enabled;

  const RxPulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.enabled = true,
  });

  @override
  State<RxPulseAnimation> createState() => _RxPulseAnimationState();
}

class _RxPulseAnimationState extends State<RxPulseAnimation>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<double> _scaleStream;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: Curves.easeInOut,
    );

    _scaleStream = _controller.doubleTween(widget.minScale, widget.maxScale);

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RxPulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
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

    return StreamBuilder<double>(
      stream: _scaleStream,
      initialData: 1.0,
      builder: (context, snapshot) {
        return Transform.scale(
          scale: snapshot.data ?? 1.0,
          child: widget.child,
        );
      },
    );
  }
}

/// Color transition using RxDart
class RxColorTransition extends StatefulWidget {
  final Widget Function(BuildContext context, Color color) builder;
  final Color beginColor;
  final Color endColor;
  final Duration duration;
  final Curve curve;
  final bool animate;

  const RxColorTransition({
    super.key,
    required this.builder,
    required this.beginColor,
    required this.endColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.animate = true,
  });

  @override
  State<RxColorTransition> createState() => _RxColorTransitionState();
}

class _RxColorTransitionState extends State<RxColorTransition>
    with SingleTickerProviderStateMixin {
  late final RxAnimationController _controller;
  late final Stream<Color?> _colorStream;

  @override
  void initState() {
    super.initState();
    _controller = RxAnimationController(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
    );

    _colorStream = _controller.colorTween(widget.beginColor, widget.endColor);

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Color?>(
      stream: _colorStream,
      initialData: widget.beginColor,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data ?? widget.beginColor);
      },
    );
  }
}

/// Reactive message bubble animation
class RxMessageBubble extends StatefulWidget {
  final Widget child;
  final Stream<void>? highlightTrigger;
  final Stream<void>? reactionTrigger;
  final bool isSent;

  const RxMessageBubble({
    super.key,
    required this.child,
    this.highlightTrigger,
    this.reactionTrigger,
    this.isSent = true,
  });

  @override
  State<RxMessageBubble> createState() => _RxMessageBubbleState();
}

class _RxMessageBubbleState extends State<RxMessageBubble>
    with TickerProviderStateMixin {
  late final RxAnimationController _enterController;
  late final RxAnimationController _highlightController;
  late final RxAnimationController _reactionController;

  final _compositeSubscription = CompositeSubscription();

  @override
  void initState() {
    super.initState();

    _enterController = RxAnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );

    _highlightController = RxAnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    _reactionController = RxAnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
    );

    // Enter animation
    _enterController.forward();

    // Listen to highlight trigger
    if (widget.highlightTrigger != null) {
      _compositeSubscription.add(
        widget.highlightTrigger!.listen((_) {
          _highlightController.forward().then((_) {
            _highlightController.reverse();
          });
        }),
      );
    }

    // Listen to reaction trigger
    if (widget.reactionTrigger != null) {
      _compositeSubscription.add(
        widget.reactionTrigger!.listen((_) {
          _reactionController.forward(from: 0);
        }),
      );
    }
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    _enterController.dispose();
    _highlightController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: Rx.combineLatestList([
        _enterController.valueStream,
        _highlightController.valueStream,
        _reactionController.doubleTween(1.0, 1.1),
      ]),
      initialData: const [0.0, 0.0, 1.0],
      builder: (context, snapshot) {
        final values = snapshot.data ?? [0.0, 0.0, 1.0];
        final enterValue = values[0];
        final highlightValue = values[1];
        final reactionScale = values[2];

        return Transform.scale(
          scale: enterValue * reactionScale,
          alignment:
              widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: Opacity(
            opacity: enterValue,
            child: Stack(
              children: [
                widget.child,
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.withValues(alpha: highlightValue * 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Subscription manager for RxDart
class CompositeSubscription {
  final List<StreamSubscription> _subscriptions = [];

  void add(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
