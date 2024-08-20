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
  Future<List<Movie>>? _recentMovies;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
    _recentMovies = widget.apiService.getRecentMovies();
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
    final searchQuery = _controller.text;

    return Scaffold(
      body: Column(
        children: [
          // EvoFlix
          Container(
            padding: EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 17, 17, 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome to EvoFlix',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          
          // Searchbar
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
                  prefixIcon: SizedBox(
                    width: 20.0,
                    height: 10.0,
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),

          // BodyPage
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 20, 20, 20),
              child: FutureBuilder<List<Movie>>(
                future: searchQuery.isEmpty ? _recentMovies : _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final movies = snapshot.data;

                  if (searchQuery.isEmpty && (movies == null || movies.isEmpty)) {
                    return Center(
                      child: Text(
                        'No recent movies found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (movies == null || movies.isEmpty) {
                    return Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (searchQuery.isNotEmpty) {
                    movies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Recent movies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return GestureDetector(
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
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                child: Row(
                                  children: [
                                    movie.posterPath != null
                                        ? SizedBox(
                                            width: screenWidth * 0.075,
                                            height: 150,
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                            ),
                                          )
                                        : Container(
                                            width: screenWidth * 0.075,
                                            height: 150,
                                            color: Colors.grey,
                                            child: Center(child: Text('No Image')),
                                          ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(height: 24.0),
                                          Text(
                                            movie.releaseDate,
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
