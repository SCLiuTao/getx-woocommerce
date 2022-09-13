import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import '../../../data/product/product_modle.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/color.dart';
import '../../../untils/theme.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  @override
  Widget build(BuildContext context) {
    ProductModle productInfo = Get.arguments;
    final format = NumberFormat("#,##0.00", "en_US");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productInfo.postTitle.toString(),
          style: headingStyle,
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: backgroundLinearGradient),
            padding: EdgeInsets.only(
                left: Get.width * 0.04, right: Get.width * 0.04),
            child: Container(
              child: ListView(
                children: [
                  _swiper(context, productInfo),
                  SizedBox(height: Get.height * 0.05),
                  Text(
                    productInfo.postTitle.toString(),
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  if (productInfo.postExcerpt != null)
                    Text(
                      productInfo.postExcerpt.toString(),
                      style: postExcerptStyle,
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        leading: 0.05,
                      ),
                    ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  if (double.tryParse(productInfo.regularPrice!) != 0.00 &&
                      double.tryParse(productInfo.regularPrice!) !=
                          double.tryParse(productInfo.salePrice!))
                    Padding(
                      padding: EdgeInsets.only(bottom: Get.height * 0.01),
                      child: Text(
                        "\$ ${format.format(double.tryParse(productInfo.regularPrice!))}",
                        style: detaileRegularPriceStyle,
                      ),
                    ),
                  if (double.tryParse(productInfo.salePrice!) != 0.00)
                    Text(
                      "\$ ${format.format(double.tryParse(productInfo.salePrice!))}",
                      style: detailSalePriceStyle,
                    )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              constraints: BoxConstraints(maxHeight: 70.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              //color: Color.fromARGB(255, 247, 247, 247),
              width: Get.width,
              height: Get.height * 0.1,
              child: Row(
                children: [
                  GetBuilder<DashboardController>(
                    init: DashboardController(),
                    initState: (_) {},
                    builder: (dashboardController) {
                      return InkWell(
                        onTap: () {
                          dashboardController.changeIndex(3);
                          Get.offAndToNamed(Routes.DASHBOARD);
                        },
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 0.5,
                                            color: Colors.white54))),
                                width: Get.width * 0.3,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 35.0,
                                  color: Colors.red,
                                ),
                              ),
                              Positioned(
                                top: 3.0,
                                right: Get.width * 0.06,
                                child: GetBuilder<CartController>(
                                  init: CartController(),
                                  id: "cart",
                                  builder: (_) {
                                    return Container(
                                      alignment: Alignment.center,
                                      width: 22.0,
                                      height: 22.0,
                                      child: (_.cartCount != 0)
                                          ? CircleAvatar(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              child: Text(
                                                "${_.cartCount}",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )
                                          : Center(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  GetBuilder<CartController>(
                    builder: (_) {
                      return InkWell(
                        onTap: () {
                          _.addCart(productInfo);
                        },
                        child: Container(
                          color: Colors.grey[800],
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //         right: BorderSide(
                          //             width: 0.5, color: Colors.white54))),
                          alignment: Alignment.center,
                          width: Get.width * 0.7,
                          height: Get.height * 0.1,
                          child: Text(
                            "addCart".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // GetBuilder<CartController>(
                  //   init: CartController(),
                  //   initState: (_) {},
                  //   builder: (_) {
                  //     return InkWell(
                  //       onTap: () {
                  //         _.clearCart();
                  //       },
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         width: Get.width * 0.4,
                  //         height: Get.height * 0.1,
                  //         child: Text(
                  //           "立即購買",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 22.0,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _swiper(BuildContext context, data) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
                color: MyColors.borderColor,
                offset: Offset(0.0, 3.0),
                blurRadius: 1,
                spreadRadius: 0)
          ],
          gradient: swiperLinearGradient),
      height: 200.0,
      width: double.infinity,
      child: Swiper(
        autoplay: true,
        itemCount: data.imageArr.length,
        pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              space: 5.0,
              color: Colors.black54,
              activeColor: Color.fromARGB(255, 248, 112, 1),
              activeSize: 12.0),
        ),
        loop: true,
        autoplayDisableOnInteraction: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Align(
                child: ClipOval(
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    fadeOutDuration: Duration(milliseconds: 200),
                    placeholder: AssetImage("images/default.png"),
                    image: NetworkImage(
                      data.imageArr[index].toString(),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
