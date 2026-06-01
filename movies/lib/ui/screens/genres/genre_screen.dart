import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/data/models/genre_state.dart';
import 'package:movies/data/models/models.dart';
import 'package:movies/providers.dart';
import 'package:movies/router/app_routes.dart';
import 'package:movies/ui/movie_viewmodel.dart';
import 'package:movies/ui/screens/genres/genre_search_row.dart';
import 'package:movies/ui/screens/genres/genre_section.dart';
import 'package:movies/ui/screens/genres/sort_picker.dart';
import 'package:movies/ui/widgets/not_ready.dart';
import 'package:movies/ui/widgets/sliver_divider.dart';
import 'package:movies/ui/widgets/vert_movie_list.dart';
import 'package:movies/utils/utils.dart';
import 'package:movies/utils/prefs.dart';

@RoutePage(name: 'GenreRoute')
class GenreScreen extends ConsumerStatefulWidget {
  const GenreScreen({super.key});

  @override
  ConsumerState<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends ConsumerState<GenreScreen> {
  late MovieViewModel movieViewModel;
  String currentSearchString = '';
  List<GenreState> genreStates = [];
  List<MovieResults> currentMovieList = [];
  final moviesNotifier = ValueNotifier<List<MovieResults>>([]);
  final expandedNotifier = ValueNotifier<bool>(false);
  MovieResponse? currentMovieResponse;
  Sorting selectedSort = Sorting.aToz;
  Prefs? prefsInstance;
  List<int> restoredGenreIds = [];
  bool preferencesRestored = false;
  bool initialSearchScheduled = false;

  @override
  void initState() {
    super.initState();
    // Restore preferences after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restorePreferences();
    });
  }

  void _restorePreferences() async {
    final prefs = await ref.read(prefsProvider.future);
    final selectedGenres = prefs.getGenreSelectedIds();
    setState(() {
      prefsInstance = prefs;
      currentSearchString = prefs.getGenreSearchTerm();
      selectedSort = Sorting.values[prefs.getGenreSortOrder()];
      restoredGenreIds = selectedGenres;
      preferencesRestored = true;
    });

    if (genreStates.isNotEmpty && restoredGenreIds.isNotEmpty) {
      setState(() {
        genreStates = genreStates
            .map((state) => GenreState(
                  genre: state.genre,
                  isSelected: restoredGenreIds.contains(state.genre.id),
                ))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieViewModelAsync = ref.watch(movieViewModelProvider);
    return movieViewModelAsync.when(
      error: (e, st) => Text(e.toString()),
      loading: () => const NotReady(),
      data: (viewModel) {
        movieViewModel = viewModel;
        buildGenreState();
        return buildScreen();
      },
    );
  }

  void buildGenreState() {
    if (genreStates.isEmpty) {
      final selectedIds = restoredGenreIds.toSet();
      genreStates = movieViewModel.movieGenres!
          .map((genre) => GenreState(
                genre: genre,
                isSelected: selectedIds.contains(genre.id),
              ))
          .toList();
    }
  }

  Widget buildScreen() {
    if (preferencesRestored && !initialSearchScheduled &&
        (currentSearchString.isNotEmpty ||
            genreStates.any((genreState) => genreState.isSelected))) {
      initialSearchScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        search();
      });
    }

    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 16.0, 0.0, 24.0),
                          child: Text('Find a Movie',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        GenreSearchRow(
                          (searchString) {
                            currentSearchString = searchString;
                            if (prefsInstance != null) {
                              prefsInstance!.setGenreSearchTerm(searchString);
                            }
                            currentMovieResponse = null;
                            FocusScope.of(context).unfocus();
                            expandedNotifier.value = false;
                            search();
                          },
                          initialValue: currentSearchString,
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: expandedNotifier,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return GenreSection(
                            genreStates: genreStates,
                            isExpanded: value,
                            onGenresExpanded: (expanded) {
                              expandedNotifier.value = expanded;
                            },
                            onGenresSelected: (genres) {
                              genreStates = genres;
                              if (prefsInstance != null) {
                                prefsInstance!
                                    .setGenreSelectedIds(genres.map((e) => e.genre.id).toList());
                              }
                              currentMovieResponse = null;
                            });
                      }),
                  const SliverDivider(),
                  SortPicker(
                      useSliver: true,
                      initialSelectedSort: selectedSort,
                      onSortSelected: (sorting) {
                        selectedSort = sorting;
                        if (prefsInstance != null) {
                          prefsInstance!.setGenreSortOrder(sorting.index);
                        }
                        sortMovies();
                      }),
                  ValueListenableBuilder<List<MovieResults>>(
                    valueListenable: moviesNotifier,
                    builder: (BuildContext context, List<MovieResults> value,
                        Widget? child) {
                      return VerticalMovieList(
                        movies: value,
                        movieViewModel: movieViewModel,
                        onMovieTap: (movieId) {
                          context.router
                              .push(MovieDetailRoute(movieId: movieId));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<MovieResults>?> search() async {
    if (currentSearchString.isEmpty && genreStates.isEmpty) {
      moviesNotifier.value = <MovieResults>[];
      return <MovieResults>[];
    }

    // 1st, search by title
    // Search through the list for the search string
    final pageNumber = (currentMovieResponse?.page == null)
        ? 1
        : (currentMovieResponse!.page + 1);
    if (currentSearchString.isNotEmpty) {
      currentMovieResponse =
          await movieViewModel.searchMovies(currentSearchString, pageNumber);
      currentMovieList = currentMovieResponse!.results;
    }
    // 2nd Search by genre if there is no search string
    if (currentSearchString.isEmpty && genreStates.isNotEmpty) {
      final buffer = getGenreString();
      currentMovieResponse = await movieViewModel.searchMoviesByGenre(
          buffer.toString(), pageNumber);
      currentMovieList = currentMovieResponse!.results;
      // 3rd Search through the movies to see if they match our genres
    } else if (genreStates.isNotEmpty && currentMovieList.isNotEmpty) {
      currentMovieList = currentMovieList.where((movie) {
        for (final selectedGenre in genreStates) {
          if (movie.genreIds.contains(selectedGenre.genre.id)) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    sortMovies();
    return currentMovieList;
  }

  StringBuffer getGenreString() {
    final buffer = StringBuffer();
    genreStates.map((e) {
      if (e.isSelected) {
        if (buffer.isNotEmpty) {
          buffer.write('|');
        }
        buffer.write(e.genre.id);
      }
    }).toList();
    return buffer;
  }

  void sortMovies() {
    if (currentMovieList.isEmpty) {
      return;
    }
    currentMovieList = currentMovieList.sorted((a, b) {
      switch (selectedSort) {
        case Sorting.aToz:
          return a.originalTitle.compareTo(b.originalTitle);
        case Sorting.zToa:
          return b.originalTitle.compareTo(a.originalTitle);
        case Sorting.rating:
          return b.popularity.compareTo(a.popularity);
        case Sorting.year:
          if (a.releaseDate != null && b.releaseDate != null) {
            return a.releaseDate!.compareTo(b.releaseDate!);
          }
      }
      return 0;
    });
    moviesNotifier.value = currentMovieList;
  }
}
