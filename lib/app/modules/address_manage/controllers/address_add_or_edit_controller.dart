// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';

class AddressAddOrEditController extends GetxController {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool switchValue = false;

  late StreamSubscription<Map<String, Object>> _locationListener;

  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  changeSwitch(bool newval) {
    switchValue = newval;
    update(['defaultSwitch']);
  }

  doSubmit(Map addressData) async {
    easyLoadingDialog("loadingFromat".trArgs(['saving'.tr]));
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.addressAddOrEdit,
        data: addressData,
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        Map ret = jsonDecode(response.data);
        if (ret['code'] == 200) {
          Get.back(result: 'success');
          successSnackbar("updateSuccess".tr);
        }
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      errorSnackbar("networkConnectError".tr);
    }
  }

  //高德使用
  amapLocation(BuildContext context) {
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey(
      "86344eef666374492eecee6ec1750c20",
      "1329cc7bdc8c8b282ccdfc94f832310b",
    );
    // 动态申请定位权限
    requestPermission(context);
    //iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }
    //注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      if (result.isNotEmpty && result['address'] != null) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        //移除定位监听
        _locationListener.cancel();

        ///销毁定位
        _locationPlugin.destroy();

        addressController.text = result['address'].toString();
        update(['aMapAddress']);
      }
    });
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  void requestPermission(BuildContext context) async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
      easyLoadingDialog("loadingFromat".trArgs(['positioning'.tr]));
    } else {
      print("定位权限申请不通过");
      final result = showOkCancelAlertDialog(
        barrierDismissible: false,
        context: context,
        title: 'systemMessage'.tr,
        message: 'NoLocationPermission'.tr,
        okLabel: 'openNow'.tr,
        cancelLabel: 'cancel'.tr,
        onWillPop: () => Future.value(false),
        //isDestructiveAction: true,
        builder: (context, child) => Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Colors.green),
            ),
          ),
          child: child,
        ),
      );
      result.then((value) {
        if (value == OkCancelResult.ok) {
          openAppSettings();
        }
      });
    }
  }

  // 申请定位权限
  // 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }
}
