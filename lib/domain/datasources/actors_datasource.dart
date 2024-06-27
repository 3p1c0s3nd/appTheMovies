import 'package:sonata_cine/domain/entities/actor.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
}
