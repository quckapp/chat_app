import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rxdart/rxdart.dart';

/// RxDart-based reactive animation controller
/// Provides stream-based animation values with powerful operators
class RxAnimationController {
  final TickerProvider vsync;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;
  final double lowerBound;
  final double upperBound;

  late final AnimationController _controller;
  late final BehaviorSubject<double> _valueSubject;
  late final BehaviorSubject<AnimationStatus> _statusSubject;

  RxAnimationController({
    required this.vsync,
    required this.duration,
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    double? initialValue,
  }) {
    _controller = AnimationController(
      vsync: vsync,
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
      value: initialValue,
    );

    _valueSubject = BehaviorSubject<double>.seeded(_controller.value);
    _statusSubject = BehaviorSubject<AnimationStatus>.seeded(_controller.status);

    _controller.addListener(_onValueChanged);
    _controller.addStatusListener(_onStatusChanged);
  }

  void _onValueChanged() {
    final curvedValue = curve.transform(_controller.value);
    _valueSubject.add(curvedValue);
  }

  void _onStatusChanged(AnimationStatus status) {
    _statusSubject.add(status);
  }

  /// Stream of animation values (0.0 to 1.0, curved)
  ValueStream<double> get valueStream => _valueSubject.stream;

  /// Stream of animation status changes
  ValueStream<AnimationStatus> get statusStream => _statusSubject.stream;

  /// Current animation value
  double get value => _valueSubject.value;

  /// Current animation status
  AnimationStatus get status => _statusSubject.value;

  /// Whether animation is currently running
  bool get isAnimating => _controller.isAnimating;

  /// Raw controller for direct access
  AnimationController get controller => _controller;

  /// Forward animation
  TickerFuture forward({double? from}) => _controller.forward(from: from);

  /// Reverse animation
  TickerFuture reverse({double? from}) => _controller.reverse(from: from);

  /// Animate to specific value
  TickerFuture animateTo(double target, {Duration? duration, Curve curve = Curves.linear}) {
    return _controller.animateTo(target, duration: duration, curve: curve);
  }

  /// Repeat animation
  TickerFuture repeat({double? min, double? max, bool reverse = false, Duration? period}) {
    return _controller.repeat(min: min, max: max, reverse: reverse, period: period);
  }

  /// Stop animation
  void stop({bool canceled = true}) => _controller.stop(canceled: canceled);

  /// Reset to initial value
  void reset() => _controller.reset();

  /// Dispose resources
  void dispose() {
    _controller.removeListener(_onValueChanged);
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    _valueSubject.close();
    _statusSubject.close();
  }

  /// Create a derived stream with a tween
  Stream<T> tween<T>(Tween<T> tween) {
    return valueStream.map((value) => tween.transform(value));
  }

  /// Create a color tween stream
  Stream<Color?> colorTween(Color begin, Color end) {
    return tween(ColorTween(begin: begin, end: end));
  }

  /// Create an offset tween stream
  Stream<Offset> offsetTween(Offset begin, Offset end) {
    return tween(Tween<Offset>(begin: begin, end: end));
  }

  /// Create a size tween stream
  Stream<Size> sizeTween(Size begin, Size end) {
    return tween(Tween<Size>(begin: begin, end: end));
  }

  /// Create a double tween stream
  Stream<double> doubleTween(double begin, double end) {
    return tween(Tween<double>(begin: begin, end: end));
  }
}

/// RxDart animation sequence for complex multi-step animations
class RxAnimationSequence {
  final TickerProvider vsync;
  final List<RxAnimationStep> steps;
  final bool autoDispose;

  late final BehaviorSubject<int> _currentStepSubject;
  late final BehaviorSubject<double> _progressSubject;
  late final PublishSubject<RxAnimationEvent> _eventSubject;

  final List<RxAnimationController> _controllers = [];

  RxAnimationSequence({
    required this.vsync,
    required this.steps,
    this.autoDispose = true,
  }) {
    _currentStepSubject = BehaviorSubject<int>.seeded(0);
    _progressSubject = BehaviorSubject<double>.seeded(0.0);
    _eventSubject = PublishSubject<RxAnimationEvent>();

    _initializeControllers();
  }

  void _initializeControllers() {
    for (final step in steps) {
      final controller = RxAnimationController(
        vsync: vsync,
        duration: step.duration,
        curve: step.curve,
      );
      _controllers.add(controller);
    }
  }

  /// Stream of current step index
  ValueStream<int> get currentStepStream => _currentStepSubject.stream;

  /// Stream of overall progress (0.0 to 1.0)
  ValueStream<double> get progressStream => _progressSubject.stream;

  /// Stream of animation events
  Stream<RxAnimationEvent> get eventStream => _eventSubject.stream;

  /// Get controller for specific step
  RxAnimationController? getStepController(int index) {
    if (index >= 0 && index < _controllers.length) {
      return _controllers[index];
    }
    return null;
  }

  /// Play entire sequence
  Future<void> play() async {
    _eventSubject.add(RxAnimationEvent.started);

    for (var i = 0; i < steps.length; i++) {
      _currentStepSubject.add(i);
      _eventSubject.add(RxAnimationEvent.stepStarted);

      final controller = _controllers[i];
      final step = steps[i];

      // Add progress listener
      controller.valueStream.listen((value) {
        final stepProgress = value;
        final overallProgress = (i + stepProgress) / steps.length;
        _progressSubject.add(overallProgress);
      });

      // Execute step
      if (step.reverse) {
        await controller.forward().orCancel;
        await controller.reverse().orCancel;
      } else {
        await controller.forward().orCancel;
      }

      _eventSubject.add(RxAnimationEvent.stepCompleted);

      // Delay between steps
      if (step.delay != Duration.zero && i < steps.length - 1) {
        await Future.delayed(step.delay);
      }
    }

    _progressSubject.add(1.0);
    _eventSubject.add(RxAnimationEvent.completed);
  }

  /// Stop sequence
  void stop() {
    for (final controller in _controllers) {
      controller.stop();
    }
    _eventSubject.add(RxAnimationEvent.stopped);
  }

  /// Reset sequence
  void reset() {
    _currentStepSubject.add(0);
    _progressSubject.add(0.0);
    for (final controller in _controllers) {
      controller.reset();
    }
    _eventSubject.add(RxAnimationEvent.reset);
  }

  /// Dispose resources
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _currentStepSubject.close();
    _progressSubject.close();
    _eventSubject.close();
  }
}

/// Single step in an animation sequence
class RxAnimationStep {
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final bool reverse;

  const RxAnimationStep({
    required this.duration,
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.reverse = false,
  });
}

/// Animation sequence events
enum RxAnimationEvent {
  started,
  stepStarted,
  stepCompleted,
  completed,
  stopped,
  reset,
}

/// Reactive spring animation using RxDart
class RxSpringAnimation {
  final TickerProvider vsync;
  final SpringDescription spring;

  late final AnimationController _controller;
  late final BehaviorSubject<double> _valueSubject;

  RxSpringAnimation({
    required this.vsync,
    SpringDescription? spring,
  }) : spring = spring ?? const SpringDescription(mass: 1.0, stiffness: 100.0, damping: 10.0) {
    _controller = AnimationController(vsync: vsync);
    _valueSubject = BehaviorSubject<double>.seeded(0.0);

    _controller.addListener(() {
      _valueSubject.add(_controller.value);
    });
  }

  /// Stream of spring animation values
  ValueStream<double> get valueStream => _valueSubject.stream;

  /// Animate to target with spring physics
  TickerFuture animateTo(double target, {double? from}) {
    if (from != null) {
      _controller.value = from;
    }

    final simulation = SpringSimulation(spring, _controller.value, target, 0.0);
    return _controller.animateWith(simulation);
  }

  /// Fling with velocity
  TickerFuture fling({double velocity = 1.0}) {
    final simulation = SpringSimulation(spring, _controller.value, 1.0, velocity);
    return _controller.animateWith(simulation);
  }

  void dispose() {
    _controller.dispose();
    _valueSubject.close();
  }
}

/// Staggered animation group using RxDart
class RxStaggeredAnimation {
  final TickerProvider vsync;
  final int itemCount;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Curve curve;

  late final List<RxAnimationController> _controllers;
  late final BehaviorSubject<List<double>> _valuesSubject;
  late final PublishSubject<int> _itemCompletedSubject;

  RxStaggeredAnimation({
    required this.vsync,
    required this.itemCount,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOut,
  }) {
    _controllers = List.generate(itemCount, (_) {
      return RxAnimationController(
        vsync: vsync,
        duration: itemDuration,
        curve: curve,
      );
    });

    _valuesSubject = BehaviorSubject<List<double>>.seeded(
      List.filled(itemCount, 0.0),
    );

    _itemCompletedSubject = PublishSubject<int>();

    // Combine all controller streams
    Rx.combineLatestList(
      _controllers.map((c) => c.valueStream).toList(),
    ).listen((values) {
      _valuesSubject.add(values);
    });
  }

  /// Stream of all animation values
  ValueStream<List<double>> get valuesStream => _valuesSubject.stream;

  /// Stream of item completion indices
  Stream<int> get itemCompletedStream => _itemCompletedSubject.stream;

  /// Get value stream for specific item
  ValueStream<double> itemValueStream(int index) {
    return _controllers[index].valueStream;
  }

  /// Start staggered animation
  Future<void> forward() async {
    for (var i = 0; i < _controllers.length; i++) {
      // Don't await - start immediately with stagger
      Future.delayed(staggerDelay * i, () {
        _controllers[i].forward().whenComplete(() {
          _itemCompletedSubject.add(i);
        });
      });
    }
  }

  /// Reverse staggered animation
  Future<void> reverse() async {
    for (var i = _controllers.length - 1; i >= 0; i--) {
      final reverseIndex = _controllers.length - 1 - i;
      Future.delayed(staggerDelay * reverseIndex, () {
        _controllers[i].reverse();
      });
    }
  }

  /// Reset all animations
  void reset() {
    for (final controller in _controllers) {
      controller.reset();
    }
    _valuesSubject.add(List.filled(itemCount, 0.0));
  }

  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _valuesSubject.close();
    _itemCompletedSubject.close();
  }
}

/// Extension methods for RxDart animation streams
extension RxAnimationStreamExtensions on Stream<double> {
  /// Apply curve transformation
  Stream<double> curved(Curve curve) {
    return map((value) => curve.transform(value.clamp(0.0, 1.0)));
  }

  /// Apply tween transformation
  Stream<T> tweenTo<T>(Tween<T> tween) {
    return map((value) => tween.transform(value));
  }

  /// Clamp values
  Stream<double> clamped({double min = 0.0, double max = 1.0}) {
    return map((value) => value.clamp(min, max));
  }

  /// Reverse values (1.0 becomes 0.0)
  Stream<double> reversed() {
    return map((value) => 1.0 - value);
  }

  /// Scale values by factor
  Stream<double> scaled(double factor) {
    return map((value) => value * factor);
  }

  /// Create interval subset
  Stream<double> interval(double begin, double end) {
    return map((value) {
      if (value < begin) return 0.0;
      if (value > end) return 1.0;
      return (value - begin) / (end - begin);
    });
  }

  /// Convert to color stream
  Stream<Color?> toColor(Color begin, Color end) {
    return tweenTo(ColorTween(begin: begin, end: end));
  }

  /// Convert to offset stream
  Stream<Offset> toOffset(Offset begin, Offset end) {
    return tweenTo(Tween<Offset>(begin: begin, end: end));
  }

  /// Throttle animation updates
  Stream<double> throttleAnimation(Duration duration) {
    return throttleTime(duration);
  }

  /// Sample animation at intervals
  Stream<double> sampleAnimation(Duration interval) {
    return sampleTime(interval);
  }
}

/// Combine multiple animation streams
class RxAnimationCombiner {
  RxAnimationCombiner._();

  /// Combine latest values from multiple animations
  static Stream<List<double>> combineLatest(List<Stream<double>> streams) {
    return Rx.combineLatestList(streams);
  }

  /// Merge multiple animation streams
  static Stream<double> merge(List<Stream<double>> streams) {
    return Rx.merge(streams);
  }

  /// Zip animation streams (emit when all have value)
  static Stream<List<double>> zip(List<Stream<double>> streams) {
    return Rx.zipList(streams);
  }

  /// Concat animation streams (play sequentially)
  static Stream<double> concat(List<Stream<double>> streams) {
    return Rx.concatEager(streams);
  }

  /// Race animations (first to emit wins)
  static Stream<double> race(List<Stream<double>> streams) {
    return Rx.race(streams);
  }
}
