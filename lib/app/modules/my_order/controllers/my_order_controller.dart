// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woocommerce/app/modules/my_order/views/done_order_view.dart';
import '../views/all_order_view.dart';
import '../views/unpay_order_view.dart';

class MyOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> tabValues = [
    Tab(
      text: 'all'.tr,
      icon: Icon(Icons.filter_frames),
      iconMargin: EdgeInsets.only(bottom: 0),
    ),
    Tab(
      text: 'completed'.tr,
      icon: Icon(Icons.published_with_changes),
      iconMargin: EdgeInsets.only(bottom: 0),
    ),
    Tab(
      text: 'Unpaid'.tr,
      icon: Icon(Icons.pending_actions),
      iconMargin: EdgeInsets.only(bottom: 0),
    ),
  ];
  final List<GetView> tabsBody = [
    AllOrderView(),
    DoneOrderView(),
    UnpayOrderView(),
  ];
  var currentIndex = 0;
  late TabController tabController;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: tabValues.length,
      vsync: this,
      initialIndex: currentIndex,
    );
    tabController.addListener(() {
      currentIndex = tabController.index;
      update(['body']);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
