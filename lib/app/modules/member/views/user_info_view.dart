import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce/app/routes/app_pages.dart';
import '../../../untils/widget.dart';
import '../controllers/member_controller.dart';

class UserInfoView extends GetView<MemberController> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _myList(Icons.assignment, "myOrder".tr, () {
          Get.toNamed(Routes.MY_ORDER);
        }),
        _myList(Icons.edit_note, "personalInformation".tr, () {
          GetStorage box = GetStorage();
          Get.toNamed(Routes.REGISTRATION, arguments: box.read("userInfo"));
        }),
        _myList(Icons.post_add, "addressManage".tr, () {
          Get.toNamed(Routes.ADDRESS_MANAGE);
        }),
        _myList(Icons.language, "languages".tr, () {
          bottomSheetlanguages(context);
        }),
        _myList(Icons.support_agent, "customerPhone".tr, () {
          _makePhoneCall();
        }),
        _myList(Icons.power_settings_new, "signOut".tr, () {
          GetStorage box = GetStorage();
          final memberController = Get.put(MemberController());
          box.remove('userInfo');
          memberController.isLogin.value = false;
        })
      ],
    );
  }

  Widget _myList(IconData icon, String title, void Function()? onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 28.0,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        trailing: Icon(
          Icons.arrow_right,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }

  //拨打电话
  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+852 2732 2208',
    );

    if (!await launchUrl(launchUri)) throw 'url不能访问，异常';
  }
}
