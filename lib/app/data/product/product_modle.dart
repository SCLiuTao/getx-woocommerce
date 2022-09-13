import 'dart:convert';

List<ProductModle> productFromJson(String str) => List<ProductModle>.from(
      json.decode(str).map(
            (x) => ProductModle.fromJson(x),
          ),
    );

class ProductModle {
  final String? id;
  final String? postTitle;
  //final String? postContent; //内容描述
  final String? postExcerpt; //简短说明
  final String? stock; //数量
  final String? sku;
  final String? regularPrice; //原价
  final String? salePrice; //销售价格
  final String? guid; //产品图片
  final List<String>? imageArr; //产品轮播图

  ProductModle({
    this.id,
    this.postTitle,
    //this.postContent,
    this.postExcerpt,
    this.stock,
    this.sku,
    this.regularPrice,
    this.salePrice,
    this.guid,
    this.imageArr,
  });

  factory ProductModle.fromJson(Map<String, dynamic> json) {
    return ProductModle(
      id: json['ID'] ?? "",
      postTitle: json['post_title'] ?? "",
      //postContent: json['postContent'] ?? "",
      postExcerpt: json['post_excerpt'] ?? "",
      stock: json['_stock'] ?? "0",
      sku: json['_sku'] ?? "",
      regularPrice: json['_regular_price'] ?? "0",
      salePrice: json['_sale_price'] ?? "0",
      guid: json['guid'] ?? "",
      imageArr:
          json["imageArr"] == null ? null : List<String>.from(json['imageArr']),
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_title": postTitle,
        "post_excerpt": postExcerpt,
        "_stock": stock,
        "_sku": sku,
        "_regular_price": regularPrice,
        "_sale_price": salePrice,
        "guid": guid,
        "imageArr": List<dynamic>.from(imageArr!.map((x) => x)),
      };
}
