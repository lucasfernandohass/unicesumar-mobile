import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movies/providers.dart';
import 'package:movies/router/app_routes.dart';

@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      routes: const [
        HomeRoute(),
        GenreRoute(),
        FavoriteRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) => buildBottomBar(tabsRouter),
    );
  }

  Widget buildBottomBar(TabsRouter tabsRouter) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () {
                    themeNotifier.toggleTheme();
                  },
                ),
              ],
            ),
          ),
          NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.category), label: 'Genre'),
              NavigationDestination(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
            ],
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (navIndex) {
              setState(() {
                tabsRouter.setActiveIndex(navIndex);
              });
            },
          ),
        ],
      ),
    );
  }
}
