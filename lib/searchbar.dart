import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie_model.dart';
import 'movie_details.dart';

class SearchBarPage extends StatefulWidget {
  final ApiService apiService;

  const SearchBarPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Movie>>? _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
  }

  void _searchMovies(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _searchResults = widget.apiService.searchMovies(query);
      } else {
        _searchResults = Future.value([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          // Widget alinhado à direita acima da barra de pesquisa
          Container(
            padding: EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 233, 244, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Se precisar de algum outro widget à esquerda, você pode adicionar aqui
                Text(
                  'Welcome to EvoFlix',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 24.0),
                ),
              ],
            ),
          ),
          // Barra de Pesquisa
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onChanged: _searchMovies,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          // Corpo da Página com a lista de filmes
          Expanded(
            child: Container(
            color: const Color.fromARGB(255, 233, 244, 255),
              child: FutureBuilder<List<Movie>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No movies found'));
                  }

                  // Sort movies by releaseDate
                  final movies = snapshot.data!;
                  movies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));

                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return ListTile(
                        leading: movie.posterPath != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                width: screenWidth * 0.025, // Ajustar a largura com base na tela
                                height: 100,
                              )
                            : null,
                        title: Text(movie.title),
                        subtitle: Text(movie.releaseDate),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                apiService: widget.apiService,
                                movie: movie,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}