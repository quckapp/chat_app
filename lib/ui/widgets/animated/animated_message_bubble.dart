import 'package:flutter/material.dart';

/// Animated message bubble with send/receive animations
class AnimatedMessageBubble extends StatefulWidget {
  final Widget child;
  final bool isSent;
  final Duration duration;
  final Curve curve;
  final bool animate;

  const AnimatedMessageBubble({
    super.key,
    required this.child,
    this.isSent = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isSent ? 0.3 : -0.3, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Reactive message bubble that responds to stream events
class ReactiveMessageBubble extends StatefulWidget {
  final Widget child;
  final Stream<MessageAnimationEvent>? eventStream;
  final bool isSent;

  const ReactiveMessageBubble({
    super.key,
    required this.child,
    this.eventStream,
    this.isSent = true,
  });

  @override
  State<ReactiveMessageBubble> createState() => _ReactiveMessageBubbleState();
}

class _ReactiveMessageBubbleState extends State<ReactiveMessageBubble>
    with TickerProviderStateMixin {
  late final AnimationController _sendController;
  late final AnimationController _highlightController;
  late final AnimationController _reactionController;

  late final Animation<double> _sendScale;
  late final Animation<double> _highlightOpacity;
  late final Animation<double> _reactionScale;

  @override
  void initState() {
    super.initState();

    _sendController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _sendScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _sendController, curve: Curves.easeOutBack),
    );

    _highlightOpacity = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(parent: _highlightController, curve: Curves.easeInOut),
    );

    _reactionScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(_reactionController);

    // Initial send animation
    _sendController.forward();

    // Listen to event stream
    widget.eventStream?.listen(_handleEvent);
  }

  void _handleEvent(MessageAnimationEvent event) {
    switch (event) {
      case MessageAnimationEvent.highlight:
        _highlightController.forward().then((_) => _highlightController.reverse());
        break;
      case MessageAnimationEvent.reaction:
        _reactionController.forward(from: 0);
        break;
      case MessageAnimationEvent.sending:
        _sendController.forward(from: 0);
        break;
      case MessageAnimationEvent.sent:
        // Could add a checkmark animation here
        break;
      case MessageAnimationEvent.delivered:
        break;
      case MessageAnimationEvent.read:
        break;
    }
  }

  @override
  void dispose() {
    _sendController.dispose();
    _highlightController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _sendController,
        _highlightController,
        _reactionController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _sendScale.value * _reactionScale.value,
          alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(_highlightOpacity.value),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

enum MessageAnimationEvent {
  sending,
  sent,
  delivered,
  read,
  highlight,
  reaction,
}

/// Message send animation with flying effect
class FlyingMessageAnimation extends StatefulWidget {
  final Widget child;
  final Offset startOffset;
  final Offset endOffset;
  final VoidCallback? onComplete;

  const FlyingMessageAnimation({
    super.key,
    required this.child,
    required this.startOffset,
    required this.endOffset,
    this.onComplete,
  });

  @override
  State<FlyingMessageAnimation> createState() => _FlyingMessageAnimationState();
}

class _FlyingMessageAnimationState extends State<FlyingMessageAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _positionAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward().whenComplete(() {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
