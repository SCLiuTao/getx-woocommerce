import 'package:get/get.dart';

import '../../../data/category/category_data.dart';
import '../../../data/category/category_modle.dart';

class AllCategroiesController extends GetxController {
 var categoryList = <CategoryModle>[].obs;
 var isLoadingCate = true.obs;
  @override
  void onInit() {
    callCategory();
    super.onInit();
  }
  @override
  void onClose() {}
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

}

