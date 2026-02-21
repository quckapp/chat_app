import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_event.dart';
import '../../../bloc/channel_extras/channel_extras_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/poll_dto.dart';
import '../../widgets/channel/poll_card.dart';

class PollScreen extends StatefulWidget {
  final String channelId;

  const PollScreen({super.key, required this.channelId});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChannelExtrasBloc>().add(LoadPolls(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePollDialog(),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<ChannelExtrasBloc, ChannelExtrasState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.polls.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.polls.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChannelExtrasBloc>()
                  .add(LoadPolls(channelId: widget.channelId));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.polls.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final poll = state.polls[index];
                return PollCard(
                  poll: poll,
                  onVote: (optionId) {
                    context.read<ChannelExtrasBloc>().add(VotePoll(
                          channelId: widget.channelId,
                          pollId: poll.id,
                          data: VotePollDto(optionId: optionId),
                        ));
                  },
                  onClose: () {
                    context.read<ChannelExtrasBloc>().add(ClosePoll(
                          channelId: widget.channelId,
                          pollId: poll.id,
                        ));
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
          Icon(Icons.poll_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No polls yet', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create a poll to gather opinions',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _showCreatePollDialog() {
    final questionController = TextEditingController();
    final optionControllers = <TextEditingController>[
      TextEditingController(),
      TextEditingController(),
    ];
    bool isAnonymous = false;
    bool allowMultiple = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Poll'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Question'),
                  autofocus: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...optionControllers.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: 'Option ${entry.key + 1}',
                          suffixIcon: optionControllers.length > 2
                              ? IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setDialogState(() {
                                      optionControllers.removeAt(entry.key);
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    )),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Option'),
                  onPressed: () {
                    setDialogState(() {
                      optionControllers.add(TextEditingController());
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Anonymous voting'),
                  value: isAnonymous,
                  onChanged: (v) => setDialogState(() => isAnonymous = v ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('Allow multiple votes'),
                  value: allowMultiple,
                  onChanged: (v) => setDialogState(() => allowMultiple = v ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final question = questionController.text.trim();
                final options = optionControllers
                    .map((c) => c.text.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();
                if (question.isNotEmpty && options.length >= 2) {
                  Navigator.pop(ctx);
                  context.read<ChannelExtrasBloc>().add(CreatePoll(
                        channelId: widget.channelId,
                        data: CreatePollDto(
                          question: question,
                          options: options,
                          isAnonymous: isAnonymous,
                          allowMultiple: allowMultiple,
                        ),
                      ));
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
