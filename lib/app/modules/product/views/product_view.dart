import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

import '../../../routes/app_pages.dart';
import '../../../untils/color.dart';
import '../../../untils/theme.dart';
import '../../../untils/widget.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../common/views/common_view.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  final GlobalKey categroiesCartKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final format = NumberFormat("#,##0.00", "en_US");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox? box =
          categroiesCartKey.currentContext!.findRenderObject() as RenderBox?;
      DashboardController dashboardController = Get.put(DashboardController()
      
      
      );
      dashboardController.endOffset = box!.localToGlobal(Offset.zero);
    });
    return Scaffold(
      appBar: AppBar(
        actions: [appActionsCart(cartkey: categroiesCartKey)],
        title: Text(
          Get.arguments['name'],
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        child: Obx(() {
          if (controller.isLoadingProduct.value) {
            return SizedBox(
                height: Get.height,
                width: Get.width,
                child: SafeArea(child: SkeletonListView()));
          }

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: Get.width * 0.04, right: Get.width * 0.04),
                child: GetBuilder<ProductController>(
                  builder: (productController) {
                    return GridView.builder(
                      controller: productController.scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.63,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: productController.productList.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1.0,
                                  color: Color.fromARGB(255, 209, 207, 207)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: MyColors.borderColor,
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 1,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.PRODUCT_DETAIL,
                                    arguments:
                                        productController.productList[index]);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints(maxHeight: 150.0),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: FadeInImage(
                                        fit: BoxFit.fill,
                                        fadeOutDuration:
                                            Duration(milliseconds: 200),
                                        placeholder:
                                            AssetImage("images/default.png"),
                                        image: NetworkImage(productController
                                            .productList[index].guid
                                            .toString()),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Text(
                                      productController
                                          .productList[index].postTitle
                                          .toString(),
                                      style: shopTitleStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  if (double.tryParse(productController
                                              .productList[index]
                                              .regularPrice!) !=
                                          0.00 &&
                                      double.tryParse(productController
                                              .productList[index]
                                              .regularPrice!) !=
                                          double.tryParse(productController
                                              .productList[index].salePrice!))
                                    Text(
                                      "\$${format.format(double.tryParse(productController.productList[index].regularPrice!))}",
                                      style: regularPriceStyle,
                                    ),
                                  if (double.tryParse(productController
                                          .productList[index].salePrice!) !=
                                      0.00)
                                    Text(
                                      "\$${format.format(double.tryParse(productController.productList[index].salePrice!))}",
                                      style: salePriceStyle,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          footer: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 3.0),
                            child: GetBuilder<CartController>(
                              init: CartController(),
                              initState: (_) {},
                              builder: (_) {
                                return Builder(builder: (context) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        final dashboardController =
                                            Get.put(DashboardController());
                                        // 点击的时候获取当前 widget 的位置，传入overlayEntry蒙层
                                        OverlayEntry? overlayEntry =
                                            OverlayEntry(builder: (_) {
                                          RenderBox? box = context
                                              .findRenderObject() as RenderBox?;
                                          var startOffset =
                                              box!.localToGlobal(Offset.zero);
                                          return CommonView(
                                              startPosition: startOffset,
                                              endPosition: dashboardController
                                                  .endOffset);
                                        });
                                        // 显示Overlay
                                        Overlay.of(context)!
                                            .insert(overlayEntry);
                                        // 等待动画结束
                                        Future.delayed(
                                            const Duration(milliseconds: 800),
                                            () {
                                          overlayEntry!.remove();
                                          overlayEntry = null;
                                          _.addCart(productController
                                              .productList[index]);
                                        });
                                      },
                                      child: Text(
                                        "addCart".tr,
                                        style: bodyStyle,
                                      ));
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.showToTopBtn.value,
                  child: Positioned(
                    right: 10,
                    bottom: 20,
                    child: InkWell(
                      onTap: () {
                        controller.scrollController.animateTo(
                          .0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.grey[900],
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.arrow_upward,
                            size: 30,
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
