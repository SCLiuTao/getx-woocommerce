import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../config.dart';
import '../../untils/theme.dart';
import 'banner_modle.dart';
import 'package:get_storage/get_storage.dart';

class BannerData {
  static getBanner() async {
    GetStorage box = GetStorage();
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.banner,
        data: {'company': box.read("company")['code']},
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        return bannerFromJson(response.data);
      }
    } on DioError {
      errorSnackbar("networkConnectError".tr);
      print(DioError);
    }
  }
}
