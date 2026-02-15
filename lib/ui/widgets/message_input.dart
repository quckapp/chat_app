import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../models/message.dart';

/// Enhanced text input field for composing messages
class ChatMessageInput extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingStop;
  final String? hintText;
  final bool enabled;
  final bool autofocus;
  final Message? replyTo;
  final VoidCallback? onCancelReply;

  const ChatMessageInput({
    super.key,
    required this.onSend,
    this.onTypingStart,
    this.onTypingStop,
    this.hintText,
    this.enabled = true,
    this.autofocus = false,
    this.replyTo,
    this.onCancelReply,
  });

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      widget.onTypingStart?.call();
    }

    // Reset typing timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _isTyping = false;
        widget.onTypingStop?.call();
      }
    });

    setState(() {});
  }

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();

    // Stop typing indicator
    _typingTimer?.cancel();
    if (_isTyping) {
      _isTyping = false;
      widget.onTypingStop?.call();
    }

    setState(() {});
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + emoji.length,
      ),
    );
    _onTextChanged(newText);
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji picker
        if (_showEmojiPicker) _buildEmojiPicker(),

        // Input row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.grey200),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Emoji button
              IconButton(
                icon: Icon(
                  _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                  color: AppColors.grey600,
                ),
                onPressed: widget.enabled
                    ? () {
                        setState(() => _showEmojiPicker = !_showEmojiPicker);
                        if (!_showEmojiPicker) {
                          _focusNode.requestFocus();
                        } else {
                          _focusNode.unfocus();
                        }
                      }
                    : null,
              ),

              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: widget.autofocus,
                          enabled: widget.enabled,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: _onTextChanged,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? 'Message',
                            hintStyle: TextStyle(color: AppColors.grey500),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _onSend(),
                        ),
                      ),

                      // Attachment button inside the text field
                      IconButton(
                        icon: Icon(Icons.attach_file, color: AppColors.grey500, size: 22),
                        onPressed: widget.enabled ? _onAttachment : null,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                child: Material(
                  color: hasText && widget.enabled ? AppColors.primary : AppColors.grey200,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: hasText && widget.enabled ? _onSend : null,
                    borderRadius: BorderRadius.circular(24),
                    child: Center(
                      child: Icon(
                        Icons.send_rounded,
                        color: hasText && widget.enabled ? Colors.white : AppColors.grey500,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = [
      '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊',
      '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘',
      '😗', '😙', '😚', '😋', '😛', '😜', '🤪', '😝',
      '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨', '😐',
      '😑', '😶', '😏', '😒', '🙄', '😬', '🤥', '😌',
      '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢',
      '👍', '👎', '👊', '✊', '🤛', '🤜', '🤞', '✌️',
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍',
    ];

    return Container(
      height: 200,
      color: AppColors.grey50,
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _insertEmoji(emojis[index]),
            child: Center(
              child: Text(
                emojis[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onAttachment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AttachmentOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gallery coming soon')),
                        );
                      },
                    ),
                    _AttachmentOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      color: AppColors.secondary,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera coming soon')),
                        );
                      },
                    ),
                    _AttachmentOption(
                      icon: Icons.insert_drive_file_outlined,
                      label: 'Document',
                      color: AppColors.warning,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Documents coming soon')),
                        );
                      },
                    ),
                    _AttachmentOption(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      color: AppColors.success,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Location coming soon')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Legacy MessageInput for backwards compatibility
class MessageInput extends StatelessWidget {
  final ValueChanged<String> onSend;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingStop;
  final String? hintText;
  final bool enabled;
  final bool autofocus;

  const MessageInput({
    super.key,
    required this.onSend,
    this.onTypingStart,
    this.onTypingStop,
    this.hintText,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChatMessageInput(
      onSend: onSend,
      onTypingStart: onTypingStart,
      onTypingStop: onTypingStop,
      hintText: hintText,
      enabled: enabled,
      autofocus: autofocus,
    );
  }
}
