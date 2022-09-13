import 'package:get/get.dart';

import '../controllers/all_categroies_controller.dart';

class AllCategroiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCategroiesController>(
      () => AllCategroiesController(),
    );
  }
}
