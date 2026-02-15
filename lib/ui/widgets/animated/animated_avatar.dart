import 'package:flutter/material.dart';

/// Animated avatar with Hero transition support
class AnimatedAvatar extends StatefulWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final String heroTag;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool enableHero;
  final bool showPulse;

  const AnimatedAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    required this.size,
    required this.heroTag,
    this.backgroundColor,
    this.onTap,
    this.enableHero = true,
    this.showPulse = false,
  });

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showPulse != oldWidget.showPulse) {
      if (widget.showPulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = _buildAvatar();

    if (widget.showPulse) {
      avatar = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: avatar,
      );
    }

    if (widget.enableHero) {
      avatar = Hero(
        tag: widget.heroTag,
        flightShuttleBuilder: _flightShuttleBuilder,
        child: avatar,
      );
    }

    if (widget.onTap != null) {
      avatar = GestureDetector(
        onTap: widget.onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor ?? Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: widget.imageUrl != null
            ? Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
              )
            : _buildInitials(),
      ),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        widget.initials ?? '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2 * curvedAnimation.value),
                blurRadius: 8 * curvedAnimation.value,
                spreadRadius: 2 * curvedAnimation.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: _buildAvatar(),
    );
  }
}

/// Avatar with scale animation on tap
class TappableAvatar extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleOnTap;

  const TappableAvatar({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleOnTap = 0.95,
  });

  @override
  State<TappableAvatar> createState() => _TappableAvatarState();
}

class _TappableAvatarState extends State<TappableAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnTap,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Avatar group with overlap animation
class AnimatedAvatarGroup extends StatefulWidget {
  final List<AvatarData> avatars;
  final double avatarSize;
  final double overlap;
  final int maxVisible;
  final Duration animationDuration;

  const AnimatedAvatarGroup({
    super.key,
    required this.avatars,
    this.avatarSize = 40,
    this.overlap = 0.3,
    this.maxVisible = 3,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedAvatarGroup> createState() => _AnimatedAvatarGroupState();
}

class _AnimatedAvatarGroupState extends State<AnimatedAvatarGroup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedAvatarGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.avatars.length != widget.avatars.length) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = widget.avatars.take(widget.maxVisible).toList();
    final remaining = widget.avatars.length - widget.maxVisible;
    final offsetAmount = widget.avatarSize * (1 - widget.overlap);

    return SizedBox(
      width: offsetAmount * (visibleAvatars.length - 1) +
          widget.avatarSize +
          (remaining > 0 ? offsetAmount : 0),
      height: widget.avatarSize,
      child: Stack(
        children: [
          ...visibleAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;

            final animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.1,
                0.5 + index * 0.1,
                curve: Curves.easeOutBack,
              ),
            );

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Positioned(
                  left: offsetAmount * index * animation.value,
                  child: Transform.scale(
                    scale: animation.value,
                    child: child,
                  ),
                );
              },
              child: _buildAvatar(avatar),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: offsetAmount * visibleAvatars.length,
              child: _buildRemainingCount(remaining),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AvatarData data) {
    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: data.backgroundColor ?? Colors.grey,
      ),
      child: ClipOval(
        child: data.imageUrl != null
            ? Image.network(data.imageUrl!, fit: BoxFit.cover)
            : Center(
                child: Text(
                  data.initials ?? '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.avatarSize * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildRemainingCount(int count) {
    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.grey[300],
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: widget.avatarSize * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AvatarData {
  final String? imageUrl;
  final String? initials;
  final Color? backgroundColor;

  const AvatarData({
    this.imageUrl,
    this.initials,
    this.backgroundColor,
  });
}
