import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonata_cine/config/helpers/ad_helper.dart';
import 'package:sonata_cine/config/helpers/human_formars.dart';
import 'package:sonata_cine/domain/entities/movie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;
  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

BannerAd? myBanner;

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myBanner = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: const BannerAdListener(),
    );
    myBanner!.load();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) {
        return;
      }

      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    //myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: myBanner!);
    final Container adContainer = Container(
      alignment: Alignment.center,
      width: myBanner!.size.width.toDouble(),
      height: myBanner!.size.height.toDouble(),
      child: adWidget,
    );
    return SizedBox(
      height: 350,
      child: Column(children: [
        if (widget.title != null || widget.subtitle != null)
          _Title(
            title: widget.title,
            subtitle: widget.subtitle,
          ),
        Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final movie = widget.movies[index];
                  return FadeInRight(child: _MoviePoster(movie: movie));
                })),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          width: 200,
          child: adContainer,
        )
      ]),
    );
  }
}

//Clase Poster
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  const _MoviePoster({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 150,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.backdropPath,
                    fit: BoxFit.cover, height: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  return GestureDetector(
                      child: FadeIn(child: child),
                      onTap: () => context.push('/movie/${movie.id}'));
                }))),
        const SizedBox(height: 5),
        /** Titulo */
        SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            )),
        SizedBox(
          width: 150,
          child: Row(children: [
            const Icon(Icons.star_outline, size: 15, color: Colors.yellow),
            const SizedBox(width: 3),
            Text('${movie.voteAverage}',
                style: textStyle.bodyMedium
                    ?.copyWith(color: Colors.yellow.shade800)),
            const Spacer(),
            Text(HumanFormat.formatNumber(movie.popularity),
                style: textStyle.bodySmall),
          ]),
        )
      ]),
    );
  }
}

//Clase Titulo
class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subtitle != null)
            FilledButton(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () {},
                child: Text(subtitle!))
        ]));
  }
}
