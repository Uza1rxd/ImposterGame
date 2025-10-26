class Category {
  final String id;
  final String title;
  final String description;
  final List<String> words;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.words,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      words: List<String>.from(json['words'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'words': words,
    };
  }
}


