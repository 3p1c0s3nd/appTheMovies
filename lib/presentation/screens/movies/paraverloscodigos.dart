import 'package:flutter/material.dart';
import 'package:sonata_cine/config/links_movies.dart';
import 'package:url_launcher/url_launcher.dart';

class VerMovie extends StatefulWidget {
  static const routeName = 'ver-screen';
  final String movieId;

  const VerMovie({Key? key, required this.movieId}) : super(key: key);

  @override
  _VerMovieState createState() => _VerMovieState();
}

class _VerMovieState extends State<VerMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor de Video'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print(widget.movieId);
          },
          child: const Text('Abrir en Navegador'),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (url == '') mensaje("Proximanente");
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  AlertDialog mensaje(String url) {
    return AlertDialog(
        title: const Text('Proximamente el Video'),
        content: const Text(
            "Por el momento no tenemos la pelicula por favor intente mas tarde o pruebe con otra"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ]);
  }
}
