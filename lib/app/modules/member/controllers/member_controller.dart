import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MemberController extends GetxController {
  GetStorage box = GetStorage();
  RxBool isLogin = false.obs;
  Map currentUserInfo = {}.obs;

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }

  @override
  void onClose() {}

  //检查用户是否登录
  checkLogin() async {
    var userInfo = await box.read("userInfo");

    if (userInfo != null) {
      isLogin.value = true;
      currentUserInfo = jsonDecode(userInfo);
    }
  }
}
