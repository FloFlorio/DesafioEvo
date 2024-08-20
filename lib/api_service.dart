import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class ApiService {
  final String apiKey = 'API_KEY'; //Set you're API Key here!
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movieIds = (data['results'] as List)
          .map((item) => item['id'] as int)
          .toList();

      final movieDetailsFutures = movieIds.map((id) => getMovieDetails(id)).toList();
      final movies = await Future.wait(movieDetailsFutures);

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=videos,credits'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> getRecentMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movieIds = (data['results'] as List)
          .map((item) => item['id'] as int)
          .toList();

      final movieDetailsFutures = movieIds.map((id) => getMovieDetails(id)).toList();
      final movies = await Future.wait(movieDetailsFutures);

      return movies;
    } else {
      throw Exception('Failed to load recent movies');
    }
  }
}
