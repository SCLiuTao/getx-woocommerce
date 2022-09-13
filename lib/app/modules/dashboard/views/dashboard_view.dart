import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../all_categroies/controllers/all_categroies_controller.dart';
import '../../all_categroies/views/all_categroies_view.dart';
import '../../all_product/controllers/all_product_controller.dart';
import '../../all_product/views/all_product_view.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/views/cart_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../member/controllers/member_controller.dart';
import '../../member/views/member_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final homeController = Get.put(HomeController());
  final allProductContrroller = Get.put(AllProductController());
  final allCategroiesController = Get.put(AllCategroiesController());
  final cartController = Get.put(CartController());
  final memberController = Get.put(MemberController());

  final List<Widget> tabodies = [
    HomeView(),
    AllCategroiesView(),
    AllProductView(),
    CartView(),
    MemberView(),
  ];

  final GlobalKey cartKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox? box = cartKey.currentContext!.findRenderObject() as RenderBox?;
      controller.endOffset = box!.localToGlobal(Offset.zero);
    });
    return Obx(() {
      int currentIndex = controller.bottomCurrentIndex.value;
      return WillPopScope(
        onWillPop: (() async {
          return false;
        }),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (controller.isDrawerOpen.value) {
                controller.isDrawerOpen.value = false;
                Get.back();
              }
              controller.changeIndex(4);
            },
            child: Icon(
              Icons.account_circle,
              size: 30.0,
              color: currentIndex == 4
                  ? Colors.white
                  : Color.fromARGB(255, 66, 66, 66),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Color.fromARGB(101, 206, 7, 140),
            shape: const CircularNotchedRectangle(),
            child: Container(
              height: 60.0,
              child: Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _itemTabbar(Get.width * 0.23,
                          index: 0,
                          currentIndex: currentIndex,
                          icon: Icons.home,
                          title: "home".tr),
                      _itemTabbar(Get.width * 0.23,
                          index: 1,
                          currentIndex: currentIndex,
                          icon: Icons.category,
                          title: "categroies".tr),
                      _itemTabbar(Get.width * 0.08),
                      _itemTabbar(Get.width * 0.23,
                          index: 2,
                          currentIndex: currentIndex,
                          icon: Icons.store_sharp,
                          title: "product".tr),
                      _itemTabbar(Get.width * 0.23,
                          index: 3,
                          currentIndex: currentIndex,
                          icon: Icons.shopping_cart,
                          title: "cart".tr),
                    ],
                  ),
                  Positioned(
                    key: cartKey,
                    top: 2.0,
                    right: Get.width * 0.02,
                    child: GetBuilder<CartController>(
                      init: CartController(),
                      id: "cart",
                      builder: (_) {
                        return Container(
                          alignment: Alignment.center,
                          width: 23.0,
                          height: 23.0,
                          child: (_.cartCount != 0)
                              ? CircleAvatar(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    "${_.cartCount}",
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.white),
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
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabodies,
          ),
        ),
      );
    });
  }

  Widget _itemTabbar(
    double itemWidth, {
    int? index,
    int? currentIndex,
    IconData? icon,
    String? title,
  }) {
    TextStyle itemTitleStyle =
        TextStyle(fontSize: 14, color: Color.fromARGB(255, 66, 66, 66));
    Color itemIconColor = Color.fromARGB(255, 66, 66, 66);
    double iconSize = 26;
    if (currentIndex == index) {
      itemTitleStyle = TextStyle(fontSize: 16, color: Colors.white);
      itemIconColor = Colors.white;
      iconSize = 28.0;
    }
    return InkWell(
      onTap: () {
        if (controller.isDrawerOpen.value) {
          controller.isDrawerOpen.value = false;
          Get.back();
        }
        controller.changeIndex(index!);
      },
      child: Container(
        alignment: Alignment.center,
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(icon, color: itemIconColor, size: iconSize)
                : Container(),
            title != null ? Text(title, style: itemTitleStyle) : Container()
          ],
        ),
      ),
    );
  }

  // final List<BottomNavigationBarItem> bottomTabs = [
  //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "首頁"),
  //   BottomNavigationBarItem(icon: Icon(Icons.category), label: "類目"),
  //   BottomNavigationBarItem(icon: Icon(Icons.store_sharp), label: "商品"),
  //   BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "購物車"),
  // ];
  // Widget build(BuildContext context) {
  //   return Obx(() {
  //     int currentIndex = controller.bottomCurrentIndex.value;
  //     return Scaffold(
  //       backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
  //       bottomNavigationBar: BottomNavigationBar(
  //         type: BottomNavigationBarType.fixed,
  //         unselectedItemColor: Colors.grey[600],
  //         selectedItemColor: Colors.orange,
  //         currentIndex: currentIndex,
  //         items: bottomTabs,
  //         onTap: (index) {
  //           controller.changeIndex(index);
  //         },
  //       ),
  //       body: IndexedStack(
  //         index: currentIndex,
  //         children: tabodies,
  //       ),
  //     );
  //   });
  // }
}
