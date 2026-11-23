import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tp4_dap/entities/movie.dart';

final moviesProvider =
    StateNotifierProvider<MoviesNotifier, AsyncValue<List<Movie>>>(
      (ref) => MoviesNotifier(),
    );

class MoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  MoviesNotifier() : super(const AsyncLoading()) {
    _loadingFuture = _loadMovies();
  }

  late Future<void> _loadingFuture;

  Future<void> _loadMovies() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('peliculas')
          .get();
      state = AsyncData(
        snapshot.docs
            .map((doc) => Movie.fromFirestore(doc.id, doc.data()))
            .toList(),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> reload() {
    state = const AsyncLoading();
    _loadingFuture = _loadMovies();
    return _loadingFuture;
  }

  Future<List<Movie>> _currentMovies() async {
    if (state.isLoading) await _loadingFuture;
    if (state.hasError) throw state.error!;
    return state.valueOrNull ?? const [];
  }

  Future<void> addMovie(Movie movie) async {
    final currentMovies = await _currentMovies();
    final newMovie = Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: movie.title,
      genre: movie.genre,
      year: movie.year,
      duration: movie.duration,
      rating: movie.rating,
      description: movie.description,
      posterUrl: movie.posterUrl,
      director: movie.director,
      accentColor: movie.accentColor,
    );

    await FirebaseFirestore.instance
        .collection('peliculas')
        .doc(newMovie.id)
        .set(newMovie.toFirestore());
    state = AsyncData([...currentMovies, newMovie]);
  }

  Future<void> updateMovie(Movie updatedMovie) async {
    final currentMovies = await _currentMovies();
    await FirebaseFirestore.instance
        .collection('peliculas')
        .doc(updatedMovie.id)
        .set(updatedMovie.toFirestore());
    state = AsyncData(
      currentMovies
          .map((movie) => movie.id == updatedMovie.id ? updatedMovie : movie)
          .toList(),
    );
  }

  Future<void> deleteMovie(String id) async {
    final currentMovies = await _currentMovies();
    await FirebaseFirestore.instance.collection('peliculas').doc(id).delete();
    state = AsyncData(currentMovies.where((movie) => movie.id != id).toList());
  }
}
