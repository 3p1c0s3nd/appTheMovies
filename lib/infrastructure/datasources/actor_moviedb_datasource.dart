import 'package:dio/dio.dart';
import 'package:sonata_cine/config/constans.dart';
import 'package:sonata_cine/domain/datasources/actors_datasource.dart';
import 'package:sonata_cine/domain/entities/actor.dart';
import 'package:sonata_cine/infrastructure/mappers/actor_mapper.dart';
import 'package:sonata_cine/infrastructure/models/moviedb/credits_response.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Constans.moviedbKey, 'language': 'es-MX'}));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}
