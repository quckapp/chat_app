/// Core animation utilities with reactive programming support
library animation;
///
/// This module provides reactive animation streams that bridge Flutter's
/// imperative animation system with reactive/declarative programming patterns.
///
/// Key concepts:
/// - ReactiveAnimation: Converts AnimationController to Stream<double>
/// - ReactiveCurvedAnimation: Curved animations as streams
/// - AnimationTransformer: Stream transformers for animation values
/// - ReactiveAnimationMixin: Mixin for managing multiple controllers
///
/// Example usage:
/// ```dart
/// // Create reactive animation
/// final controller = AnimationController(vsync: this, duration: duration);
/// final reactive = ReactiveAnimation.fromController(controller);
///
/// // Listen to animation values reactively
/// reactive.stream.listen((value) {
///   // React to animation value changes
/// });
///
/// // Transform animation stream
/// reactive.stream
///   .curved(Curves.easeOut)
///   .tween(ColorTween(begin: Colors.red, end: Colors.blue))
///   .listen((color) {
///     // Use interpolated color
///   });
///
/// // Using the mixin
/// class MyWidget extends StatefulWidget { ... }
///
/// class _MyWidgetState extends State<MyWidget>
///     with TickerProviderStateMixin, SimpleReactiveAnimationMixin {
///
///   @override
///   void initState() {
///     super.initState();
///
///     final (fadeController, fadeStream) = createReactiveController(
///       name: 'fade',
///       duration: Duration(milliseconds: 300),
///     );
///
///     fadeStream.listen((value) {
///       // React to fade animation
///     });
///
///     fadeController.forward();
///   }
/// }
/// ```

export 'reactive_animation.dart';
export 'animation_controller_mixin.dart';
export 'rx_animation.dart';
