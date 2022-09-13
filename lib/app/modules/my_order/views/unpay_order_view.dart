import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import '../../../untils/loading.dart';
import '../../address_manage/views/address_add_or_edit_view.dart';
import '../controllers/unpay_order_controller.dart';
import '../modle/order_modle.dart';

class UnpayOrderView extends GetView {
  UnpayOrderView({Key? key}) : super(key: key);
  final format = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return GetX<UnpayOrderController>(
      init: UnpayOrderController(),
      builder: (_) {
        if (_.isLoading.value) {
          return Container(
            height: Get.height,
            width: Get.width,
            child: SkeletonListView(),
          );
        } else if (_.orderData.isEmpty) {
          return SingleChildScrollView(
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: Get.height * 0.1),
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.4,
                            color: Color.fromARGB(26, 255, 255, 255)),
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "images/noOrder.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "noRelatedOrders".tr,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
            ),
          );
        }
        final List<OrderModel> orderData = _.orderData;

        return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
            child: GetBuilder<UnpayOrderController>(
              init: UnpayOrderController(),
              id: "allOrderBody",
              initState: (_) {},
              builder: (_) {
                return EasyRefresh(
                  controller: _.easyRefreshController,
                  header: MaterialHeader(),
                  footer: ClassicalFooter(
                      enableInfiniteLoad: true,
                      enableHapticFeedback: true,
                      loadingText: "loadingFromat".trArgs(['loading'.tr]),
                      loadedText: "loadingCompleted".tr,
                      noMoreText: _.noMoerText,
                      infoText: "updateAt".tr,
                      infoColor: Colors.white,
                      textColor: Colors.white),
                  onRefresh: () async {
                    _.easyRefreshController.resetLoadState();
                    _.getAllOrder();
                  },
                  onLoad: () async {
                    await Future.delayed(Duration(seconds: 3), () {
                      _.getMoreList();
                      if (_.noMoerText != "") {
                        _.easyRefreshController
                            .finishLoad(success: true, noMore: true);
                      }
                    });
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: orderData.length,
                    itemBuilder: (context, index) {
                      return _orderItem(context, orderData[index]);
                    },
                  ),
                );
              },
            ));
      },
    );
  }

  //每一项订单
  Widget _orderItem(BuildContext context, OrderModel orderItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //订单左边部分
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "orderDate".trArgs([
                            DateUtil.formatDateStr(
                                orderItem.createDate.toString(),
                                format: "yyyy-M-d HH:mm")
                          ]),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "orderAmount".trArgs(
                            [
                              format.format(
                                  double.tryParse(orderItem.orderAmount))
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "${"productTotalAmount".tr}: ${format.format(double.tryParse(orderItem.productAmount))}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "${"deliveryService".tr}: ${format.format(double.tryParse(orderItem.shippingAmount))}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //订单右边边部分
                Container(
                  alignment: Alignment.centerRight,
                  width: 140.0,
                  child: Column(
                    children: [
                      Text(
                        "Unpaid".tr,
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Color.fromARGB(248, 238, 127, 119)),
                      ),
                      SizedBox(
                        height: Get.height * 0.012,
                      ),
                      OutlinedButton(
                        onPressed: () => orderDetails(context, orderItem),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.yellow),
                            side: MaterialStateProperty.all(BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(235, 221, 132, 125)))),
                        child: Text(
                          'viewDetails'.tr,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Color.fromARGB(248, 209, 83, 74)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //底部弹出订单详情页
  Future orderDetails(BuildContext context, OrderModel orderItem) {
    final List<OrderDetail> orderDetail = orderItem.orderDetail;
    return Get.bottomSheet(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Stack(
            children: [
              Container(
                width: Get.width,
                child: Container(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.9),
                  padding: EdgeInsets.only(top: 60.0, bottom: 80.0),
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: orderDetail.length,
                            itemBuilder: (context, index) {
                              final orderDetailItem = orderDetail[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _cartImage(orderDetailItem),
                                    _goodesName(orderDetailItem),
                                    _productPrice(orderDetailItem),
                                  ],
                                ),
                              );
                            }),
                        _priceDetail(context, orderItem),
                        _deliveryAddress(context, orderItem),
                        _paymentMethod(context, orderItem),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: _orderBottom(context, orderItem),
              ),
              _bottomHeader(context),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        enableDrag: true);
  }

  //商品图片
  Widget _cartImage(OrderDetail item) {
    return Container(
      width: Get.width * 0.2,
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: FadeInImage(
          fit: BoxFit.cover,
          fadeOutDuration: Duration(milliseconds: 100),
          placeholder: AssetImage("images/default.png"),
          image: NetworkImage(
            item.image ?? "",
          ),
        ),
      ),
    );
  }

  //商品名称
  Widget _goodesName(OrderDetail item) {
    return Container(
      width: Get.width * 0.5,
      padding: EdgeInsets.all(3.0),
      child: Text(
        item.goodsName ?? "",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }

  //商品价格
  Widget _productPrice(OrderDetail item) {
    return Container(
      width: Get.width * 0.22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "\$${format.format(double.tryParse(item.salePrice ?? "0"))}",
            style: TextStyle(fontSize: 15.0),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "x ${item.count}",
              style: TextStyle(fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }

  //价格明细
  Widget _priceDetail(BuildContext context, OrderModel orderItem) {
    final List<OrderDetail> orderDetail = orderItem.orderDetail;

    int orderCount = 0; //订单总商品数量
    for (var element in orderDetail) {
      orderCount += (int.parse(element.count ?? "0"));
    }
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          //价格明细
          Container(
            width: Get.width,
            child: Text(
              'priceDetail'.tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //商品总价
          Container(
            padding: EdgeInsets.only(top: 3.0),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        'productTotalAmount'.tr,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'totalPiece'.trArgs(["$orderCount"]),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "\$${format.format(double.parse(orderItem.productAmount))}",
                  ),
                )
              ],
            ),
          ),
          //配送服务
          Container(
            padding: EdgeInsets.only(top: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'deliveryService'.tr,
                ),
                Text(
                  "\$${format.format(double.parse(orderItem.shippingAmount))}",
                ),
              ],
            ),
          ),
          //订单总价
          Container(
            padding: EdgeInsets.only(top: 3.0),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        'orderTotalAmount'.tr,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "\$${format.format(double.parse(orderItem.orderAmount))}",
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // //配送地址
  Widget _deliveryAddress(BuildContext context, OrderModel orderItem) {
    return InkWell(
      onTap: () async {
        final controller = Get.put(UnpayOrderController());
        final List<dynamic> data = controller.addressList;
        if (data.isEmpty) {
          //当地址为空的时候
          final result = showOkCancelAlertDialog(
            barrierDismissible: false,
            context: context,
            title: 'systemMessage'.tr,
            message: 'noShippingAddress'.tr,
            okLabel: 'confirm'.tr,
            cancelLabel: 'cancel'.tr,
            onWillPop: () => Future.value(false),
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
              Get.to(() => AddressAddOrEditView());
            }
          });
        } else {
          final result = await showConfirmationDialog<int>(
              context: context,
              title: 'addressManage'.tr,
              message: 'changeShippingAddress'.tr,
              cancelLabel: 'cancel'.tr,
              okLabel: 'confirm'.tr,
              builder: (context, child) => Theme(
                    data: ThemeData(
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(primary: Colors.green),
                      ),
                    ),
                    child: child,
                  ),
              initialSelectedActionKey: controller.addressIndex,
              actions: data
                  .asMap()
                  .map((i, item) {
                    return MapEntry(
                        i, AlertDialogAction(key: i, label: data[i].address));
                  })
                  .values
                  .toList());
          if (result != null) {
            controller.changAddress(result);
          }
        }
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "deliveryAddress".tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  size: 25.0,
                  color: Colors.black45,
                ),
              ],
            ),
            GetBuilder<UnpayOrderController>(
              init: UnpayOrderController(),
              id: 'deliveryAddress',
              initState: (_) {},
              builder: (_) {
                if (_.isLoadingAddress) {
                  return Container(
                    constraints: BoxConstraints(minHeight: 150.0),
                    child: Center(
                      child: SizedBox(
                        width: 35.0,
                        height: 35.0,
                        child: CircularProgressIndicator(
                          // radius: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: Colors.black12))),
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Row(
                          children: [
                            Text(
                              "${_.deliveryAddress.name ?? ""}--${_.deliveryAddress.phone ?? ""}--${_.deliveryAddress.email ?? ""}",
                              // style: TextStyle(
                              //     color: Colors.white.withOpacity(0.9), fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),

                      //地址
                      Container(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Text(
                          _.deliveryAddress.address ?? "",
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // //支付方式
  Widget _paymentMethod(BuildContext context, OrderModel orderItem) {
    return GetBuilder<UnpayOrderController>(
      init: UnpayOrderController(),
      id: 'paymentMethod',
      initState: (_) {},
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Text("paymentMethod".tr,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Column(
                children: [
                  RadioListTile(
                      activeColor: Colors.green,
                      value: 'paypal',
                      groupValue: orderItem.payMethod,
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.trailing,
                      secondary: Icon(
                        Icons.paypal,
                        size: 25.0,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "paypal",
                        style: TextStyle(fontSize: 17.0),
                      ),
                      onChanged: (value) {
                        _.changRadioGroupValue(value.toString());
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //底部提交订单
  Widget _orderBottom(BuildContext context, OrderModel orderItem) {
    final List<OrderDetail> orderDetailItem = orderItem.orderDetail;
    int orderCount = 0; //订单总商品数量

    for (var element in orderDetailItem) {
      orderCount += (int.parse(element.count ?? "0"));
    }

    return Container(
      width: Get.width,
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.orange,
      ),
      child: Row(
        children: [
          Center(
            child: Container(
              width: (Get.width * 0.65),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${"total".tr} : ",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text:
                                "\$ ${format.format(double.parse(orderItem.orderAmount))}",
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'totalPiece'.trArgs(["$orderCount"]),
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<UnpayOrderController>(
            init: UnpayOrderController(),
            initState: (_) {},
            builder: (_) {
              return Container(
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: InkWell(
                  onTap: (() async {
                    if (_.isLoadingAddress == false) {
                      final List<dynamic> data = _.addressList;
                      if (data.isEmpty) {
                        final result = showOkCancelAlertDialog(
                          barrierDismissible: false,
                          context: context,
                          title: 'systemMessage'.tr,
                          message: 'noShippingAddress'.tr,
                          okLabel: 'confirm'.tr,
                          cancelLabel: 'cancel'.tr,
                          onWillPop: () => Future.value(false),
                          builder: (context, child) => Theme(
                            data: ThemeData(
                              textButtonTheme: TextButtonThemeData(
                                style:
                                    TextButton.styleFrom(primary: Colors.green),
                              ),
                            ),
                            child: child,
                          ),
                        );
                        result.then((value) {
                          if (value == OkCancelResult.ok) {
                            Get.to(() => AddressAddOrEditView());
                          }
                        });
                      } else {
                        easyLoadingDialog(
                            "loadingFromat".trArgs(['orderSubmitting'.tr]));
                        _.submitData = orderItem;
                        _.submitCount.value++;
                      }
                    }
                  }),
                  child: Container(
                    alignment: Alignment.center,
                    child: GetBuilder<UnpayOrderController>(
                      init: UnpayOrderController(),
                      initState: (_) {},
                      builder: (_) {
                        if (_.isLoadingAddress) {
                          return Container(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }
                        return Text(
                          "continueToPay".tr,
                          style: TextStyle(
                            color: _.isLoadingAddress == false
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //bottomSheet头部
  Widget _bottomHeader(BuildContext context) {
    return Positioned(
      left: 0.0,
      top: 0.0,
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        width: Get.width,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: Get.width,
              height: 60.0,
              child: Text(
                "orderDetails".tr,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
                right: Get.width * 0.01,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                  ),
                  onPressed: () => Get.back(),
                ))
          ],
        ),
      ),
    );
  }
}
