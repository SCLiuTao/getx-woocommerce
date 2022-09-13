import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    required this.orderId,
    this.orderNumber,
    required this.payMethod,
    required this.createDate,
    required this.shippingAmount,
    required this.orderAmount,
    required this.productAmount,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverEmail,
    required this.receiverAddress,
    required this.orderStatus,
    required this.userId,
    required this.orderDetail,
  });

  String orderId;
  String? orderNumber;
  String payMethod;
  DateTime createDate;
  String shippingAmount;
  String orderAmount;
  String productAmount;
  String receiverName;
  String receiverPhone;
  String receiverEmail;
  String receiverAddress;
  String orderStatus;
  String userId;
  List<OrderDetail> orderDetail;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["orderID"],
        payMethod: json["payMethod"],
        orderNumber: json["orderNumber"],
        createDate: DateTime.parse(json["createDate"]),
        shippingAmount: json["shippingAmount"],
        orderAmount: json["orderAmount"],
        productAmount: json["productAmount"],
        receiverName: json["receiverName"],
        receiverPhone: json["receiverPhone"],
        receiverEmail: json["receiverEmail"],
        receiverAddress: json["receiverAddress"],
        orderStatus: json["orderStatus"],
        userId: json["userID"],
        orderDetail: List<OrderDetail>.from(
            json["orderDetail"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "orderNumber": orderNumber,
        "payMethod": payMethod,
        "createDate": createDate.toIso8601String(),
        "shippingAmount": shippingAmount,
        "orderAmount": orderAmount,
        "productAmount": productAmount,
        "receiverName": receiverName,
        "receiverPhone": receiverPhone,
        "receiverEmail": receiverEmail,
        "receiverAddress": receiverAddress,
        "orderStatus": orderStatus,
        "userID": userId,
        "orderDetail": List<dynamic>.from(orderDetail.map((x) => x.toJson())),
      };
}

class OrderDetail {
  OrderDetail({
    required this.detailId,
    required this.orderId,
    this.goodsName,
    this.count,
    this.salePrice,
    this.regularPrice,
    this.image,
    required this.company,
  });

  String detailId;
  String orderId;
  String? goodsName;
  String? count;
  String? salePrice;
  String? regularPrice;
  String? image;
  String company;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        detailId: json["detailID"],
        orderId: json["orderID"],
        goodsName: json["goodsName"],
        count: json["count"],
        salePrice: json["salePrice"],
        regularPrice: json["regularPrice"],
        image: json["image"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "detailID": detailId,
        "orderID": orderId,
        "goodsName": goodsName,
        "count": count,
        "salePrice": salePrice,
        "regularPrice": regularPrice,
        "image": image,
        "company": company,
      };
}
