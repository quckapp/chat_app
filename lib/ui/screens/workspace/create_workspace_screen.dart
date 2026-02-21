import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../bloc/workspace/workspace_event.dart';
import '../../../bloc/workspace/workspace_state.dart';
import '../../../core/theme/theme.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _autoSlug = true;

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workspace'),
      ),
      body: BlocListener<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          if (state.hasError && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          // Navigate on success (new workspace becomes active)
          if (state.status == WorkspaceStatus.loaded &&
              state.activeWorkspace != null &&
              state.workspaces.isNotEmpty) {
            final lastWorkspace = state.workspaces.last;
            if (lastWorkspace.name == _nameController.text.trim()) {
              context.go('/workspace/${lastWorkspace.id}');
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Workspace icon placeholder
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.workspaces_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Workspace Name',
                    hintText: 'e.g., Acme Corp',
                    prefixIcon: Icon(Icons.business),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a workspace name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (_autoSlug) {
                      _slugController.text = _generateSlug(value);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Slug field
                TextFormField(
                  controller: _slugController,
                  decoration: const InputDecoration(
                    labelText: 'URL Slug',
                    hintText: 'e.g., acme-corp',
                    prefixIcon: Icon(Icons.link),
                    helperText: 'Used in workspace URL',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a URL slug';
                    }
                    if (value.trim().length < 2) {
                      return 'Slug must be at least 2 characters';
                    }
                    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value.trim())) {
                      return 'Only lowercase letters, numbers, and hyphens';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    setState(() => _autoSlug = false);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'What is this workspace for?',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Create button
                BlocBuilder<WorkspaceBloc, WorkspaceState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Workspace'),
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<WorkspaceBloc>().add(WorkspaceCreate(
            name: _nameController.text.trim(),
            slug: _slugController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          ));
    }
  }
}
