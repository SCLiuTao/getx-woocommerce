import 'package:get/get.dart';

import 'package:woocommerce/app/modules/address_manage/controllers/address_add_or_edit_controller.dart';

import '../controllers/address_manage_controller.dart';

class AddressManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressAddOrEditController>(
      () => AddressAddOrEditController(),
    );
    Get.lazyPut<AddressManageController>(
      () => AddressManageController(),
    );
  }
}
