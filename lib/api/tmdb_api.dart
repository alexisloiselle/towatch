import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_watch/models/movie.dart';
import 'package:to_watch/models/show.dart';

final String apiKey = "9ab6f25b30a4f1cdd2fb6bd1df059754";

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
      throw Exception("Failed to fetch shows query");
    }
  }

  static Future<List<Movie>> queryMovies(String query) async {
    final url = "$baseUrl$searchPath$moviePath?api_key=$apiKey&query=$query";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Movie.arrayFromTmdb(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch movies query");
    }
  }
}
