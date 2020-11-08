import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watchlist/models/movie.dart';
import 'package:watchlist/models/show.dart';

final String apiKey = DotEnv().env['TMDB_API_KEY'];

final String baseUrl = "https://api.themoviedb.org/3";
final String searchPath = "/search";
final String moviePath = "/movie/";
final String tvPath = "/tv/";

class TmdbApi {
  static Future<List<Show>> queryShows(String query) async {
    final url = "$baseUrl$searchPath$tvPath?api_key=$apiKey&query=$query";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Show.arrayFromTmdb(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode}: ${response.body}");
    }
  }

  static Future<List<Movie>> queryMovies(String query) async {
    final url = "$baseUrl$searchPath$moviePath?api_key=$apiKey&query=$query";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Movie.arrayFromTmdb(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode}: ${response.body}");
    }
  }
}
