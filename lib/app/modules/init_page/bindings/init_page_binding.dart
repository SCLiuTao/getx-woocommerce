import 'package:get/get.dart';

import '../controllers/init_page_controller.dart';

class InitPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitPageController>(
      () => InitPageController(),
    );
  }
}
