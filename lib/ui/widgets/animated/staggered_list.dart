import 'package:flutter/material.dart';

/// Staggered list animation for chat messages and conversation lists
class StaggeredListAnimation extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Curve curve;
  final Axis direction;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final bool reverse;
  final ScrollPhysics? physics;

  const StaggeredListAnimation({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    this.direction = Axis.vertical,
    this.scrollController,
    this.padding,
    this.reverse = false,
    this.physics,
  });

  @override
  State<StaggeredListAnimation> createState() => _StaggeredListAnimationState();
}

class _StaggeredListAnimationState extends State<StaggeredListAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    final totalDuration = widget.itemDuration +
        (widget.staggerDelay * (widget.itemCount - 1).clamp(0, 20));

    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    _fadeAnimations.clear();
    _slideAnimations.clear();

    for (var i = 0; i < widget.itemCount; i++) {
      final startTime = (widget.staggerDelay.inMilliseconds * i) /
          totalDuration.inMilliseconds;
      final endTime =
          startTime + (widget.itemDuration.inMilliseconds / totalDuration.inMilliseconds);

      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startTime.clamp(0.0, 1.0),
              endTime.clamp(0.0, 1.0),
              curve: widget.curve,
            ),
          ),
        ),
      );

      final slideBegin = widget.direction == Axis.vertical
          ? const Offset(0, 0.2)
          : const Offset(0.2, 0);

      _slideAnimations.add(
        Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startTime.clamp(0.0, 1.0),
              endTime.clamp(0.0, 1.0),
              curve: widget.curve,
            ),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void didUpdateWidget(StaggeredListAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.itemCount != widget.itemCount) {
      _controller.dispose();
      _initAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: widget.padding,
      reverse: widget.reverse,
      physics: widget.physics,
      itemCount: widget.itemCount,
      scrollDirection: widget.direction,
      itemBuilder: (context, index) {
        if (index >= _fadeAnimations.length) {
          return widget.itemBuilder(context, index);
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: child,
              ),
            );
          },
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }
}

/// Single staggered item wrapper
class StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDuration;
  final Duration staggerDelay;
  final Curve curve;
  final Offset slideOffset;
  final bool animate;

  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.baseDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0, 0.1),
    this.animate = true,
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.baseDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    if (widget.animate) {
      final delay = widget.staggerDelay * widget.index;
      Future.delayed(delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Animated sliver list for chat messages
class AnimatedSliverList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Curve curve;

  const AnimatedSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedSliverList> createState() => _AnimatedSliverListState();
}

class _AnimatedSliverListState extends State<AnimatedSliverList> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return StaggeredItem(
            index: index,
            baseDuration: widget.itemDuration,
            staggerDelay: widget.staggerDelay,
            curve: widget.curve,
            child: widget.itemBuilder(context, index),
          );
        },
        childCount: widget.itemCount,
      ),
    );
  }
}

/// Grid with staggered animation
class StaggeredGridAnimation extends StatefulWidget {
  final int itemCount;
  final int crossAxisCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Curve curve;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const StaggeredGridAnimation({
    super.key,
    required this.itemCount,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 1,
    this.padding,
  });

  @override
  State<StaggeredGridAnimation> createState() => _StaggeredGridAnimationState();
}

class _StaggeredGridAnimationState extends State<StaggeredGridAnimation> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          baseDuration: widget.itemDuration,
          staggerDelay: widget.staggerDelay,
          curve: widget.curve,
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }
}

/// Animated list item removal
class AnimatedListItemRemoval extends StatefulWidget {
  final Widget child;
  final bool removed;
  final Duration duration;
  final VoidCallback? onRemoved;

  const AnimatedListItemRemoval({
    super.key,
    required this.child,
    required this.removed,
    this.duration = const Duration(milliseconds: 300),
    this.onRemoved,
  });

  @override
  State<AnimatedListItemRemoval> createState() => _AnimatedListItemRemovalState();
}

class _AnimatedListItemRemovalState extends State<AnimatedListItemRemoval>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(AnimatedListItemRemoval oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.removed && !oldWidget.removed) {
      _controller.forward().whenComplete(() {
        widget.onRemoved?.call();
      });
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
        return SizeTransition(
          sizeFactor: _sizeAnimation,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
