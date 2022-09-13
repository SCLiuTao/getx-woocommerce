import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt bottomCurrentIndex = 0.obs;
  RxBool isDrawerOpen = false.obs;

  ///购物车页面位置,贝塞尔曲线终点
  Offset? endOffset;

  ///控制bottomItem状态
  changeIndex(int newIndex) {
    bottomCurrentIndex.value = newIndex;
  }
}
