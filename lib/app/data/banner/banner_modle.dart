import 'dart:convert';

List<BannerModle> bannerFromJson(String str) => List<BannerModle>.from(
    json.decode(str).map((x) => BannerModle.fromJson(x)));

class BannerModle {
  final String guid;

  BannerModle({
    required this.guid,
  });

  factory BannerModle.fromJson(Map<String, dynamic> json) {
    return BannerModle(
      guid: json['guid'],
    );
  }
}
