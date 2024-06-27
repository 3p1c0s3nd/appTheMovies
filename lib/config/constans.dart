import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constans {
  static String moviedbKey = dotenv.env['MOVIEDB_APIKEY']!;
}
