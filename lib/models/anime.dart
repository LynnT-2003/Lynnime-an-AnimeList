class Anime {
  final String title;
  final String synopsis;
  final List<String> genre;
  final String aired;
  final int episodes;
  final int members;
  final int popularity;
  final int ranked;
  final double score;
  final String imgUrl;
  final String link;

  Anime({
    required this.title,
    required this.synopsis,
    required this.genre,
    required this.aired,
    required this.episodes,
    required this.members,
    required this.popularity,
    required this.ranked,
    required this.score,
    required this.imgUrl,
    required this.link,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'] ?? '',
      synopsis: json['synopsis'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      aired: json['aired'] ?? '',
      episodes: json['episodes'] ?? 0,
      members: json['members'] ?? 0,
      popularity: json['popularity'] ?? 0,
      ranked: json['ranked'] ?? 0,
      score: json['score'] != null ? json['score'].toDouble() : 0.0,
      imgUrl: json['img_url'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
