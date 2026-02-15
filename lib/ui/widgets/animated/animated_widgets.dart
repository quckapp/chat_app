/// Animated widgets barrel file
library animated_widgets;
///
/// Reactive programming animation widgets for chat features:
/// - AnimationController management
/// - AnimatedBuilder patterns
/// - CurvedAnimation support
/// - Hero transitions
/// - Opacity animations
///
/// Usage example:
/// ```dart
/// // Message bubble with send animation
/// AnimatedMessageBubble(
///   child: MessageBubble(...),
///   isSent: true,
/// )
///
/// // Avatar with Hero transition
/// AnimatedAvatar(
///   heroTag: 'user_${user.id}',
///   imageUrl: user.avatarUrl,
///   size: 48,
/// )
///
/// // Staggered list animation
/// StaggeredListAnimation(
///   itemCount: messages.length,
///   itemBuilder: (context, index) => MessageItem(messages[index]),
/// )
///
/// // Reactive pulse on new message
/// ReactivePulse(
///   triggerStream: newMessageStream,
///   child: NotificationIcon(),
/// )
/// ```

export 'animated_message_bubble.dart';
export 'animated_avatar.dart';
export 'fade_slide_transition.dart';
export 'staggered_list.dart';
export 'pulse_animation.dart';
export 'reaction_animation.dart';
export 'rx_animated_widgets.dart';
