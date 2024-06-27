import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/presentation/providers/movies/movies_providers.dart';
import 'package:sonata_cine/presentation/providers/movies/movies_slideshow_provider.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 =
      ref.watch(nowPlayingMoviesProvider).isEmpty; //Listado de peliculas
  final step2 = ref.watch(moviesSlideshowProvider).isEmpty;
  final step3 = ref.watch(nowPopularMoviesProvider).isEmpty;
  final step4 = ref.watch(nowTopRatedMoviesProvider).isEmpty;
  final step5 = ref.watch(nowUpcomingMoviesProvider).isEmpty;

  if (step1 || step2 || step3 || step4 || step5) return true;
  return false;
});
