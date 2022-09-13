import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/color.dart';
import '../../../untils/drawer_helper.dart';
import '../../../untils/loading.dart';
import '../../../untils/theme.dart';
import '../../../untils/widget.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  final format = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cart'.tr,
          style: headingStyle,
        ),
        actions: [moreStroe()],
        centerTitle: true,
      ),
      drawer: drawer(context),
      onDrawerChanged: (isOpen) {
        DrawerHelp.callDrawer(isOpen);
      },
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: Get.width * 0.03,
                  right: Get.width * 0.03,
                  bottom: Get.width * 0.2),
              child: GetBuilder<CartController>(
                id: "cart",
                builder: (controller) {
                  if (controller.cartList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: controller.cartList.length,
                      itemBuilder: (context, index) {
                        final item = controller.cartList[index];
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
                            children: <Widget>[
                              _cartCheckBt(item),
                              _cartImage(item),
                              _cartGoodesName(item),
                              _cartPrice(item),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Container(
                          padding: EdgeInsets.only(bottom: 100.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200.0,
                                height: 200.0,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(8, 10, 10, 10),
                                  child: Image.asset(
                                    "images/emptyCart.png",
                                    width: 180.0,
                                    height: 180.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              Text(
                                "購物车空空如也",
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    );
                  }
                },
              ),
            ),
            GetBuilder<CartController>(
              id: "cart",
              builder: (_) {
                if (_.cartList.isNotEmpty) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    child: _cartBottom(context),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  //多选按钮
  Widget _cartCheckBt(item) {
    return Container(
      alignment: Alignment.center,
      width: Get.width * 0.1,
      padding: EdgeInsets.only(right: 10.0),
      child: Checkbox(
        //shape: CircleBorder(side: BorderSide(color: Colors.green)),
        value: item["isCheck"],
        activeColor: MyColors.whiteColor,
        checkColor: Colors.pink,
        onChanged: (bool? val) {
          item['isCheck'] = val;
          controller.changcheckState(item);
        },
      ),
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
  Widget _cartGoodesName(item) {
    return Container(
      width: Get.width * 0.41,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(children: [
        Text(
          item["goodsName"],
          style: bodyStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        _cartCount(item),
      ]),
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
          if (double.tryParse(item['salePrice']) != 0.00 &&
              double.tryParse(item['regularPrice']) !=
                  double.tryParse(item['salePrice']))
            Text(
              "\$${format.format(double.tryParse(item['regularPrice']))}",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[800],
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          if (double.tryParse(item['salePrice']) != 0.00)
            Text(
              "\$${format.format(double.tryParse(item['salePrice']))}",
              style: bodyStyle,
            ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: InkWell(
              onTap: () {
                controller.deleteOneGoods(item);
              },
              child: Icon(
                Icons.delete_forever,
                color: MyColors.whiteColor,
                size: 35.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  //购物车商品数量加减
  Widget _cartCount(item) {
    return Container(
      width: 130.0,
      height: 35.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: MyColors.whiteColor),
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: Row(
        children: [
          //减少
          InkWell(
            onTap: () {
              controller.addofReduceAction(item, false);
            },
            child: Container(
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item['count'] > 1 ? Colors.transparent : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  bottomLeft: Radius.circular(6.0),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: item['count'] > 1 ? MyColors.whiteColor : Colors.grey,
              ),
            ),
          ),
          //数量
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1.0,
                  color: MyColors.borderColor,
                ),
                left: BorderSide(
                  width: 1.0,
                  color: MyColors.borderColor,
                ),
              ),
            ),
            alignment: Alignment.center,
            width: 48.0,
            child: Text(
              item['count'].toString(),
              style: bodyStyle,
            ),
          ),
          //增加
          InkWell(
            onTap: () {
              controller.addofReduceAction(item, true);
            },
            child: Container(
              width: 40.0,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: MyColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //底部结算
  Widget _cartBottom(BuildContext context) {
    return Container(
      width: Get.width,
      constraints: BoxConstraints(maxHeight: 70.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(10.0),
        //   topRight: Radius.circular(10.0),
        // ),
      ),
      child: Row(
        children: [
          Container(
            width: Get.width * 0.3,
            child: CheckboxListTile(
              contentPadding: EdgeInsets.only(left: 5.0),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: MyColors.whiteColor,
              checkColor: Colors.pink,
              value: controller.isAllCheck,
              onChanged: (bool? val) {
                controller.changAllCheck(val!);
              },
              title: Text(
                "checkAll".tr,
                style: TextStyle(
                    color: MyColors.whiteColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Container(
            width: (Get.width * 0.42),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "${"total".tr} : \$ ${format.format(controller.totalAmount)}",
                style: headingStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Container(
            width: Get.width * 0.28,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              // borderRadius:
              //     BorderRadius.only(topRight: Radius.circular(10.0)),
            ),
            child: InkWell(
              onTap: (() {
                if (controller.cartCheckedCount == 0) {
                  easyLoadingToast('noCheckedProdcut'.tr);
                } else {
                  GetStorage box = GetStorage();
                  if (box.read("userInfo") == null) {
                    final dashboardController = Get.put(DashboardController());
                    dashboardController.changeIndex(4);
                    easyLoadingToast('pleaseSigin'.tr);
                    Future.delayed(Duration(seconds: 3),
                        (() => Get.toNamed(Routes.DASHBOARD)));
                  } else {
                    Get.toNamed(Routes.CONFIRM_ORDER);
                  }
                }
              }),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "checkOut".trArgs(["${controller.cartCheckedCount}"]),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
