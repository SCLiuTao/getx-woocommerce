import 'dart:convert';

List<CategoryModle> categroyFromJson(String str) => List<CategoryModle>.from(
    json.decode(str).map((x) => CategoryModle.fromJson(x)));

class CategoryModle {
  final String? termID;
  final String? name;
  final String? imagePath;
  final String? count;

  CategoryModle({
    this.termID,
    this.name,
    this.imagePath,
    this.count,
  });

  factory CategoryModle.fromJson(Map<String, dynamic> json) {
    return CategoryModle(
      termID: json['term_id'] ?? "",
      name: json['name'] ?? "",
      imagePath: json['imagePath'] ?? "",
      count: json['count'] ?? 0,
    );
  }
}
