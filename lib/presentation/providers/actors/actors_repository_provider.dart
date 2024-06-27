// Este repositorio es inmutable
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:sonata_cine/infrastructure/repositories/actor_repository_impl.dart';

final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMovieDbDatasource());
});
