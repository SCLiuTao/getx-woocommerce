import 'package:get/get.dart';

import '../controllers/all_product_controller.dart';

class AllProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllProductController>(
      () => AllProductController(),
    );
  }
}
