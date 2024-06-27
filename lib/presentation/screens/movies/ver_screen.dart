import 'package:flutter/material.dart';
import 'package:sonata_cine/config/links_movies.dart';
import 'package:url_launcher/url_launcher.dart';

class VerMovie extends StatefulWidget {
  static const routeName = 'ver-screen';
  final String movieId;

  const VerMovie({Key? key, required this.movieId}) : super(key: key);

  @override
  VerMovieState createState() => VerMovieState();
}

class VerMovieState extends State<VerMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor de Video'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final link = LinkMovies().links.firstWhere(
                  (movie) => movie["id"] == widget.movieId,
                  orElse: () => {"url": ""},
                );

            if (link["url"].isEmpty) {
              mensaje("Próximamente");
            } else {
              _launchURL(link["url"]);
            }
          },
          child: const Text('Abrir en Navegador'),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) {
      mensaje("Próximamente");
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Future<void> mensaje(String mensaje) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Próximamente el Video'),
        content: Text(
          "Por el momento no tenemos la película, por favor intente más tarde o pruebe con otra. Mensaje: $mensaje",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
