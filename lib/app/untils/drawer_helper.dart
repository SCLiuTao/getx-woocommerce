import 'package:get/get.dart';

import '../modules/dashboard/controllers/dashboard_controller.dart';

class DrawerHelp {
  static callDrawer(bool isOpen) {
    final controller = Get.put(DashboardController());
    controller.isDrawerOpen.value = isOpen;
  }
}
