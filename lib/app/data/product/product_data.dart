import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../config.dart';
import '../../untils/theme.dart';
import '../product/product_modle.dart';
import 'package:get_storage/get_storage.dart';

class ProductData {
  static getProduct() async {
    GetStorage box = GetStorage();
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.product,
        data: {'company': box.read("company")['code']},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        return productFromJson(response.data);
      }
    } on DioError {
      errorSnackbar("networkConnectError".tr);
      print(DioError);
    }
  }

  static getCateToProduct(arguments) async {
    GetStorage box = GetStorage();
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.catetoproduct,
        queryParameters: {'company': box.read("company")['code']},
        data: arguments,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        return productFromJson(response.data);
      }
    } on DioError {
      errorSnackbar("networkConnectError".tr);
      print(DioError);
    }
  }
}
