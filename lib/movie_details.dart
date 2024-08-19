import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie_model.dart';

class MovieDetailsPage extends StatelessWidget {
  final ApiService apiService;
  final Movie movie;

  const MovieDetailsPage({
    Key? key,
    required this.apiService,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      backgroundColor: const Color.fromARGB(255, 36, 36, 44),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  width: screenWidth * 0.2,
                  height: 500,
                ),
              SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 34),
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 50),
                    Text(
                      movie.releaseDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vote Rating: ${movie.voteAverage?.toStringAsFixed(1) ?? 'Not available'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Age Rating: ${movie.ageRating}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Genre: ${movie.genres.join(', ')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Runtime: ${movie.runtime != null ? '${movie.runtime} minutes' : 'Not specified'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: ${movie.status ?? 'Not specified'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Original Language: ${movie.originalLanguage}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 66),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}