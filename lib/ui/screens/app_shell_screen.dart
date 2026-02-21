import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/notification/notification_state.dart';

/// App shell with bottom navigation bar for tabbed navigation
class AppShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, notifState) {
          return NavigationBar(
            key: const Key('app_bottom_nav'),
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: 'Chats',
              ),
              const NavigationDestination(
                icon: Icon(Icons.tag),
                selectedIcon: Icon(Icons.tag),
                label: 'Channels',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: notifState.unreadCount > 0,
                  label: Text(
                    notifState.unreadCount > 99
                        ? '99+'
                        : notifState.unreadCount.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  child: const Icon(Icons.notifications_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: notifState.unreadCount > 0,
                  label: Text(
                    notifState.unreadCount > 99
                        ? '99+'
                        : notifState.unreadCount.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  child: const Icon(Icons.notifications),
                ),
                label: 'Notifications',
              ),
              const NavigationDestination(
                icon: Icon(Icons.more_horiz),
                selectedIcon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          );
        },
      ),
    );
  }
}
