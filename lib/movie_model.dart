class Movie {
  final String title;
  final String? posterPath;
  final String releaseDate;
  final String overview;
  final double? voteAverage; // Avaliação
  final bool isAdult; // Indica se é para público adulto
  final List<String> genres; // Gêneros
  final int? runtime; // Duração
  final String? status; // Estado
  final String originalLanguage; // Idioma original

  Movie({
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.overview,
    this.voteAverage,
    required this.isAdult,
    required this.genres,
    this.runtime,
    this.status,
    required this.originalLanguage,
  });

  // Método para criar um Movie a partir de um JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Título desconhecido',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? 'Desconhecido',
      overview: json['overview'] ?? 'Sem descrição',
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      isAdult: json['adult'] == true,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      runtime: json['runtime'],
      status: json['status'],
      originalLanguage: json['original_language'] ?? 'Desconhecido',
    );
  }

  // Método para obter a classificação etária
  String get ageRating {
    if (isAdult) {
      return 'Não recomendado para menores de 18 anos';
    }
    return 'Livre'; // Pode ser ajustado com mais detalhes se necessário
  }
}