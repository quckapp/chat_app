import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/huddle.dart';

class HuddleTile extends StatelessWidget {
  final Huddle huddle;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const HuddleTile({
    super.key,
    required this.huddle,
    this.onJoin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: huddle.isActive
            ? Colors.green.withValues(alpha: 0.1)
            : AppColors.grey400.withValues(alpha: 0.1),
        child: Icon(
          Icons.headphones,
          color: huddle.isActive ? Colors.green : AppColors.grey400,
          size: 20,
        ),
      ),
      title: Text(
        'Huddle',
        style: AppTypography.bodyLarge,
      ),
      subtitle: Row(
        children: [
          if (huddle.isActive) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            huddle.isActive
                ? '${huddle.participantCount} participant${huddle.participantCount != 1 ? 's' : ''}'
                : 'Ended',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
      trailing: huddle.isActive && !huddle.isFull
          ? FilledButton.tonal(
              onPressed: onJoin,
              child: const Text('Join'),
            )
          : huddle.isFull
              ? Text(
                  'Full',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
                )
              : null,
      onTap: onTap,
    );
  }
}
