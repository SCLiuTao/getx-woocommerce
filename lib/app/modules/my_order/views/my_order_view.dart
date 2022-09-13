import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../untils/theme.dart';
import '../controllers/my_order_controller.dart';

class MyOrderView extends GetView<MyOrderController> {
  const MyOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'myOrder'.tr,
          style: headingStyle,
        ),
        elevation: 0.5,
        shadowColor: Colors.white,
        bottom: _bottomBar(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        child: GetBuilder<MyOrderController>(
          init: MyOrderController(),
          id: "body",
          initState: (_) {},
          builder: (_) {
            return TabBarView(
              controller: _.tabController,
              children: _.tabsBody,
            );
          },
        ),
      ),
    );
  }

  TabBar _bottomBar() {
    return TabBar(
        tabs: controller.tabValues,
        controller: controller.tabController,
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        indicatorWeight: 2.0,
        labelStyle:
            TextStyle(height: 2, fontSize: 17.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            TextStyle(height: 2, fontSize: 15.0, fontWeight: FontWeight.bold),
        splashBorderRadius: BorderRadius.circular(20));
  }
}
