import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

/// Reactive animation stream that emits animation values
/// Bridges Flutter's imperative animations with reactive streams
class ReactiveAnimation {
  final AnimationController _controller;
  final StreamController<double> _streamController;
  late final Stream<double> stream;

  ReactiveAnimation._({
    required AnimationController controller,
    required StreamController<double> streamController,
  })  : _controller = controller,
        _streamController = streamController {
    stream = _streamController.stream.asBroadcastStream();
  }

  /// Create a reactive animation from a controller
  factory ReactiveAnimation.fromController(AnimationController controller) {
    final streamController = StreamController<double>.broadcast();

    void listener() {
      streamController.add(controller.value);
    }

    controller.addListener(listener);

    streamController.onCancel = () {
      controller.removeListener(listener);
    };

    return ReactiveAnimation._(
      controller: controller,
      streamController: streamController,
    );
  }

  double get value => _controller.value;
  AnimationStatus get status => _controller.status;
  bool get isAnimating => _controller.isAnimating;

  void dispose() {
    _streamController.close();
  }
}

/// Reactive curved animation
class ReactiveCurvedAnimation {
  final Animation<double> _animation;
  final StreamController<double> _streamController;
  late final Stream<double> stream;

  ReactiveCurvedAnimation._({
    required Animation<double> animation,
    required StreamController<double> streamController,
  })  : _animation = animation,
        _streamController = streamController {
    stream = _streamController.stream.asBroadcastStream();
  }

  factory ReactiveCurvedAnimation.create({
    required AnimationController parent,
    required Curve curve,
    Curve? reverseCurve,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: parent,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    final streamController = StreamController<double>.broadcast();

    void listener() {
      streamController.add(curvedAnimation.value);
    }

    curvedAnimation.addListener(listener);

    streamController.onCancel = () {
      curvedAnimation.removeListener(listener);
    };

    return ReactiveCurvedAnimation._(
      animation: curvedAnimation,
      streamController: streamController,
    );
  }

  double get value => _animation.value;

  void dispose() {
    _streamController.close();
  }
}

/// Animation value transformer for reactive streams
class AnimationTransformer {
  AnimationTransformer._();

  /// Transform stream values through a Tween
  static Stream<T> tween<T>(
    Stream<double> animation,
    Tween<T> tween,
  ) {
    return animation.map((value) => tween.transform(value));
  }

  /// Apply curve to animation stream
  static Stream<double> curved(
    Stream<double> animation,
    Curve curve,
  ) {
    return animation.map((value) => curve.transform(value));
  }

  /// Combine multiple animation streams
  static Stream<List<double>> combine(List<Stream<double>> animations) {
    return _combineLatest(animations);
  }

  /// Sequence animations
  static Stream<double> sequence(
    List<Stream<double>> animations, {
    required List<double> weights,
  }) async* {
    assert(animations.length == weights.length);
    final totalWeight = weights.reduce((a, b) => a + b);

    for (var i = 0; i < animations.length; i++) {
      final weightBefore = weights.take(i).fold(0.0, (a, b) => a + b);
      final currentWeight = weights[i];

      await for (final value in animations[i]) {
        final normalizedValue =
            (weightBefore + value * currentWeight) / totalWeight;
        yield normalizedValue;
      }
    }
  }

  static Stream<List<T>> _combineLatest<T>(List<Stream<T>> streams) {
    final controller = StreamController<List<T>>.broadcast();
    final values = List<T?>.filled(streams.length, null);
    final hasValue = List<bool>.filled(streams.length, false);
    final subscriptions = <StreamSubscription<T>>[];
    var activeStreams = streams.length;

    void emitIfReady() {
      if (hasValue.every((v) => v)) {
        controller.add(List<T>.from(values.cast<T>()));
      }
    }

    for (var i = 0; i < streams.length; i++) {
      final index = i;
      subscriptions.add(
        streams[i].listen(
          (value) {
            values[index] = value;
            hasValue[index] = true;
            emitIfReady();
          },
          onError: controller.addError,
          onDone: () {
            activeStreams--;
            if (activeStreams == 0) {
              controller.close();
            }
          },
        ),
      );
    }

    controller.onCancel = () {
      for (final sub in subscriptions) {
        sub.cancel();
      }
    };

    return controller.stream;
  }
}

/// Ticker-based animation stream for custom frame updates
class TickerStream {
  final Ticker _ticker;
  final StreamController<Duration> _controller;
  Duration _elapsed = Duration.zero;

  TickerStream._(this._ticker, this._controller);

  /// Create a ticker stream from a TickerProvider
  factory TickerStream.create(TickerProvider vsync) {
    final controller = StreamController<Duration>.broadcast();
    late Ticker ticker;

    ticker = vsync.createTicker((elapsed) {
      controller.add(elapsed);
    });

    return TickerStream._(ticker, controller);
  }

  Stream<Duration> get stream => _controller.stream;
  Duration get elapsed => _elapsed;

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
  }

  void dispose() {
    _ticker.dispose();
    _controller.close();
  }
}

/// Spring animation configuration
class SpringConfig {
  final double mass;
  final double stiffness;
  final double damping;

  const SpringConfig({
    this.mass = 1.0,
    this.stiffness = 100.0,
    this.damping = 10.0,
  });

  static const SpringConfig bouncy = SpringConfig(
    mass: 1.0,
    stiffness: 150.0,
    damping: 10.0,
  );

  static const SpringConfig smooth = SpringConfig(
    mass: 1.0,
    stiffness: 100.0,
    damping: 20.0,
  );

  static const SpringConfig snappy = SpringConfig(
    mass: 1.0,
    stiffness: 300.0,
    damping: 15.0,
  );
}

/// Extension methods for animation streams
extension AnimationStreamExtensions on Stream<double> {
  /// Apply a tween to the animation stream
  Stream<T> tween<T>(Tween<T> t) {
    return map((value) => t.transform(value));
  }

  /// Apply a curve to the animation stream
  Stream<double> curved(Curve curve) {
    return map((value) => curve.transform(value));
  }

  /// Clamp values between 0 and 1
  Stream<double> clamped() {
    return map((value) => value.clamp(0.0, 1.0));
  }

  /// Reverse the animation values
  Stream<double> reversed() {
    return map((value) => 1.0 - value);
  }

  /// Scale animation values
  Stream<double> scaled(double factor) {
    return map((value) => value * factor);
  }

  /// Offset animation values
  Stream<double> offset(double amount) {
    return map((value) => value + amount);
  }

  /// Create interval within the animation
  Stream<double> interval(double begin, double end) {
    return map((value) {
      if (value < begin) return 0.0;
      if (value > end) return 1.0;
      return (value - begin) / (end - begin);
    });
  }
}
