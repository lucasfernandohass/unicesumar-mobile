import 'package:drift/drift.dart';
import 'package:movies/data/database/models/database_models.dart';
import 'package:movies/data/database/database_interface.dart';
import 'package:movies/data/database/drift/movie_database.dart';

class DriftDatabase implements IDatabase {
  final MovieDatabase movieDatabase = MovieDatabase();

  DriftDatabase();

  @override
  Future deleteDatabase() async {}

  @override
  Future<List<DBMovieGenre>> getGenres() async {
    final genres = await movieDatabase.managers.driftGenre.get();
    final dbGenres = <DBMovieGenre>[];
    for (final genre in genres) {
      dbGenres.add(DBMovieGenre(
        id: genre.id,
        remoteId: genre.remoteId,
        name: genre.name,
      ));
    }
    return dbGenres;
  }

  @override
  Future<DBConfiguration?> getMovieConfiguration() async {
    final images = await movieDatabase.managers.driftConfigurationImages.get();
    final dbImages = <DBConfigurationImages>[];
    for (final genre in images) {
      dbImages.add(DBConfigurationImages(
        baseUrl: genre.baseUrl,
        secureBaseUrl: genre.secureBaseUrl,
        backdropSizes: genre.backdropSizes.split(','),
        logoSizes: genre.logoSizes.split(','),
        posterSizes: genre.posterSizes.split(','),
        profileSizes: genre.profileSizes.split(','),
        stillSizes: genre.stillSizes.split(','),
      ));
    }
    if (dbImages.isEmpty) {
      return null;
    }
    return DBConfiguration(id: 1, images: dbImages[0], changeKeys: []);
  }

  @override
  Future<DBConfiguration?> getMovieConfigurationById(int id) async {
    return getMovieConfiguration();
  }

  @override
  Future<List<DBFavorite>> getFavorites() async {
    final favorites = await movieDatabase.select(movieDatabase.driftFavorite).get();
    final dbFavorites = <DBFavorite>[];
    for (final favorite in favorites) {
      dbFavorites.add(DBFavorite(
        id: favorite.id,
        movieId: favorite.movieId,
        backdropPath: favorite.backdropPath,
        posterPath: favorite.posterPath,
        favorite: favorite.favorite,
        popularity: favorite.popularity,
        releaseDate: favorite.releaseDate,
        title: favorite.title,
        overview: favorite.overview,
      ));
    }
    return dbFavorites;
  }

  @override
  Future<bool> removeFavorite(int movieId) async {
    try {
      await (movieDatabase.delete(movieDatabase.driftFavorite)
            ..where((tbl) => tbl.movieId.equals(movieId)))
          .go();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future saveFavorite(DBFavorite favorite) async {
    await movieDatabase.into(movieDatabase.driftFavorite).insert(
          DriftFavoriteCompanion(
            movieId: Value(favorite.movieId),
            backdropPath: Value(favorite.backdropPath),
            posterPath: Value(favorite.posterPath),
            favorite: Value(favorite.favorite),
            popularity: Value(favorite.popularity),
            releaseDate: Value(favorite.releaseDate),
            title: Value(favorite.title),
            overview: Value(favorite.overview),
          ),
          onConflict: DoUpdate(
            (old) => DriftFavoriteCompanion(
              favorite: Value(favorite.favorite),
            ),
          ),
        );
  }

  @override
  Stream<List<DBFavorite>> streamFavorites() {
    return (movieDatabase.select(movieDatabase.driftFavorite).watch()).map(
      (favorites) {
        final dbFavorites = <DBFavorite>[];
        for (final favorite in favorites) {
          dbFavorites.add(DBFavorite(
            id: favorite.id,
            movieId: favorite.movieId,
            backdropPath: favorite.backdropPath,
            posterPath: favorite.posterPath,
            favorite: favorite.favorite,
            popularity: favorite.popularity,
            releaseDate: favorite.releaseDate,
            title: favorite.title,
            overview: favorite.overview,
          ));
        }
        return dbFavorites;
      },
    );
  }

  @override
  Future saveGenres(List<DBMovieGenre> genres) async {
    for (final genre in genres) {
      movieDatabase.managers.driftGenre.create((x) => DriftGenreData(
          id: genre.id, remoteId: genre.remoteId, name: genre.name));
    }
  }

  @override
  Future saveMovieConfiguration(DBConfiguration configuration) async {
    movieDatabase.managers.driftConfigurationImages
        .create((x) => DriftConfigurationImagesCompanion.insert(
              baseUrl: configuration.images.baseUrl,
              secureBaseUrl: configuration.images.secureBaseUrl,
              backdropSizes: configuration.images.backdropSizes.join(','),
              logoSizes: configuration.images.logoSizes.join(','),
              posterSizes: configuration.images.posterSizes.join(','),
              profileSizes: configuration.images.profileSizes.join(','),
              stillSizes: configuration.images.stillSizes.join(','),
            ));
  }
}
