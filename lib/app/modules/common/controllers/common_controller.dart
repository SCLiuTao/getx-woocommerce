import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

///购物车贝塞尔曲线控制器
class CommonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  CommonController({this.startPosition, this.endPosition});
  final Offset? startPosition;
  final Offset? endPosition;

  late AnimationController _animationController; // 动画 controller
  late Animation<double> _animation; // 动画
  RxDouble left = 0.0.obs; // 小圆点的left（动态计算）
  RxDouble top = 0.0.obs; // 小远点的right（动态计算）

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    // 初始化小圆点的位置
    left.value = startPosition!.dx;
    top.value = startPosition!.dy;

    // 二阶贝塞尔曲线用值
    var x0 = startPosition!.dx;
    var y0 = startPosition!.dy;

    var x1 = startPosition!.dx - 100;
    var y1 = startPosition!.dy - 100;

    var x2 = endPosition!.dx;
    var y2 = endPosition!.dy;

    _animation.addListener(() {
      var t = _animation.value;
      left.value = pow(1 - t, 2) * x0 + 2 * t * (1 - t) * x1 + pow(t, 2) * x2;
      top.value = pow(1 - t, 2) * y0 + 2 * t * (1 - t) * y1 + pow(t, 2) * y2;
    });

    // 显示小圆点的时候动画就开始
    _animationController.forward();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
