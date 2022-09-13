// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../config.dart';
import '../../../untils/theme.dart';
import 'member_controller.dart';

class LoginController extends GetxController {
  bool isShowPass = true;
  bool isLoadingLogin = false;
  GetStorage box = GetStorage();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  showTextType(bool isShowType) {
    isShowPass = isShowType;
    update(['showTextType']);
  }

  loadingLogin(bool login) {
    isLoadingLogin = login;
    update(['login']);
  }

  doLogin(Map logindata) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.login,
        data: logindata,
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        Map ret = jsonDecode(response.data);
        if (ret['code'] == 102) {
          box.write("userInfo", jsonEncode(ret['data']));
          successSnackbar("loginSuccess".tr);
          final memberController = Get.put(MemberController());
          memberController.isLogin.value = true;
        } else {
          errorSnackbar("accountOrpasswordError".tr);
        }
      }
      loadingLogin(false);
    } on DioError {
      loadingLogin(false);
      errorSnackbar("networkConnectError".tr);
    }
  }
}
