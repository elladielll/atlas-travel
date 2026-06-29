class MapPlace {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double aiScore;
  final String category;

  const MapPlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.aiScore,
    required this.category,
  });

  factory MapPlace.fromJson(Map<String, dynamic> json) {
    final translations = json['place_translations'] as List? ?? [];

    String name = 'Unknown place';

    if (translations.isNotEmpty) {
      final en = translations.firstWhere(
        (item) => item['language'] == 'en',
        orElse: () => translations.first,
      );

      name = en['name'] ?? name;
    }

    return MapPlace(
      id: json['id'],
      name: name,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      aiScore: (json['ai_score'] as num).toDouble(),
      category: json['category'],
    );
  }
}