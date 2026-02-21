import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/poll.dart';

class PollCard extends StatelessWidget {
  final Poll poll;
  final void Function(String optionId)? onVote;
  final VoidCallback? onClose;

  const PollCard({
    super.key,
    required this.poll,
    this.onVote,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    poll.question,
                    style: AppTypography.headlineSmall,
                  ),
                ),
                if (poll.isClosed)
                  Chip(
                    label: const Text('Closed'),
                    backgroundColor: AppColors.grey400.withValues(alpha: 0.2),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...poll.options.map((option) => _buildOptionRow(option)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${poll.totalVotes} vote${poll.totalVotes == 1 ? '' : 's'}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                ),
                if (poll.isAnonymous)
                  Text(
                    'Anonymous',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                  ),
              ],
            ),
            if (!poll.isClosed && onClose != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClose,
                  child: const Text('Close Poll'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(PollOption option) {
    final percentage =
        poll.totalVotes > 0 ? option.voteCount / poll.totalVotes : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: !poll.isClosed && onVote != null ? () => onVote!(option.id) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey400.withValues(alpha: 0.3)),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        option.text,
                        style: AppTypography.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${option.voteCount} (${(percentage * 100).toStringAsFixed(0)}%)',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
