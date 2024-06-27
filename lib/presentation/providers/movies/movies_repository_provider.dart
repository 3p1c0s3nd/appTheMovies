import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/infrastructure/datasources/moviedb_datasource.dart';
import 'package:sonata_cine/infrastructure/repositories/movie_repository_impl.dart';

//es de solo lectura, dar la informacion a todos los widgets
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieDBDatasource());
});
