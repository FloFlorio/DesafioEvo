import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class ApiService {
  final String apiKey = 'b60328e181e925b7ebead7cdc9a18489';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
  final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final movieIds = (data['results'] as List)
        .map((item) => item['id'] as int)
        .toList();

    // Obter detalhes completos para cada filme
    final movieDetailsFutures = movieIds.map((id) => getMovieDetails(id)).toList();
    final movies = await Future.wait(movieDetailsFutures);

    return movies;
  } else {
    throw Exception('Falha ao carregar filmes');
    }
}

  Future<Movie> getMovieDetails(int movieId) async {
  final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=videos,credits'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Movie.fromJson(data);
  } else {
    throw Exception('Falha ao carregar detalhes do filme');
  }
}
}