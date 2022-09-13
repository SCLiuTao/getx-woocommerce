import 'dart:convert';

AddressModel addressFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
    this.code,
    this.msg,
    this.data,
  });

  int? code;
  String? msg;
  List<AddressListData>? data;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        code: json["code"],
        msg: json["msg"],
        data: List<AddressListData>.from(
            json["data"].map((x) => AddressListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AddressListData {
  AddressListData({
    this.addressId,
    this.userId,
    this.address,
    this.defaultAddres,
    this.email,
    this.name,
    this.phone,
  });

  String? addressId;
  String? userId;
  String? address;
  String? defaultAddres;
  String? email;
  String? name;
  String? phone;

  factory AddressListData.fromJson(Map<String, dynamic> json) =>
      AddressListData(
        addressId: json["addressID"],
        userId: json["userID"],
        address: json["address"],
        defaultAddres: json["defaultAddres"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "addressID": addressId,
        "userID": userId,
        "address": address,
        "defaultAddres": defaultAddres,
        "email": email,
        "name": name,
        "phone": phone,
      };
}
