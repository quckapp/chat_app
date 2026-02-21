import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../bloc/channel/channel_event.dart';
import '../../../bloc/channel/channel_state.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/channel_dto.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({super.key});

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _topicController = TextEditingController();
  String _channelType = 'public';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
      ),
      body: BlocListener<ChannelBloc, ChannelState>(
        listener: (context, state) {
          if (state.status == ChannelStatus.loaded && state.channels.isNotEmpty) {
            context.pop();
          }
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Channel name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Channel Name',
                    hintText: 'e.g. general, random, project-alpha',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Channel name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),

                // Channel type
                Text('Channel Type', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                _buildTypeSelector(),
                const SizedBox(height: AppSpacing.md),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'What is this channel about?',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),

                // Topic
                TextFormField(
                  controller: _topicController,
                  decoration: const InputDecoration(
                    labelText: 'Topic (optional)',
                    hintText: 'Set a topic for this channel',
                    prefixIcon: Icon(Icons.topic_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Create button
                BlocBuilder<ChannelBloc, ChannelState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state.isLoading ? null : _onSubmit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Create Channel'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeOption(
            'public',
            'Public',
            Icons.public,
            'Anyone in the workspace can join',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildTypeOption(
            'private',
            'Private',
            Icons.lock,
            'Only invited members can join',
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon, String description) {
    final isSelected = _channelType == value;
    return GestureDetector(
      onTap: () => setState(() => _channelType = value),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey400,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.grey500),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? AppColors.primary : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final workspaceState = context.read<WorkspaceBloc>().state;
    final activeWorkspace = workspaceState.activeWorkspace;
    if (activeWorkspace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active workspace selected')),
      );
      return;
    }

    final data = CreateChannelDto(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      type: _channelType,
      workspaceId: activeWorkspace.id,
      topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
    );

    context.read<ChannelBloc>().add(ChannelCreate(data: data));
  }
}
