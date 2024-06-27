import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/presentation/providers/providers.dart';
import 'package:sonata_cine/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: _HomeView(), bottomNavigationBar: CustomNavigationBar());
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(nowPopularMoviesProvider.notifier).loadNextPage();
    ref.read(nowTopRatedMoviesProvider.notifier).loadNextPage();
    ref.read(nowUpcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) {
      return const FullScreenLoader();
    }

    final nowPlayingMovies =
        ref.watch(nowPlayingMoviesProvider); //Listado de peliculas
    final sliceShowmovies = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(nowPopularMoviesProvider);
    final topRatedMovies = ref.watch(nowTopRatedMoviesProvider);
    final upcomingMovies = ref.watch(nowUpcomingMoviesProvider);

    //if (nowPlayingMoviesProvider == 0) return CircularProgressIndicator();
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(children: [
            //const CustomAppbar(),
            MoviesSlideshow(movies: sliceShowmovies),
            MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: "En Cines",
                subtitle: "Hoy",
                loadNextPage: () {
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  //print("Llamado del padre");
                }),
            MovieHorizontalListview(
                movies: upcomingMovies,
                title: "Proximamente",
                subtitle: "Hoy",
                loadNextPage: () {
                  ref.read(nowUpcomingMoviesProvider.notifier).loadNextPage();
                  //print("Llamado del padre");
                }),
            MovieHorizontalListview(
                movies: popularMovies,
                title: "Populares",
                subtitle: "Hoy",
                loadNextPage: () {
                  ref.read(nowPopularMoviesProvider.notifier).loadNextPage();
                  //print("Llamado del padre");
                }),
            MovieHorizontalListview(
                movies: topRatedMovies,
                title: "Mejor Calificadas",
                subtitle: "Hoy",
                loadNextPage: () {
                  ref.read(nowTopRatedMoviesProvider.notifier).loadNextPage();
                  //print("Llamado del padre");
                })
          ]);
        }, childCount: 1))
      ],
    );
  }
}
