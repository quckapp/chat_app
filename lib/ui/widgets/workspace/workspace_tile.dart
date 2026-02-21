import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/workspace.dart';

class WorkspaceTile extends StatelessWidget {
  final Workspace workspace;
  final bool isActive;
  final VoidCallback? onTap;

  const WorkspaceTile({
    super.key,
    required this.workspace,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.1),
        child: workspace.iconUrl != null
            ? ClipOval(
                child: Image.network(
                  workspace.iconUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildInitial(),
                ),
              )
            : _buildInitial(),
      ),
      title: Text(
        workspace.name,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '${workspace.memberCount} members \u00B7 ${workspace.channelCount} channels',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.grey500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (workspace.myRole != null)
            Chip(
              label: Text(
                workspace.myRole!,
                style: AppTypography.labelSmall,
              ),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
            ),
        ],
      ),
      selected: isActive,
      onTap: onTap,
    );
  }

  Widget _buildInitial() {
    return Text(
      workspace.name.isNotEmpty
          ? workspace.name.substring(0, 1).toUpperCase()
          : '?',
      style: TextStyle(
        color: isActive ? Colors.white : AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
