import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/huddle/huddle_bloc.dart';
import '../../../bloc/huddle/huddle_event.dart';
import '../../../bloc/huddle/huddle_state.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/huddle/huddle_tile.dart';

class HuddleScreen extends StatefulWidget {
  final String channelId;

  const HuddleScreen({super.key, required this.channelId});

  @override
  State<HuddleScreen> createState() => _HuddleScreenState();
}

class _HuddleScreenState extends State<HuddleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HuddleBloc>().add(HuddleLoad(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Huddles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<HuddleBloc>().add(HuddleCreate(channelId: widget.channelId));
            },
          ),
        ],
      ),
      body: BlocConsumer<HuddleBloc, HuddleState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.huddles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Active huddle view
          if (state.hasActiveHuddle) {
            return _buildActiveHuddleView(state);
          }

          if (state.huddles.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HuddleBloc>().add(HuddleLoad(channelId: widget.channelId));
            },
            child: ListView.separated(
              itemCount: state.huddles.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final huddle = state.huddles[index];
                return HuddleTile(
                  huddle: huddle,
                  onJoin: () {
                    context.read<HuddleBloc>().add(HuddleJoin(huddleId: huddle.id));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveHuddleView(HuddleState state) {
    final huddle = state.activeHuddle!;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.headphones, size: 48, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Huddle Active', style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${huddle.participantCount} participant${huddle.participantCount != 1 ? 's' : ''}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Participant avatars
                Wrap(
                  spacing: AppSpacing.sm,
                  children: huddle.participantIds.take(8).map((id) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Text(
                        id.substring(0, 1).toUpperCase(),
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
                if (huddle.participantCount > 8)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      '+${huddle.participantCount - 8} more',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Leave button
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                context.read<HuddleBloc>().add(HuddleLeave(huddleId: huddle.id));
              },
              icon: const Icon(Icons.call_end),
              label: const Text('Leave Huddle'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.headphones, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No active huddles', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Start a huddle to chat with your team',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              context.read<HuddleBloc>().add(HuddleCreate(channelId: widget.channelId));
            },
            icon: const Icon(Icons.add),
            label: const Text('Start Huddle'),
          ),
        ],
      ),
    );
  }
}
