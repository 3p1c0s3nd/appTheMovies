import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/domain/entities/movie.dart';
import 'package:sonata_cine/presentation/providers/movies/movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  if (nowPlayingMovies.isEmpty) return [];

  return nowPlayingMovies.sublist(0, 7);
});
