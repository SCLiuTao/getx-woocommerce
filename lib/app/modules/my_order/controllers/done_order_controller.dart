// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../config.dart';
import '../../../untils/theme.dart';
import '../modle/order_modle.dart';

class DoneOrderController extends GetxController {
  int currentPage = 1;
  var isLoading = true.obs;
  List<OrderModel> orderData = [];
  String noMoerText = ""; //上拉加载时没有数据时文本

  late EasyRefreshController easyRefreshController;

  @override
  void onInit() {
    getAllOrder();

    easyRefreshController = EasyRefreshController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }

  //获取所有订单
  getAllOrder() async {
    isLoading(true);
    try {
      orderData = [];
      currentPage = 1;
      Dio dio = Dio();
      GetStorage box = GetStorage();
      Map<String, dynamic> userInfo = jsonDecode(box.read("userInfo"));
      var response = await dio.post(
        Config.doneOrder,
        data: {"userID": userInfo["userID"], "currentPage": currentPage},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        orderData.addAll(orderModelFromJson(response.data));
        isLoading(false);
      }
    } on DioError {
      isLoading(false);
      errorSnackbar("networkConnectError".tr);
    }
  }

  //下拉加载更多数据
  getMoreList() async {
    currentPage++;
    try {
      Dio dio = Dio();
      GetStorage box = GetStorage();
      Map<String, dynamic> userInfo = jsonDecode(box.read("userInfo"));
      var response = await dio.post(
        Config.doneOrder,
        data: {"userID": userInfo["userID"], "currentPage": currentPage},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        List<OrderModel> orderList = orderModelFromJson(response.data);
        if (orderList.isEmpty) {
          noMoerText = "noMoreData".tr;
        } else {
          orderData.addAll(orderList);
        }
        update(['allOrderBody']);
      }
    } on DioError {
      errorSnackbar("networkConnectError".tr);
    }
  }
}
