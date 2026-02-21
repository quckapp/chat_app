import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../bloc/thread/thread_bloc.dart';
import '../../../bloc/thread/thread_event.dart';
import '../../../bloc/thread/thread_state.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/thread/thread_reply_tile.dart';

class ThreadListScreen extends StatefulWidget {
  const ThreadListScreen({super.key});

  @override
  State<ThreadListScreen> createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen> {
  @override
  void initState() {
    super.initState();
    _loadThreads();
  }

  void _loadThreads() {
    final channelState = context.read<ChannelBloc>().state;
    final activeChannel = channelState.activeChannel;
    if (activeChannel != null) {
      context.read<ThreadBloc>().add(ThreadLoad(channelId: activeChannel.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads'),
      ),
      body: BlocConsumer<ThreadBloc, ThreadState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.threads.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.threads.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async => _loadThreads(),
            child: ListView.separated(
              itemCount: state.threads.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final thread = state.threads[index];
                return ThreadReplyTile(
                  thread: thread,
                  onTap: () {
                    context.read<ThreadBloc>().add(ThreadSelectActive(threadId: thread.id));
                    context.push('/thread/${thread.id}');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No threads yet', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Threads will appear here when you reply to messages',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
