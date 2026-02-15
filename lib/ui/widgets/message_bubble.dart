import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/theme.dart';
import '../../models/message.dart';
import 'chat/image_message.dart';
import 'chat/audio_message.dart';
import 'chat/file_attachment.dart';
import 'chat/link_preview.dart';

/// An enhanced chat message bubble with swipe-to-reply
class ChatMessageBubble extends StatefulWidget {
  final Message message;
  final bool isSent;
  final bool showAvatar;
  final bool showTimestamp;
  final bool showReadReceipts;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final int recipientCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSwipeReply;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isSent,
    this.showAvatar = false,
    this.showTimestamp = true,
    this.showReadReceipts = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.recipientCount = 0,
    this.onTap,
    this.onLongPress,
    this.onSwipeReply,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  double _dragOffset = 0;
  bool _hasTriggeredReply = false;

  @override
  Widget build(BuildContext context) {
    if (widget.message.isDeleted) {
      return _buildDeletedMessage(context);
    }

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onHorizontalDragUpdate: (details) {
        if (widget.onSwipeReply != null) {
          setState(() {
            // Only allow swiping in one direction
            if (widget.isSent) {
              _dragOffset = (details.delta.dx).clamp(-80.0, 0.0);
            } else {
              _dragOffset = (details.delta.dx).clamp(0.0, 80.0);
            }
            _dragOffset = _dragOffset + details.delta.dx;
            _dragOffset = _dragOffset.clamp(-80.0, 80.0);
          });

          // Trigger haptic and callback when threshold is reached
          if (_dragOffset.abs() > 60 && !_hasTriggeredReply) {
            _hasTriggeredReply = true;
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (_hasTriggeredReply && widget.onSwipeReply != null) {
          widget.onSwipeReply!();
        }
        setState(() {
          _dragOffset = 0;
          _hasTriggeredReply = false;
        });
      },
      child: Stack(
        children: [
          // Reply indicator
          if (_dragOffset.abs() > 20)
            Positioned.fill(
              child: Align(
                alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widget.isSent ? 0 : 8,
                    right: widget.isSent ? 8 : 0,
                  ),
                  child: AnimatedOpacity(
                    opacity: (_dragOffset.abs() / 60).clamp(0.0, 1.0),
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.reply,
                        size: 20,
                        color: _hasTriggeredReply ? AppColors.primary : AppColors.grey600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Message bubble
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: _buildMessageContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: widget.isSent ? 48 : 8,
          right: widget.isSent ? 8 : 48,
        ),
        child: Column(
          crossAxisAlignment: widget.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Reply preview if message is a reply
            if (widget.message.replyTo != null) _buildReplyPreview(context),

            // Attachments (images, videos, audio, files)
            if (widget.message.attachments.isNotEmpty)
              _buildAttachments(context),

            // Main message bubble (text content)
            if (widget.message.content.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: widget.isSent ? AppColors.primary : Colors.white,
                  borderRadius: _getBorderRadius(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Link preview if message contains URL
                    if (LinkExtractor.containsUrl(widget.message.content))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: LinkPreview(
                          data: LinkPreviewData(
                            url: LinkExtractor.getFirstUrl(widget.message.content) ?? '',
                          ),
                          isSent: widget.isSent,
                          onTap: () {
                            // TODO: Open URL
                          },
                        ),
                      ),

                    // Message content with tappable links
                    if (LinkExtractor.containsUrl(widget.message.content))
                      TappableText(
                        text: widget.message.content,
                        style: TextStyle(
                          color: widget.isSent ? Colors.white : AppColors.grey900,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        linkStyle: TextStyle(
                          color: widget.isSent ? Colors.white : AppColors.primary,
                          fontSize: 15,
                          height: 1.4,
                          decoration: TextDecoration.underline,
                        ),
                        onLinkTap: (url) {
                          // TODO: Open URL
                        },
                      )
                    else
                      Text(
                        widget.message.content,
                        style: TextStyle(
                          color: widget.isSent ? Colors.white : AppColors.grey900,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),

                    // Bottom row: timestamp, edit indicator, read receipts
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.message.isEdited) ...[
                          Text(
                            'edited',
                            style: TextStyle(
                              color: widget.isSent
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : AppColors.grey500,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (widget.showTimestamp)
                          Text(
                            _formatTime(widget.message.createdAt),
                            style: TextStyle(
                              color: widget.isSent
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : AppColors.grey500,
                              fontSize: 11,
                            ),
                          ),
                        if (widget.isSent && widget.showReadReceipts) ...[
                          const SizedBox(width: 4),
                          _buildReadReceiptIcon(),
                        ],
                      ],
                    ),
                  ],
                ),
              )
            // If no text content but has attachments, show timestamp overlay on last attachment
            else if (widget.message.attachments.isNotEmpty)
              _buildAttachmentTimestamp(),

            // Reactions
            if (widget.message.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _buildReactions(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(BuildContext context) {
    final attachments = widget.message.attachments;

    // Separate attachments by type
    final images = attachments.where((a) => a.isImage).toList();
    final videos = attachments.where((a) => a.isVideo).toList();
    final audioFiles = attachments.where((a) => a.isAudio).toList();
    final documents = attachments.where((a) => a.isDocument).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images/Videos grid
        if (images.isNotEmpty || videos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: ImageMessage(
              images: [...images, ...videos],
              isSent: widget.isSent,
              onTap: (index) {
                // Open image viewer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewer(
                      images: images,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            ),
          ),

        // Audio files
        for (final audio in audioFiles)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: AudioMessage(
              audio: audio,
              isSent: widget.isSent,
            ),
          ),

        // Documents
        for (final doc in documents)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: FileAttachment(
              file: doc,
              isSent: widget.isSent,
              onTap: () {
                // TODO: Download/open file
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentTimestamp() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.message.isEdited) ...[
            Text(
              'edited',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 4),
          ],
          if (widget.showTimestamp)
            Text(
              _formatTime(widget.message.createdAt),
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 11,
              ),
            ),
          if (widget.isSent && widget.showReadReceipts) ...[
            const SizedBox(width: 4),
            _buildReadReceiptIcon(),
          ],
        ],
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    const double large = 18.0;
    const double small = 6.0;

    if (widget.isSent) {
      return BorderRadius.only(
        topLeft: const Radius.circular(large),
        topRight: Radius.circular(widget.isFirstInGroup ? large : small),
        bottomLeft: const Radius.circular(large),
        bottomRight: Radius.circular(widget.isLastInGroup ? large : small),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.isFirstInGroup ? large : small),
        topRight: const Radius.circular(large),
        bottomLeft: Radius.circular(widget.isLastInGroup ? large : small),
        bottomRight: const Radius.circular(large),
      );
    }
  }

  Widget _buildReplyPreview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isSent
            ? AppColors.primary.withValues(alpha: 0.7)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: widget.isSent ? Colors.white : AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Replied message', // TODO: Get actual reply content
              style: TextStyle(
                color: widget.isSent ? Colors.white.withValues(alpha: 0.8) : AppColors.grey600,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletedMessage(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: widget.isSent ? 48 : 8,
          right: widget.isSent ? 8 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, size: 16, color: AppColors.grey500),
            const SizedBox(width: 6),
            Text(
              'This message was deleted',
              style: TextStyle(
                color: AppColors.grey500,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadReceiptIcon() {
    if (widget.message.isPending) {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      );
    }
    if (widget.message.hasFailed) {
      return GestureDetector(
        onTap: () {
          // TODO: Retry sending
        },
        child: const Icon(Icons.error_outline, size: 16, color: Colors.red),
      );
    }

    final readCount = widget.message.readBy.length;
    if (readCount == 0) {
      // Sent but not delivered
      return Icon(Icons.check, size: 14, color: Colors.white.withValues(alpha: 0.7));
    } else if (widget.recipientCount > 0 && readCount >= widget.recipientCount) {
      // Read by all
      return const Icon(Icons.done_all, size: 14, color: Colors.lightBlueAccent);
    } else {
      // Delivered (at least one received)
      return Icon(Icons.done_all, size: 14, color: Colors.white.withValues(alpha: 0.7));
    }
  }

  Widget _buildReactions(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: widget.message.reactions.map((reaction) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reaction.emoji, style: const TextStyle(fontSize: 14)),
              if (reaction.count > 1) ...[
                const SizedBox(width: 4),
                Text(
                  '${reaction.count}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

/// A system message (e.g., "User joined the chat")
class SystemMessageBubble extends StatelessWidget {
  final Message message;

  const SystemMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: AppColors.grey600,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Legacy MessageBubble for backwards compatibility
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isSent;
  final bool showAvatar;
  final bool showTimestamp;
  final bool showReadReceipts;
  final int recipientCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSent,
    this.showAvatar = false,
    this.showTimestamp = true,
    this.showReadReceipts = false,
    this.recipientCount = 0,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ChatMessageBubble(
      message: message,
      isSent: isSent,
      showAvatar: showAvatar,
      showTimestamp: showTimestamp,
      showReadReceipts: showReadReceipts,
      recipientCount: recipientCount,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
