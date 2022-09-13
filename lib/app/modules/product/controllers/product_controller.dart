import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/product/product_data.dart';
import '../../../data/product/product_modle.dart';

class ProductController extends GetxController {
  var isLoadingProduct = true.obs;
  var productList = <ProductModle>[].obs;
  late ScrollController scrollController;
  RxBool showToTopBtn = false.obs;
  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController.addListener(
      () {
        if (scrollController.positions.last.pixels < 200 &&
            showToTopBtn.value) {
          showToTopBtn(false);
        } else if (scrollController.offset >= 200 &&
            showToTopBtn.value == false) {
          showToTopBtn(true);
        }
      },
    );
    callProduct();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  void callProduct() async {
    isLoadingProduct(true);
    try {
      var list = await ProductData.getCateToProduct(Get.arguments);

      if (list != null) {
        productList.assignAll(list);
      }
    } finally {
      isLoadingProduct(false);
    }
  }
}
