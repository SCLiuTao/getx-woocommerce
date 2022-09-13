import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../untils/drawer_helper.dart';
import '../../../untils/theme.dart';
import '../../../untils/widget.dart';
import '../controllers/member_controller.dart';
import 'login_view.dart';
import 'user_info_view.dart';

class MemberView extends GetView<MemberController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isLogin.value ? 'member'.tr : "login".tr,
            style: headingStyle,
          ),
        ),
        centerTitle: true,
      ),
      drawer: drawer(context),
      onDrawerChanged: (isOpen) {
        DrawerHelp.callDrawer(isOpen);
      },
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        child: Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: controller.isLogin.value ? UserInfoView() : LoginView(),
          );
        }),
      ),
    );
  }
}
