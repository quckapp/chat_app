import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/search/search_bloc.dart';
import '../../../bloc/search/search_event.dart';
import '../../../bloc/search/search_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/search_result.dart';
import '../../widgets/search/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  static const _tabs = ['All', 'Messages', 'People', 'Channels', 'Files'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search messages, people, channels...',
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchBloc>().add(const SearchClearResults());
                    },
                  )
                : null,
          ),
          style: AppTypography.bodyLarge,
          autofocus: true,
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchQueryChanged(query: value));
            setState(() {});
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
          onTap: (index) {
            String? type;
            switch (index) {
              case 1:
                type = 'message';
                break;
              case 2:
                type = 'user';
                break;
              case 3:
                type = 'channel';
                break;
              case 4:
                type = 'file';
                break;
            }
            context.read<SearchBloc>().add(SearchFilterChanged(type: type));
          },
        ),
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SearchStatus.initial) {
            return _buildInitialState();
          }

          if (state.isLoading && state.results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.hasResults) {
            return _buildNoResults(state.query);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildResultsList(state.results, state),
              _buildResultsList(state.messageResults, state),
              _buildResultsList(state.userResults, state),
              _buildResultsList(state.channelResults, state),
              _buildResultsList(state.fileResults, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultsList(List<SearchResult> results, SearchState state) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results in this category',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            state.hasMore) {
          context.read<SearchBloc>().add(const SearchLoadMore());
        }
        return false;
      },
      child: ListView.separated(
        itemCount: results.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= results.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return SearchResultTile(result: results[index]);
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('Search your workspace', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Find messages, people, channels, and files',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No results found', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No results for "$query"',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
