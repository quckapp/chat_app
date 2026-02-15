import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'reactive_animation.dart';

/// Mixin for managing multiple animation controllers reactively
mixin ReactiveAnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, ReactiveAnimation> _reactiveAnimations = {};
  final Map<String, CurvedAnimation> _curvedAnimations = {};
  final List<Ticker> _tickers = [];

  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = Ticker(onTick, debugLabel: 'created by $runtimeType');
    _tickers.add(ticker);
    return ticker;
  }

  /// Create and register an animation controller
  AnimationController createAnimationController({
    required String name,
    required Duration duration,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    double? value,
    Duration? reverseDuration,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
      value: value,
      animationBehavior: animationBehavior,
    );

    _controllers[name] = controller;
    _reactiveAnimations[name] = ReactiveAnimation.fromController(controller);

    return controller;
  }

  /// Get a registered controller by name
  AnimationController? getController(String name) => _controllers[name];

  /// Get reactive stream for an animation
  Stream<double>? getAnimationStream(String name) =>
      _reactiveAnimations[name]?.stream;

  /// Create a curved animation from a registered controller
  CurvedAnimation createCurvedAnimation({
    required String name,
    required String controllerName,
    required Curve curve,
    Curve? reverseCurve,
  }) {
    final controller = _controllers[controllerName];
    if (controller == null) {
      throw ArgumentError('Controller "$controllerName" not found');
    }

    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    _curvedAnimations[name] = curvedAnimation;
    return curvedAnimation;
  }

  /// Get a curved animation by name
  CurvedAnimation? getCurvedAnimation(String name) => _curvedAnimations[name];

  /// Create staggered animations from a single controller
  List<Animation<double>> createStaggeredAnimations({
    required String controllerName,
    required int count,
    required double overlap,
    Curve curve = Curves.easeInOut,
  }) {
    final controller = _controllers[controllerName];
    if (controller == null) {
      throw ArgumentError('Controller "$controllerName" not found');
    }

    final animations = <Animation<double>>[];
    final segmentDuration = 1.0 / (count + (count - 1) * overlap);

    for (var i = 0; i < count; i++) {
      final start = i * segmentDuration * (1 - overlap);
      final end = start + segmentDuration;

      animations.add(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: curve),
        ),
      );
    }

    return animations;
  }

  /// Dispose all controllers
  @override
  void dispose() {
    for (final ticker in _tickers) {
      ticker.dispose();
    }
    for (final reactive in _reactiveAnimations.values) {
      reactive.dispose();
    }
    for (final curved in _curvedAnimations.values) {
      curved.dispose();
    }
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _tickers.clear();
    _controllers.clear();
    _reactiveAnimations.clear();
    _curvedAnimations.clear();
    super.dispose();
  }
}

/// Simplified mixin using TickerProviderStateMixin
mixin SimpleReactiveAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, StreamController<double>> _streamControllers = {};

  /// Create an animation controller with reactive stream
  (AnimationController, Stream<double>) createReactiveController({
    required String name,
    required Duration duration,
    Duration? reverseDuration,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
    );

    final streamController = StreamController<double>.broadcast();

    void listener() {
      if (!streamController.isClosed) {
        streamController.add(controller.value);
      }
    }

    controller.addListener(listener);

    _controllers[name] = controller;
    _streamControllers[name] = streamController;

    return (controller, streamController.stream);
  }

  /// Get controller by name
  AnimationController? controller(String name) => _controllers[name];

  /// Get stream by name
  Stream<double>? stream(String name) => _streamControllers[name]?.stream;

  @override
  void dispose() {
    for (final sc in _streamControllers.values) {
      sc.close();
    }
    for (final c in _controllers.values) {
      c.dispose();
    }
    _streamControllers.clear();
    _controllers.clear();
    super.dispose();
  }
}

/// Extension for chaining animation operations
extension AnimationControllerChain on AnimationController {
  /// Chain forward then reverse
  Future<void> forwardAndReverse({bool repeat = false}) async {
    do {
      await forward();
      await reverse();
    } while (repeat && !isDismissed);
  }

  /// Pulse animation (scale up and down)
  Future<void> pulse({int times = 1}) async {
    for (var i = 0; i < times; i++) {
      await forward();
      await reverse();
    }
  }

  /// Animate to value with spring effect
  TickerFuture animateToWithSpring(
    double target, {
    SpringConfig config = SpringConfig.smooth,
  }) {
    return animateTo(
      target,
      curve: Curves.elasticOut,
    );
  }
}

/// Animation sequence builder for complex animations
class AnimationSequenceBuilder {
  final TickerProvider vsync;
  final List<AnimationStep> _steps = [];
  Duration _totalDuration = Duration.zero;

  AnimationSequenceBuilder(this.vsync);

  /// Add a forward animation step
  AnimationSequenceBuilder forward({
    required Duration duration,
    Curve curve = Curves.linear,
  }) {
    _steps.add(AnimationStep(
      type: AnimationStepType.forward,
      duration: duration,
      curve: curve,
    ));
    _totalDuration += duration;
    return this;
  }

  /// Add a reverse animation step
  AnimationSequenceBuilder reverse({
    required Duration duration,
    Curve curve = Curves.linear,
  }) {
    _steps.add(AnimationStep(
      type: AnimationStepType.reverse,
      duration: duration,
      curve: curve,
    ));
    _totalDuration += duration;
    return this;
  }

  /// Add a delay step
  AnimationSequenceBuilder delay(Duration duration) {
    _steps.add(AnimationStep(
      type: AnimationStepType.delay,
      duration: duration,
      curve: Curves.linear,
    ));
    _totalDuration += duration;
    return this;
  }

  /// Build the animation sequence
  AnimationSequence build() {
    final controller = AnimationController(
      vsync: vsync,
      duration: _totalDuration,
    );

    return AnimationSequence._(
      controller: controller,
      steps: List.unmodifiable(_steps),
      totalDuration: _totalDuration,
    );
  }
}

class AnimationSequence {
  final AnimationController controller;
  final List<AnimationStep> steps;
  final Duration totalDuration;

  AnimationSequence._({
    required this.controller,
    required this.steps,
    required this.totalDuration,
  });

  /// Get animation for a specific step
  Animation<double> getStepAnimation(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= steps.length) {
      throw RangeError.index(stepIndex, steps);
    }

    var startTime = Duration.zero;
    for (var i = 0; i < stepIndex; i++) {
      startTime += steps[i].duration;
    }

    final step = steps[stepIndex];
    final endTime = startTime + step.duration;

    final begin = startTime.inMicroseconds / totalDuration.inMicroseconds;
    final end = endTime.inMicroseconds / totalDuration.inMicroseconds;

    return CurvedAnimation(
      parent: controller,
      curve: Interval(begin, end, curve: step.curve),
    );
  }

  /// Play the entire sequence
  TickerFuture play() => controller.forward(from: 0);

  /// Dispose resources
  void dispose() => controller.dispose();
}

/// Animation step type
enum AnimationStepType { forward, reverse, delay }

/// Represents a single step in an animation sequence
class AnimationStep {
  final AnimationStepType type;
  final Duration duration;
  final Curve curve;

  const AnimationStep({
    required this.type,
    required this.duration,
    required this.curve,
  });
}
