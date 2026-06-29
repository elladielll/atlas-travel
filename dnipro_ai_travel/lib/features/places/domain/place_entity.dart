class PlaceEntity {
  final String id;
  final String cityId;
  final String countryCode;

  final Map<String, dynamic> name;
  final Map<String, dynamic> description;

  final String category;
  final double aiScore;

  const PlaceEntity({
    required this.id,
    required this.cityId,
    required this.countryCode,
    required this.name,
    required this.description,
    required this.category,
    required this.aiScore,
  });

  factory PlaceEntity.fromJson(Map<String, dynamic> json) {
    return PlaceEntity(
      id: json['id'] as String,
      cityId: json['cityId'] as String,
      countryCode: json['countryCode'] as String,
      category: json['category'] as String,
      aiScore: (json['aiScore'] as num).toDouble(),
      name: Map<String, dynamic>.from(json['name'] as Map),
      description: Map<String, dynamic>.from(json['description'] as Map),
    );
  }

  String localizedName(String locale) {
    return name[locale] ?? name['en'] ?? '';
  }

  String localizedDescription(String locale) {
    return description[locale] ?? description['en'] ?? '';
  }
}