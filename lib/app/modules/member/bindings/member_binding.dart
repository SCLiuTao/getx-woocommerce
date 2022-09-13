import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/member_controller.dart';

class MemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );

    Get.lazyPut<MemberController>(
      () => MemberController(),
    );
  }
}
