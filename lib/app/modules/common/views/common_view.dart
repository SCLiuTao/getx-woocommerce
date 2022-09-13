import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/common_controller.dart';

class CommonView extends GetView<CommonController> {
  final Offset? startPosition;
  final Offset? endPosition;

  ///贝塞尔曲线视图
  const CommonView({Key? key, this.startPosition, this.endPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CommonController>(
      init: CommonController(
          startPosition: startPosition, endPosition: endPosition),
      initState: (_) {},
      builder: (_) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: controller.left.value,
              top: controller.top.value,
              child: ClipOval(
                  child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                color: Colors.red,
                child: Text(
                  "+1",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
            ),
          ],
        );
      },
    );
  }
}
