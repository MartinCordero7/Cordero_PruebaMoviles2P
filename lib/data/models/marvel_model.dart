import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  CatModel({
    required super.id,
    required super.url,
    required super.width,
    required super.height,
    required super.breeds,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ??
        (json['image'] is Map<String, dynamic>
            ? json['image']['url'] as String?
            : null) ??
        '';

    final width = json['width'] as int? ??
        (json['image'] is Map<String, dynamic>
            ? json['image']['width'] as int?
            : null) ??
        0;

    final height = json['height'] as int? ??
        (json['image'] is Map<String, dynamic>
            ? json['image']['height'] as int?
            : null) ??
        0;

    return CatModel(
      id: json['id'] as String? ?? '',
      url: url,
      width: width,
      height: height,
      breeds: _getBreeds(json['breeds'] as List<dynamic>?),
    );
  }

  static List<String> _getBreeds(List<dynamic>? breeds) {
    if (breeds == null) return [];
    return breeds
        .cast<Map<String, dynamic>>()
        .map((breed) => breed['name'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
      'breeds': breeds,
    };
  }
}
