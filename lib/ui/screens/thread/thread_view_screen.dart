import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/thread/thread_bloc.dart';
import '../../../bloc/thread/thread_event.dart';
import '../../../bloc/thread/thread_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/thread_dto.dart';

class ThreadViewScreen extends StatefulWidget {
  final String threadId;

  const ThreadViewScreen({super.key, required this.threadId});

  @override
  State<ThreadViewScreen> createState() => _ThreadViewScreenState();
}

class _ThreadViewScreenState extends State<ThreadViewScreen> {
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ThreadBloc>().add(ThreadSelectActive(threadId: widget.threadId));
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThreadBloc, ThreadState>(
      builder: (context, state) {
        final thread = state.activeThread;
        if (thread == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Thread')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final replies = state.repliesFor(widget.threadId);

        return Scaffold(
          appBar: AppBar(
            title: Text('Thread (${thread.replyCount} replies)'),
            actions: [
              IconButton(
                icon: Icon(
                  thread.isFollowing ? Icons.notifications_active : Icons.notifications_none,
                  color: thread.isFollowing ? AppColors.primary : null,
                ),
                onPressed: () {
                  if (thread.isFollowing) {
                    context.read<ThreadBloc>().add(ThreadUnfollow(threadId: thread.id));
                  } else {
                    context.read<ThreadBloc>().add(ThreadFollow(threadId: thread.id));
                  }
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _onMenuAction(value, thread.id, thread.isResolved),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: thread.isResolved ? 'unresolve' : 'resolve',
                    child: Text(thread.isResolved ? 'Unresolve' : 'Mark as Resolved'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Thread info header
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.primary.withValues(alpha: 0.05),
                child: Row(
                  children: [
                    Icon(Icons.message, size: 16, color: AppColors.grey500),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Parent message: ${thread.parentMessageId}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                    ),
                    const Spacer(),
                    if (thread.isResolved)
                      Chip(
                        label: Text('Resolved', style: AppTypography.labelSmall.copyWith(color: Colors.green)),
                        backgroundColor: Colors.green.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ],
                ),
              ),

              // Replies list
              Expanded(
                child: replies.isEmpty
                    ? Center(
                        child: Text(
                          'No replies yet',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        itemCount: replies.length,
                        itemBuilder: (context, index) {
                          final reply = replies[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage:
                                            reply.avatar != null ? NetworkImage(reply.avatar!) : null,
                                        child: reply.avatar == null
                                            ? Text(
                                                (reply.displayName ?? reply.userId)
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(fontSize: 12),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        reply.displayName ?? reply.userId,
                                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _formatDate(reply.createdAt),
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(reply.content, style: AppTypography.bodyMedium),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Reply input
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.grey400.withValues(alpha: 0.3))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: const InputDecoration(
                          hintText: 'Reply...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColors.primary,
                      onPressed: _sendReply,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMenuAction(String action, String threadId, bool isResolved) {
    if (action == 'resolve') {
      context.read<ThreadBloc>().add(ThreadResolve(threadId: threadId));
    } else if (action == 'unresolve') {
      context.read<ThreadBloc>().add(ThreadUnresolve(threadId: threadId));
    }
  }

  void _sendReply() {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    context.read<ThreadBloc>().add(ThreadAddReply(
      threadId: widget.threadId,
      data: CreateThreadReplyDto(content: content),
    ));
    _replyController.clear();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}
