import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';
import '../../address_manage/views/address_add_or_edit_view.dart';
import '../controllers/confirm_order_controller.dart';

class ConfirmOrderView extends GetView<ConfirmOrderController> {
  ConfirmOrderView({Key? key}) : super(key: key);
  final format = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ConfirmOrderController>(
          init: ConfirmOrderController(),
          id: "page",
          initState: (_) {},
          builder: (_) {
            return Text(
              _.isConfirmOrder ? 'confirmOrder'.tr : 'continueToPay'.tr,
              style: headingStyle,
            );
          },
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: backgroundLinearGradient),
          child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(
                      left: Get.width * 0.04,
                      right: Get.width * 0.04,
                      bottom: Get.width * 0.2),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: controller.checkedList.length,
                            itemBuilder: (context, index) {
                              final item = controller.checkedList[index];
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                    _cartImage(item),
                                    _goodesName(item),
                                    _cartPrice(item),
                                  ],
                                ),
                              );
                            }),
                        _priceDetail(context),
                        _deliveryAddress(context),
                        _paymentMethod(context)
                      ],
                    ),
                  )),
              Positioned(bottom: 0, left: 0, child: _cartBottom(context))
            ],
          )),
    );
  }

  //商品图片
  Widget _cartImage(item) {
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
            item["image"],
          ),
        ),
      ),
    );
  }

  //商品名称
  Widget _goodesName(item) {
    return Container(
      width: Get.width * 0.5,
      padding: EdgeInsets.all(3.0),
      child: Text(
        item["goodsName"],
        style: bodyStyle,
        textAlign: TextAlign.start,
      ),
    );
  }

  //商品价格
  Widget _cartPrice(item) {
    return Container(
      width: Get.width * 0.22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "\$${format.format(double.tryParse(item['salePrice']))}",
            style: bodyStyle,
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "x ${(item['count']) as int}",
              style: bodyStyle,
            ),
          )
        ],
      ),
    );
  }

  //价格明细
  Widget _priceDetail(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Column(
        children: [
          //价格明细
          Container(
            width: Get.width,
            child: Text(
              'priceDetail'.tr,
              style: headingStyle,
              textAlign: TextAlign.left,
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
                        style: bodyStyle,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'totalPiece'.trArgs(["${controller.orderCount}"]),
                        style: bodyStyle,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "\$${format.format(controller.totalProductAmount)}",
                    style: bodyStyle,
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
                  style: bodyStyle,
                ),
                (controller.totalProductAmount >= controller.freeAmount)
                    ? Text(
                        'freeShipping'.tr,
                        style: bodyStyle,
                      )
                    : Text(
                        "\$${format.format(controller.freeAmount)}",
                        style: bodyStyle,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //配送地址
  Widget _deliveryAddress(BuildContext context) {
    return GetBuilder<ConfirmOrderController>(
      init: ConfirmOrderController(),
      id: 'deliveryAddress',
      initState: (_) {},
      builder: (_) {
        if (_.isLoading) {
          return Container(
            constraints: BoxConstraints(minHeight: 150.0),
            child: Center(
              child: SizedBox(
                width: 35.0,
                height: 35.0,
                child: CircularProgressIndicator(
                  // radius: 20,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              //配送地址操作栏
              InkWell(
                onTap: () async {
                  final List<dynamic> data = _.addressList;
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
                                  style: TextButton.styleFrom(
                                      primary: Colors.green),
                                ),
                              ),
                              child: child,
                            ),
                        initialSelectedActionKey: _.addressIndex,
                        actions: data
                            .asMap()
                            .map((i, item) {
                              return MapEntry(
                                  i,
                                  AlertDialogAction(
                                      key: i, label: data[i].address));
                            })
                            .values
                            .toList());
                    if (result != null) {
                      _.changAddress(result);
                    }
                  }
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "deliveryAddress".tr,
                        style: headingStyle,
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.0),
                child: Row(
                  children: [
                    Text(
                      "${_.deliveryAddress.name ?? ""}--${_.deliveryAddress.phone ?? ""}--${_.deliveryAddress.email ?? ""}",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 15.0),
                    ),
                  ],
                ),
              ),

              //地址
              Container(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  _.deliveryAddress.address ?? "",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //支付方式
  Widget _paymentMethod(BuildContext context) {
    return GetBuilder<ConfirmOrderController>(
      init: ConfirmOrderController(),
      id: 'paymentMethod',
      initState: (_) {},
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Text(
                "paymentMethod".tr,
                style: headingStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    RadioListTile(
                        activeColor: Colors.white,
                        value: 'paypal',
                        groupValue: controller.paymentMethod,
                        contentPadding: EdgeInsets.all(0),
                        controlAffinity: ListTileControlAffinity.trailing,
                        secondary: Icon(
                          Icons.paypal,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        title: Text(
                          "paypal",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        onChanged: (value) {
                          _.changRadioGroupValue(value.toString());
                        }),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    // return Image.asset('images/paypal.png');
  }

  //底部提交订单
  Widget _cartBottom(BuildContext context) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(maxHeight: 70.0),
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
                                "\$ ${format.format(controller.totalOrderAmount)}",
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
                        text: 'totalPiece'.trArgs(["${controller.orderCount}"]),
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
          Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: InkWell(
              onTap: (() async {
                if (controller.isLoading == false) {
                  final List<dynamic> data = controller.addressList;
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
                    easyLoadingDialog(
                        "loadingFromat".trArgs(['orderSubmitting'.tr]));
                    controller.submitCount.value++;
                  }
                }
              }),
              child: GetBuilder<ConfirmOrderController>(
                init: ConfirmOrderController(),
                initState: (_) {},
                builder: (_) {
                  return Container(
                    alignment: Alignment.center,
                    child: GetBuilder<ConfirmOrderController>(
                      init: ConfirmOrderController(),
                      id: "page",
                      initState: (_) {},
                      builder: (confirmController) {
                        if (_.isLoading) {
                          return Container(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        }
                        return Text(
                          confirmController.isConfirmOrder
                              ? "submitOrder".tr
                              : "continueToPay".tr,
                          style: TextStyle(
                            color: _.isLoading == false
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
