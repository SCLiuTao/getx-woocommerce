// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:woocommerce/app/modules/cart/controllers/cart_controller.dart';
import '../../../../config.dart';
import '../../../data/address/address_modle.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';

class ConfirmOrderController extends GetxController {
  GetStorage box = GetStorage();
  List checkedList = []; //选中商品list
  List uncheckedList = []; //末选中商品list
  int orderCount = 0; //订单总商品数量
  double totalProductAmount = 0; //总商品价格
  double totalOrderAmount = 0; //订单总价格
  double freeAmount = 300; //免费配送条件
  int addressIndex = 0; //更改地址时的默认lsit索引
  List addressList = <AddressListData>[]; //全部地址List
  bool isLoading = true; //加载地址进度
  late AddressListData deliveryAddress; //更改送货地址
  String paymentMethod = "paypal"; //支付方式
  RxInt submitCount = 0.obs; //支付按钮点击次数，供debounce使用
  List<dynamic> paypalList = []; //支付时的List
  bool isConfirmOrder = true; //默认是确认订单，当出现支付错误时供继续付款使用
  int? orderID;
  @override
  void onInit() {
    cartInfo();
    getDeliveryAddress();
    debounce(submitCount, (callback) {
      doSubmitOrder();
    }, time: const Duration(seconds: 1));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //更改支付方式
  changRadioGroupValue(String newVal) {
    paymentMethod = newVal;
    update(['paymentMethod']);
  }

  //获取购物车信息
  cartInfo() {
    List tempList = box.read("cartInfo") ?? [];

    for (var item in tempList) {
      if (item['isCheck'] == true) {
        checkedList.add(item);
      } else {
        uncheckedList.add(item);
      }
    }
    totalAmont(checkedList);
  }

  //计算订单总金额
  totalAmont(List orderList) {
    totalProductAmount = 0;
    totalOrderAmount = 0;
    orderCount = 0;
    for (var item in orderList) {
      totalProductAmount = NumUtil.add(
          (item["count"] as int) * double.parse(item['salePrice']),
          totalProductAmount);
      orderCount += (item['count'] as int);
    }
    if (totalProductAmount >= freeAmount) {
      totalOrderAmount = totalProductAmount;
    } else {
      totalOrderAmount = totalProductAmount + freeAmount;
    }
  }

  //更改地址时的加载动画
  changStatus(bool newval) {
    isLoading = newval;
    update();
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
          sendTimeout: 10,
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

  //修改订单配送地址
  changAddress(int index) {
    deliveryAddress = addressList[index];
    addressIndex = index;
    update(['deliveryAddress']);
  }

  //提交订单
  doSubmitOrder() async {
    if (paymentMethod == "paypal") {
      getPaypalConfig().then((paypalConfig) {
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        //print("订单ＩＤ:$checkedList");
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
                    "total": totalOrderAmount,
                    "currency": "HKD",
                    "details": {
                      "subtotal": totalProductAmount,
                      "shipping": totalOrderAmount - totalProductAmount,
                      "shipping_discount": 0,
                    }
                  },
                  "description": "Shopping",
                  "item_list": {
                    "items": checkedList
                        .asMap()
                        .map((key, value) {
                          return MapEntry(key, {
                            "name": value['goodsName'],
                            "quantity": value['count'],
                            "price": value['salePrice'],
                            "currency": "HKD"
                          });
                        })
                        .values
                        .toList(),

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
                //print("成功: ${params['data']['cart']}");
                // print("成功: $params");
                easyLoadingDialog("loadingFromat".trArgs(['pleaseWait'.tr]));
                if (orderID == null) {
                  writeDatabase(params['data']['cart'], true);
                } else {
                  //继续付款怕情况
                  writeDatabase(params['data']['cart'], true, isUpdate: true);
                }
              },
              onError: (error) {
                //print("失敗: $error");
                easyLoadingInfo("paymentError".tr);
                changpage();
                if (orderID == null) {
                  writeDatabase("", false);
                }
              },
              onCancel: (params) {
                easyLoadingInfo("cancelPayment".tr);
                print('取消: $params');
                changpage();
                if (orderID == null) {
                  writeDatabase("", false);
                }
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

  //写入数据库
  writeDatabase(String orderNumber, bool isComplete,
      {bool isUpdate = false}) async {
    Map<String, dynamic> userInfo = jsonDecode(box.read("userInfo"));

    Map<String, dynamic> orderList = {
      "orderDetail": jsonEncode(checkedList),
      'deliveryAddress': deliveryAddress.address, //配送地址
      'receiverName': deliveryAddress.name, //收货人姓名
      'receiverPhone': deliveryAddress.phone, //收货人电话
      'receiverEmail': deliveryAddress.email, //收货人电邮
      'totalProductAmount': totalProductAmount, //总商品价格
      'totalOrderAmount': totalOrderAmount, //订单总价格
      'orderNumber': orderNumber, //订单编号
      'orderStatus': (isComplete == true ? "complete" : "cancle"),
      'userID': userInfo['userID'],
      'payMethod': paymentMethod,
    };

    if (isUpdate == true && orderID != null) {
      if (!orderList.containsKey("orderID")) {
        orderList.addAll({"orderID": orderID});
      }
    }

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
      box.write("cartInfo", uncheckedList);
      if (response.statusCode == 200) {
        //重载购物车
        final cartController = Get.put(CartController());
        cartController.refreshCart();
        if (orderID == null && isComplete == false) {
          //如果是继续付，获取生成订单ＩＤ
          Map responseMap = jsonDecode(response.data);
          orderID = responseMap["orderID"];
        }

        if (isComplete) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          easyLoadingInfo('paySuccess'.tr);
          Future.delayed(Duration(seconds: 1), () => Get.back());
        }
      }
    } on DioError {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      errorSnackbar("networkConnectError".tr);
    }
  }

  //出现错误或取消支付时更改页面类型
  changpage() {
    isConfirmOrder = false;
    update(['page']);
  }
}
