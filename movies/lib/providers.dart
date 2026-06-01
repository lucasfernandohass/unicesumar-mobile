import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/data/database/database_interface.dart';
import 'package:movies/data/database/drift/drift_database.dart';
import 'package:movies/utils/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movies/network/movie_api_service.dart';
import 'package:movies/router/app_routes.dart' show AppRouter;
import 'package:movies/ui/movie_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumberdash/lumberdash.dart';

part 'providers.g.dart';

final heroTagProvider = StateProvider<String>((ref) {
  return '';
});

@Riverpod(keepAlive: true)
MovieAPIService movieAPIService(MovieAPIServiceRef ref) => MovieAPIService();

@Riverpod(keepAlive: true)
Future<MovieViewModel> movieViewModel(MovieViewModelRef ref) async {
  final database = await ref.read(driftDatabaseProvider.future);
  final model = MovieViewModel(
      database: database, movieAPIService: ref.read(movieAPIServiceProvider));
  await model.setup();
  return model;
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPrefs(SharedPrefsRef ref) =>
    SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
Future<Prefs> prefs(PrefsRef ref) async {
  final sharedPrefs = await ref.read(sharedPrefsProvider.future);
  return Prefs(sharedPrefs);
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(true) {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode') ?? true;
      state = isDark;
    } catch (e) {
      state = true; // Default to dark mode
    }
  }

  void toggleTheme() async {
    state = !state;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', state);
    } catch (e) {
      logMessage('Error saving theme preference: $e');
    }
  }

  void setDarkMode(bool isDark) async {
    state = isDark;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDark);
    } catch (e) {
      logMessage('Error saving theme preference: $e');
    }
  }
}

@Riverpod(keepAlive: true)
Future<IDatabase> driftDatabase(DriftDatabaseRef ref) {
  return Future.value(DriftDatabase());
}

final appRouterProvider = Provider((ref) {
  return AppRouter();
});
