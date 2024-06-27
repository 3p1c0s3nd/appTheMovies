import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonata_cine/domain/entities/movie.dart';
import 'package:sonata_cine/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;
  static const routeName = 'movie-screen';
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieInfoProvider);
    final movie = movies[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Pelicula ${widget.movieId}'),
        ),
        body:
            CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
          _Cuerpo(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _MovieDescription(movie: movie);
          }, childCount: 1))
        ]));
  }
}

class _Cuerpo extends StatelessWidget {
  final Movie movie;
  const _Cuerpo({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
        backgroundColor: Colors.black,
        expandedHeight: size.height * 0.7,
        foregroundColor: Colors.black,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          /*title: Text(
            movie.title,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.start,
          ),*/
          background: _PeliculaPoster(movie: movie),
        ));
  }
}

class _PeliculaPoster extends StatelessWidget {
  final Movie movie;
  const _PeliculaPoster({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox.expand(
        child: Image.network(movie.backdropPath, fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress != null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FadeIn(child: child);
        }),
      ),
      const SizedBox.expand(
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
            0.7,
            1.0
          ],
                      colors: [
            Colors.transparent,
            Colors.black87,
          ])))),
      const SizedBox.expand(
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      stops: [0.0, 0.3],
                      colors: [Colors.black87, Colors.transparent]))))
    ]);
  }
}

class _MovieDescription extends StatelessWidget {
  final Movie movie;
  const _MovieDescription({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(movie.posterPath, width: size.width * 0.3),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(children: [
              Text(movie.title, style: textStyle.titleLarge),
              Text(movie.overview, style: textStyle.bodyMedium),
            ]),
          )
        ]),
      ),

      //Generos de la pelicula
      Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          children: [
            ElevatedButton(
                onPressed: () {
                  context.push('/movie/video/${movie.id}');
                },
                child: const Text("Ver Pelicula")),
            ...movie.genreIds.map((gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ))
          ],
        ),
      ),
      const SizedBox(height: 5),
      //Mostrar Actores
      _ActorByMovie(movieId: movie.id.toString()),
      const SizedBox(height: 100),
    ]);
  }
}

class _ActorByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = ref.watch(actorsByMovieProvider);
    if (actors.isEmpty) {
      return const Text("No hay actores para esta pelicula");
    }

    if (actors[movieId] == null) {
      return const CircularProgressIndicator();
    }

    final actorsList = actors[movieId]!;

    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount: actorsList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final actor = actorsList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                        placeholder: const AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(actor.profilePath),
                        height: 150,
                        width: 100,
                        fit: BoxFit.cover),
                  ),
                  Text(
                    actor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }),
    );
  }
}
