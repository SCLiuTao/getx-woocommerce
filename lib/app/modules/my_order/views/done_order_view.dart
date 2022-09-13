import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

import '../../../untils/loading.dart';
import '../controllers/done_order_controller.dart';
import '../modle/order_modle.dart';

class DoneOrderView extends GetView {
  DoneOrderView({Key? key}) : super(key: key);
  final format = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return GetX<DoneOrderController>(
      init: DoneOrderController(),
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
            child: GetBuilder<DoneOrderController>(
              init: DoneOrderController(),
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
                        "completed".tr,
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
                  padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        _orderNo(orderItem),
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
              Container(height: 10.0),
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

  //訂單編號
  _orderNo(OrderModel orderItem) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: Get.width,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: Row(
        children: [
          Text(
            "orderNo".tr,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "${orderItem.orderNumber}",
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "|",
              style: TextStyle(fontSize: 15.0, color: Colors.black38),
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: orderItem.orderNumber));
              easyLoadingShowToast("copySuccess".tr);
            },
            child: Text(
              "copy".tr,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
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
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "deliveryAddress".tr,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Text(
                "${orderItem.receiverName}--${orderItem.receiverPhone}--${orderItem.receiverEmail}",
              ),
              Text(orderItem.receiverAddress),
            ],
          )
        ],
      ),
    );
  }

  // //支付方式
  Widget _paymentMethod(BuildContext context, OrderModel orderItem) {
    return GetBuilder<DoneOrderController>(
      init: DoneOrderController(),
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
                      onChanged: (value) {}),
                ],
              )
            ],
          ),
        );
      },
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
