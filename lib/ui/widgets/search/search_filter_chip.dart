import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/search_result.dart';

class SearchFilterChipWidget extends StatelessWidget {
  final SearchResultType type;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const SearchFilterChipWidget({
    super.key,
    required this.type,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_typeIcon, size: 16, color: isSelected ? Colors.white : AppColors.grey500),
          const SizedBox(width: 4),
          Text(_typeLabel),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isSelected ? Colors.white : AppColors.grey500,
      ),
    );
  }

  String get _typeLabel {
    switch (type) {
      case SearchResultType.message:
        return 'Messages';
      case SearchResultType.user:
        return 'People';
      case SearchResultType.channel:
        return 'Channels';
      case SearchResultType.file:
        return 'Files';
    }
  }

  IconData get _typeIcon {
    switch (type) {
      case SearchResultType.message:
        return Icons.chat_bubble_outline;
      case SearchResultType.user:
        return Icons.person_outline;
      case SearchResultType.channel:
        return Icons.tag;
      case SearchResultType.file:
        return Icons.insert_drive_file_outlined;
    }
  }
}
