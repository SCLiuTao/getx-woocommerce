import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woocommerce/app/untils/theme.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/member/controllers/member_controller.dart';
import '../routes/app_pages.dart';
import 'color.dart';

//自己定义购物车小红点图标
Widget appActionsCart({Key? cartkey}) {
  return GetBuilder<DashboardController>(
    init: DashboardController(),
    builder: (dashboardController) {
      return InkWell(
        onTap: () {
          dashboardController.changeIndex(3);
          Get.toNamed(Routes.DASHBOARD);
        },
        child: Container(
          width: 80.0,
          child: Stack(
            children: [
              Container(
                width: 80.0,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_cart,
                  size: 25.0,
                  color: MyColors.whiteColor,
                ),
              ),
              Positioned(
                key: cartkey,
                top: 2.0,
                right: Get.width * 0.02,
                child: GetBuilder<CartController>(
                  init: CartController(),
                  id: "cart",
                  builder: (_) {
                    return Container(
                      alignment: Alignment.center,
                      width: 20.0,
                      height: 20.0,
                      child: (_.cartCount != 0)
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              child: Text(
                                "${_.cartCount}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Center(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//导航栏抽屉
Widget drawer(BuildContext context) {
  GetStorage box = GetStorage();

  return Drawer(
    backgroundColor: Color.fromARGB(255, 247, 247, 247),
    elevation: 40.0,
    child: ListView(
      children: <Widget>[
        //侧边栏头部
        Container(
          height: 150,
          child: DrawerHeader(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 130.0, maxWidth: 130.0),
                child: ClipOval(
                  child: Image.asset(
                    // ignore: prefer_interpolation_to_compose_strings
                    "${'images/' + box.read("company")['code']}.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
        //侧边栏商品
        GetBuilder<DashboardController>(
          init: DashboardController(),
          initState: (_) {},
          builder: (dashboardController) {
            return InkWell(
              onTap: () {
                dashboardController.changeIndex(2);
                dashboardController.isDrawerOpen.value = false;
                Get.back();

                Get.toNamed(Routes.DASHBOARD);
              },
              child: ListTile(
                leading: Icon(
                  Icons.event_seat_sharp,
                  color: MyColors.listColor,
                ),
                title: Text(
                  "product".tr,
                  style: TextStyle(color: MyColors.listColor),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: MyColors.listColor,
                ),
              ),
            );
          },
        ),
        Divider(),
        //侧边栏语言
        GetBuilder<DashboardController>(
          init: DashboardController(),
          initState: (_) {},
          builder: (dashboardController) {
            return InkWell(
              onTap: () {
                dashboardController.changeIndex(1);
                dashboardController.isDrawerOpen.value = false;
                Get.back();

                Get.toNamed(Routes.DASHBOARD);
              },
              child: ListTile(
                leading: Icon(
                  Icons.category_sharp,
                  color: MyColors.listColor,
                ),
                title: Text(
                  "categroies".tr,
                  style: TextStyle(color: MyColors.listColor),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: MyColors.listColor,
                ),
              ),
            );
          },
        ),
        Divider(),
        GetBuilder<DashboardController>(
          init: DashboardController(),
          initState: (_) {},
          builder: (dashboardController) {
            return InkWell(
              onTap: () {
                dashboardController.isDrawerOpen.value = false;
                Get.back();
                bottomSheetlanguages(context);
              },
              child: ListTile(
                leading: Icon(
                  Icons.language,
                  color: MyColors.listColor,
                ),
                title: Text(
                  "languages".tr,
                  style: TextStyle(color: MyColors.listColor),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: MyColors.listColor,
                ),
              ),
            );
          },
        ),
        Divider(),
        GetBuilder<DashboardController>(
          init: DashboardController(),
          initState: (_) {},
          builder: (_) {
            return Container(
              child: Column(
                children: [
                  box.read("userInfo") != null
                      ? ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: MyColors.listColor,
                          ),
                          title: Text(
                            "signOut".tr,
                            style: TextStyle(color: MyColors.listColor),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: MyColors.listColor,
                          ),
                          onTap: () {
                            final memberController =
                                Get.put(MemberController());
                            box.remove('userInfo');
                            memberController.isLogin.value = false;
                            Get.back();
                            successSnackbar("signOutSuccess".tr);
                          },
                        )
                      : Container(),
                  box.read("userInfo") != null ? Divider() : Container()
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

//返回多店铺界面
Widget moreStroe() {
  return InkWell(
    onTap: (() => Get.back()),
    child: Container(
        padding: EdgeInsets.only(right: Get.width * 0.04),
        child: Icon(Icons.home_work)),
  );
}

//彈出多語言
Future bottomSheetlanguages(BuildContext context) {
  return Get.bottomSheet(
    BottomSheet(
      onClosing: (() {}),
      builder: (context) {
        return Container(
          height: 250.0,
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 60.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/zh-hans.png",
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    '简体',
                    style: TextStyle(
                      color: Color.fromARGB(255, 66, 66, 66),
                      fontSize: 22.0,
                    ),
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: Get.width * 0.02),
                  child: Icon(
                    Icons.check,
                    color: Get.locale.toString() == "zh_CN"
                        ? Colors.blue
                        : Colors.transparent,
                    size: 28.0,
                  ),
                ),
                onTap: () async {
                  Get.updateLocale(Locale("zh", "CN"));
                  Get.back();
                },
              ),
              Divider(),
              ListTile(
                leading: Container(
                  width: 60.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/zh-hant.png",
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    '繁體',
                    style: TextStyle(
                      color: Color.fromARGB(255, 66, 66, 66),
                      fontSize: 22.0,
                    ),
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: Get.width * 0.02),
                  child: Icon(
                    Icons.check,
                    color: Get.locale.toString() == "zh_HK"
                        ? Colors.blue
                        : Colors.transparent,
                    size: 28.0,
                  ),
                ),
                onTap: () async {
                  Get.updateLocale(Locale("zh", "HK"));
                  Get.back();
                },
              ),
              Divider(),
              ListTile(
                leading: Container(
                  width: 60.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/en.png",
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.fill,
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: Get.width * 0.02),
                  child: Icon(
                    Icons.check,
                    color: Get.locale.toString() == "en_US"
                        ? Colors.blue
                        : Colors.transparent,
                    size: 28.0,
                  ),
                ),
                title: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: Color.fromARGB(255, 66, 66, 66),
                      fontSize: 22.0,
                    ),
                  ),
                ),
                onTap: () async {
                  Get.updateLocale(Locale("en", "US"));
                  Get.back();
                },
              ),
              Divider(),
            ],
          ),
        );
      },
    ),
    //isDismissible: false,
    elevation: 10.0,
  );
}
