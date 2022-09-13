import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skeletons/skeletons.dart';
import 'package:woocommerce/app/modules/common/views/common_view.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/drawer_helper.dart';
import '../../../untils/theme.dart';
import '../../../untils/color.dart';
import '../../../untils/widget.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            box.read("company")['name'],
            style: headingStyle,
          ),
          actions: [
            moreStroe(),
          ],
        ),
        drawer: drawer(context),
        onDrawerChanged: (isOpen) {
          DrawerHelp.callDrawer(isOpen);
        },
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(gradient: backgroundLinearGradient),
              padding: EdgeInsets.only(
                  left: Get.width * 0.04, right: Get.width * 0.04),
              child: ListView(
                controller: controller.scrollController,
                children: [
                  //轮播
                  _swiper(context),
                  SizedBox(height: 8.0),
                  Divider(),
                  //类目
                  _categroy(context),
                  SizedBox(height: 5.0),
                  Divider(),
                  //产品
                  _product(context),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Obx(() => Visibility(
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
                )),
          ],
        ));
  }

  //轮播
  Widget _swiper(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingbanner.value) {
        return SizedBox(height: 150.0, child: SkeletonListView());
      }
      final data = controller.bannerList;
      final length = data.length;
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
        height: 150.0,
        width: double.infinity,
        child: Swiper(
          autoplay: true,
          itemCount: length,
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
          // control: SwiperControl(color: Color.fromARGB(255, 248, 112, 1)),
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                width: 150,
                height: 150,
                child: ClipOval(
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    fadeOutDuration: Duration(milliseconds: 200),
                    placeholder: AssetImage("images/default.png"),
                    image: NetworkImage(
                      data[index].guid.toString(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  //类目
  Widget _categroy(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "categroies".tr,
              style: headingStyle,
            ),
            Obx(() {
              if (controller.isLoadingCate.value) {
                return Container();
              }
              return GetBuilder<DashboardController>(
                init: DashboardController(),
                initState: (_) {},
                builder: (dashboardController) {
                  return TextButton(
                    onPressed: () {
                      dashboardController.changeIndex(1);
                      Get.toNamed(Routes.DASHBOARD);
                    },
                    child: Text(
                      "viewAll".tr,
                      style: bodyStyle,
                    ),
                  );
                },
              );
            })
          ],
        ),
        Obx(() {
          if (controller.isLoadingCate.value) {
            // return Center(
            //   child: CircularProgressIndicator(
            //     color: Colors.orange,
            //   ).reactive(),
            // );
            return SizedBox(height: 85.0, child: SkeletonListView());
          }
          final data = controller.categoryList;
          final length = data.length;

          return SizedBox(
            height: 80.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var i = 0; i < (length > 6 ? 6 : length); i++)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PRODUCT, arguments: {
                        "term_id": data[i].termID,
                        "name": data[i].name
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: MyColors.borderColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          width: 80.0,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              fadeOutDuration: Duration(milliseconds: 200),
                              placeholder: AssetImage("images/default.png"),
                              image: NetworkImage(data[i].imagePath.toString(),
                                  scale: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        })
      ],
    );
  }

  //产品
  Widget _product(BuildContext context) {
    final format = NumberFormat("#,##0.00", "en_US");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "product".tr,
              style: headingStyle,
            ),
            Obx(() {
              if (controller.isLoadingCate.value) {
                return Container();
              }
              return GetBuilder<DashboardController>(
                init: DashboardController(),
                initState: (_) {},
                builder: (dashboardController) {
                  return TextButton(
                    onPressed: () {
                      dashboardController.changeIndex(2);
                      Get.toNamed(
                        Routes.DASHBOARD,
                      );
                    },
                    child: Text(
                      "viewAll".tr,
                      style: bodyStyle,
                    ),
                  );
                },
              );
            })
          ],
        ),
        Obx(() {
          if (controller.isLoadingProduct.value) {
            // return Center(
            //   child: CircularProgressIndicator(
            //     color: Colors.orange,
            //   ).reactive(),
            // );
            return SizedBox(height: 800.0, child: SkeletonListView());
          }
          final data = controller.productList;
          final length = data.length;

          // return GridView(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.64,
          //     mainAxisSpacing: 5.0,
          //     crossAxisSpacing: 5.0,
          //   ),
          //   children: [
          //     for (var i = 0; i < (length > 6 ? 60 : length); i++)
          //       Container(
          //         padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border.all(
          //               width: 1.0, color: Color.fromARGB(255, 209, 207, 207)),
          //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //         ),
          //         child: Column(
          //           children: <Widget>[
          //             Container(
          //               width: double.infinity,
          //               child: FadeInImage(
          //                 height: 150.0,
          //                 fit: BoxFit.contain,
          //                 fadeOutDuration: Duration(milliseconds: 200),
          //                 placeholder: AssetImage("images/default.png"),
          //                 image: NetworkImage(data[i].guid.toString()),
          //               ),
          //             ),
          //             Text(
          //               data[i].postTitle.toString(),
          //             ),
          //             SizedBox(
          //               height: 3.0,
          //             ),
          //             if (double.tryParse(data[i].regularPrice!) != 0.00 &&
          //                 double.tryParse(data[i].regularPrice!) !=
          //                     double.tryParse(data[i].salePrice!))
          //               Text(
          //                 "\$" +
          //                     format.format(
          //                         double.tryParse(data[i].regularPrice!)),
          //                 style: regularPriceStyle,
          //               ),
          //             if (double.tryParse(data[i].salePrice!) != 0.00)
          //               Text(
          //                 "\$" +
          //                     format
          //                         .format(double.tryParse(data[i].salePrice!)),
          //                 style: salePriceStyle,
          //               ),
          //           ],
          //         ),

          //       ),
          //   ],
          // );
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.63,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 5.0,
            ),
            itemCount: length > 10 ? 10 : length,
            itemBuilder: (context, index) {
              return GridTile(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: MyColors.borderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: MyColors.borderColor,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 1,
                          spreadRadius: 0)
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PRODUCT_DETAIL,
                          arguments: data[index]);
                    },
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxHeight: 150.0),
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: FadeInImage(
                              fit: BoxFit.fill,
                              fadeOutDuration: Duration(milliseconds: 200),
                              placeholder: AssetImage("images/default.png"),
                              image: NetworkImage(data[index].guid.toString(),
                                  scale: 2.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            data[index].postTitle.toString(),
                            style: shopTitleStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        if (double.tryParse(data[index].regularPrice!) !=
                                0.00 &&
                            double.tryParse(data[index].regularPrice!) !=
                                double.tryParse(data[index].salePrice!))
                          Text(
                            "\$${format.format(double.tryParse(data[index].regularPrice!))}",
                            style: regularPriceStyle,
                          ),
                        if (double.tryParse(data[index].salePrice!) != 0.00)
                          Text(
                            "\$${format.format(double.tryParse(data[index].salePrice!))}",
                            style: salePriceStyle,
                          ),
                      ],
                    ),
                  ),
                ),
                footer: GetBuilder<CartController>(
                  init: CartController(),
                  builder: (_) {
                    // GlobalKey key = GlobalKey();
                    // return Padding(
                    //   padding:
                    //       EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0),
                    //   child: ElevatedButton(
                    //       key: key,
                    //       onPressed: () {
                    //         final RenderBox box = key.currentContext!
                    //             .findRenderObject() as RenderBox;
                    //         var ItemOffset = box.localToGlobal(Offset.zero);

                    //         debugPrint("====>$ItemOffset");
                    //         debugPrint(
                    //             "====>${ItemOffset.dy.toStringAsFixed(2)}");
                    //         //_.addCart(data[index]);
                    //       },
                    //       child: Text(
                    //         "addCart".tr,
                    //         style: bodyStyle,
                    //       )),
                    // );
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0),
                      child: Builder(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: () {
                              final dashboardController =
                                  Get.put(DashboardController());
                              // 点击的时候获取当前 widget 的位置，传入overlayEntry蒙层
                              OverlayEntry? overlayEntry =
                                  OverlayEntry(builder: (_) {
                                RenderBox? box =
                                    context.findRenderObject() as RenderBox?;
                                var startOffset =
                                    box!.localToGlobal(Offset.zero);
                                return CommonView(
                                    startPosition: startOffset,
                                    endPosition: dashboardController.endOffset);
                              });
                              // 显示Overlay
                              Overlay.of(context)!.insert(overlayEntry);
                              // 等待动画结束
                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                overlayEntry!.remove();
                                overlayEntry = null;
                                _.addCart(data[index]);
                              });
                            },
                            child: Text(
                              "addCart".tr,
                              style: bodyStyle,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        })
      ],
    );
  }
}
