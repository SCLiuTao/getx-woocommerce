import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woocommerce/app/data/banner/banner_data.dart';
import 'package:woocommerce/app/data/banner/banner_modle.dart';
import 'package:woocommerce/app/data/category/category_data.dart';
import 'package:woocommerce/app/data/category/category_modle.dart';
import 'package:woocommerce/app/data/product/product_data.dart';
import 'package:woocommerce/app/data/product/product_modle.dart';

class HomeController extends GetxController {
  var bannerList = <BannerModle>[].obs;
  var categoryList = <CategoryModle>[].obs;
  var productList = <ProductModle>[].obs;
  var isLoadingCate = true.obs;
  var isLoadingProduct = true.obs;
  var isLoadingbanner = true.obs;
  late ScrollController scrollController;
  RxBool showToTopBtn = false.obs;
  @override
  void onInit() {
    print("begin......");
    callBanner();
    callCategory();
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

  void callCategory() async {
    isLoadingCate(true);
    try {
      var list = await CategroyData.getCategroy();
      if (list != null) {
        categoryList.assignAll(list);
      }
    } finally {
      isLoadingCate(false);
    }
  }

  void callBanner() async {
    isLoadingbanner(true);
    try {
      var list = await BannerData.getBanner();
      if (list != null) {
        bannerList.assignAll(list);
      }
    } finally {
      isLoadingbanner(false);
    }
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
