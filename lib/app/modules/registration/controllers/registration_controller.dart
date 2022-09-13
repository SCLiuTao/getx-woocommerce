// ignore_for_file: unnecessary_overrides
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../member/controllers/member_controller.dart';
import 'reister_modle.dart';

class RegistrationController extends GetxController {
  GetStorage box = GetStorage();
  bool isShowPassword = true;
  int radioGroupValue = 0;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  showTextType(bool isShowType) {
    isShowPassword = isShowType;
    update(['password']);
  }

  changRadioGroupValue(int newVal) {
    radioGroupValue = newVal;
    update(['radioGroupValue']);
  }

  @override
  void onClose() {}

  doRegister(RegisterModle modle) async {
    easyLoadingDialog("loadingFromat".trArgs(['loading'.tr]));
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.register,
        data: modle.toJson(),
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        Map ret = jsonDecode(response.data);
        if (ret['code'] == 101) {
          errorSnackbar("emailExits".tr);
        } else {
          final dashboardController = Get.put(DashboardController());
          dashboardController.changeIndex(4);
          box.write("registerInfo", modle.toJson());
          Get.offNamed(Routes.DASHBOARD);
        }
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      errorSnackbar("networkConnectError".tr);
    }
  }

  doEdit(Map editData) async {
    easyLoadingDialog("loadingFromat".trArgs(['saving'.tr]));
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.edit,
        data: editData,
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }

        Map ret = jsonDecode(response.data);
        if (ret['code'] == 200) {
          box.remove("userInfo");
          box.write("registerInfo", ret['data']);
          successSnackbar("editSuccess".tr);
          final memberController = Get.put(MemberController());
          memberController.isLogin.value = false;

          Get.toNamed(Routes.DASHBOARD);
        }
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      errorSnackbar("networkConnectError".tr);
    }
  }
}
