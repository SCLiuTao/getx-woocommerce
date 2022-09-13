import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

myDialog({String? msg}) {
  return Get.dialog(
    Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              padding: EdgeInsets.all(5.0),
              height: 45.0,
              width: 45.0,
              child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              msg == null
                  ? "loadingFromat".trArgs(['loading'.tr])
                  : "loadingFromat".trArgs([msg]),
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white.withOpacity(0.9),
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

easyLoadingDialog(String messages) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = true
    ..textColor = Colors.white;
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.show(
    status: messages,
    maskType: EasyLoadingMaskType.black,
  );
}

easyLoadingToast(String messages) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.yellow
    ..displayDuration = const Duration(seconds: 3)
    ..userInteractions = true
    ..dismissOnTap = false
    ..textColor = Colors.red;
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.showToast(messages);
}

easyLoadingInfo(String messages) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..displayDuration = const Duration(seconds: 3)
    ..userInteractions = true
    ..dismissOnTap = false
    ..textColor = Colors.white;
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.showInfo(
    messages,
    maskType: EasyLoadingMaskType.black,
  );
}

easyLoadingShowToast(String messages) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.white
    ..displayDuration = const Duration(seconds: 1)
    ..userInteractions = true
    ..dismissOnTap = false
    ..textColor = Colors.white;
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.showToast(
    messages,
    toastPosition: EasyLoadingToastPosition.bottom,
  );
}
