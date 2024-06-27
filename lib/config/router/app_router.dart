import 'package:go_router/go_router.dart';
import 'package:sonata_cine/presentation/screens/movies/ver_screen.dart';
import 'package:sonata_cine/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: "/", routes: [
  GoRoute(
      path: "/",
      name: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
            path: "movie/:movieId",
            name: MovieScreen.routeName,
            builder: (context, state) {
              final movieId = state.pathParameters["movieId"] ?? "no ID";
              return MovieScreen(movieId: movieId);
            }),
        GoRoute(
            path: "movie/video/:movieId",
            name: VerMovie.routeName,
            builder: (context, state) {
              final movieId = state.pathParameters["movieId"] ?? "no ID";
              return VerMovie(movieId: movieId);
            })
      ]),
]);
