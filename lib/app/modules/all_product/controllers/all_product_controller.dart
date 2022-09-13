import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/product/product_data.dart';
import '../../../data/product/product_modle.dart';

class AllProductController extends GetxController {
  var productList = <ProductModle>[].obs;
  var isLoadingProduct = true.obs;
  late ScrollController scrollController;
  RxBool showToTopBtn = false.obs;

  @override
  void onInit() {
    callProduct();
    scrollController = ScrollController();
    scrollController.addListener(
      () {
        if (scrollController.positions.last.pixels < 200 &&
            showToTopBtn.value) {
          showToTopBtn(false);
        } else if (scrollController.positions.last.pixels >= 200 &&
            showToTopBtn.value == false) {
          showToTopBtn(true);
        }
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  void callProduct() async {
    isLoadingProduct(true);
    try {
      var list = await ProductData.getProduct();

      if (list != null) {
        productList.assignAll(list);
      }
    } finally {
      isLoadingProduct(false);
    }
  }
}
