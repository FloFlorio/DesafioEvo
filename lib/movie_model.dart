class Movie {
  final String title;
  final String? posterPath;
  final String releaseDate;
  final String overview;
  final double? voteAverage;
  final bool adult;
  final List<String> genres;
  final int? runtime;
  final String? status;
  final String originalLanguage;

  Movie({
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.overview,
    this.voteAverage,
    required this.adult,
    required this.genres,
    this.runtime,
    this.status,
    required this.originalLanguage,
  });
  
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown Title',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? 'Unknown',
      overview: json['overview'] ?? 'No descripton',
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      adult: json['adult'] ?? false,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      status: json['status'],
      originalLanguage: json['original_language'] ?? 'Unknown',
    );
  }
  
  String get ageRating {
    return adult ? 'Adult' : 'Not adult';
  }
}