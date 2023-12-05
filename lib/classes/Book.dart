class Book {
  int id;
  String title;
  String author;
  String coverUrl;
  String downloadUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        coverUrl: json['cover_url'],
        downloadUrl: json['download_url'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['author'] = author;
    data['cover_url'] = coverUrl;
    data['download_url'] = downloadUrl;

    return data;
  }
}
