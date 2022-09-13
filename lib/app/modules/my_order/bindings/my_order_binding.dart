import 'package:get/get.dart';
import '../controllers/all_order_controller.dart';
import '../controllers/done_order_controller.dart';
import '../controllers/my_order_controller.dart';
import '../controllers/unpay_order_controller.dart';

class MyOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoneOrderController>(
      () => DoneOrderController(),
    );
    Get.lazyPut<AllOrderController>(
      () => AllOrderController(),
    );
    Get.lazyPut<UnpayOrderController>(
      () => UnpayOrderController(),
    );
    Get.lazyPut<MyOrderController>(
      () => MyOrderController(),
    );
  }
}
