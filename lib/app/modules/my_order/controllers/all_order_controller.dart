// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../config.dart';
import '../../../data/address/address_modle.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';
import '../modle/order_modle.dart';

class AllOrderController extends GetxController {
  int currentPage = 1;
  var isLoading = true.obs;
  List<OrderModel> orderData = [];
  int addressIndex = 0; //更改地址时的默认lsit索引
  bool isLoadingAddress = true; //加载地址进度
  List addressList = <AddressListData>[]; //全部地址List
  late AddressListData deliveryAddress; //更改送货地址
  String paymentMethod = "paypal"; //支付方式
  RxInt submitCount = 0.obs; //支付按钮点击次数，供debounce使用
  late OrderModel submitData; //申明提交付款数据
  String noMoerText = ""; //上拉加载时没有数据时文本

  late EasyRefreshController easyRefreshController;

  @override
  void onInit() {
    getAllOrder();
    getDeliveryAddress();
    debounce(submitCount, (callback) {
      doSubmitOrder();
    }, time: const Duration(seconds: 1));

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
        Config.allOrder,
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

  //获取配送地址
  getDeliveryAddress() async {
    changStatus(true);
    try {
      Dio dio = Dio();
      GetStorage box = GetStorage();
      Map<String, dynamic> userInfo = jsonDecode(box.read("userInfo"));

      var response = await dio.post(
        Config.addressAll,
        data: {"userID": userInfo["userID"]},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        AddressModel addList = AddressModel.fromJson(jsonDecode(response.data));

        addressList = addList.data!;
        getDefaultAddress(addressList);
        changStatus(false);
      }
    } on DioError {
      changStatus(false);
      errorSnackbar("networkConnectError".tr);
    }
  }

  //获取默认地址
  getDefaultAddress(List<dynamic> addressList) {
    int tempIndex = 0;
    addressIndex = 0;
    for (var item in addressList) {
      if (item.defaultAddres == "1") {
        addressIndex = tempIndex;
      }
      tempIndex++;
    }
    deliveryAddress = addressList[addressIndex];
    update(['deliveryAddress']);
  }

  //更改地址时的加载动画
  changStatus(bool newval) {
    isLoadingAddress = newval;
    update();
  }

  //修改订单配送地址
  changAddress(int index) {
    deliveryAddress = addressList[index];
    addressIndex = index;
    update(['deliveryAddress']);
  }

  //更改支付方式
  changRadioGroupValue(String newVal) {
    paymentMethod = newVal;
    update(['paymentMethod']);
  }

  //提交订单
  doSubmitOrder() async {
    if (paymentMethod == "paypal") {
      getPaypalConfig().then((paypalConfig) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (paypalConfig != null) {
          Get.to(
            () => UsePaypal(
              sandboxMode: paypalConfig['sandboxMode'] == "true" ? true : false,
              clientId: paypalConfig['clientId'],
              secretKey: paypalConfig['clientSecret'],
              returnURL: paypalConfig['returnURL'],
              cancelURL: paypalConfig['cancelURL'],
              transactions: [
                {
                  "amount": {
                    "total": submitData.orderAmount,
                    "currency": "HKD",
                    "details": {
                      "subtotal": submitData.productAmount,
                      "shipping": NumUtil.subtract(
                          double.parse(submitData.orderAmount),
                          double.parse(submitData.productAmount)),
                      "shipping_discount": 0,
                    }
                  },
                  "description": "Shopping",
                  "item_list": {
                    "items": submitData.orderDetail
                        .asMap()
                        .map((key, value) {
                          return MapEntry(key, {
                            "name": value.goodsName,
                            "quantity": value.count,
                            "price": value.salePrice,
                            "currency": "HKD"
                          });
                        })
                        .values
                        .toList()

                    // shipping address is not required though
                    // "shipping_address": {
                    //   "recipient_name": "scyb",
                    //   "line1": "白云龙归",
                    //   "line2": "",
                    //   "city": "广州",
                    //   "country_code": "CN",
                    //   "postal_code": "000000",
                    //   "phone": "19157451386",
                    //   "state": "广东"
                    // },
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (Map params) async {
                easyLoadingDialog("loadingFromat".trArgs(['pleaseWait'.tr]));
                updateDatabase(params['data']['cart']);
              },
              onError: (error) {
                easyLoadingInfo("paymentError".tr);
              },
              onCancel: (params) {
                easyLoadingInfo("cancelPayment".tr);
              },
            ),
          );
        }
      });
    }
  }

  //获取paypal配置
  getPaypalConfig() async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.getPaypalCofig,
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      errorSnackbar("networkConnectError".tr);
    }
  }

  //更新订单
  updateDatabase(String orderNumber) async {
    Map<String, dynamic> orderList = {
      'deliveryAddress': deliveryAddress.address, //配送地址
      'receiverName': deliveryAddress.name, //收货人姓名
      'receiverPhone': deliveryAddress.phone, //收货人电话
      'receiverEmail': deliveryAddress.email, //收货人电邮
      'orderNumber': orderNumber, //订单编号
      'orderStatus': "complete",
      'orderID': submitData.orderId,
      'userID': submitData.userId,
      'payMethod': paymentMethod,
    };
    // 写入数据库
    try {
      Dio dio = Dio();
      var response = await dio.post(
        Config.orderWriter,
        data: orderList,
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

        if (ret['ret'] == "success") {
          if (Get.isBottomSheetOpen == true) {
            Get.back();
          }
          orderData = [];
          getAllOrder();
        }
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
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
        Config.allOrder,
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
