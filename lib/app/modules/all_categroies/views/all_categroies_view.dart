import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:woocommerce/app/untils/drawer_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/theme.dart';
import '../../../untils/widget.dart';
import '../controllers/all_categroies_controller.dart';

class AllCategroiesView extends GetView<AllCategroiesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'categroies'.tr,
          style: headingStyle,
        ),
        actions: [
          moreStroe(),
        ],
      ),
      drawer: drawer(context),
      onDrawerChanged: (isOpen) {
        DrawerHelp.callDrawer(isOpen);
      },
      body: Obx(() {
        if (controller.isLoadingCate.value) {
          return Container(
            height: Get.height,
            child: SkeletonListView(),
          );
        } else {
          final categoriesData = controller.categoryList;
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: backgroundLinearGradient),
            padding: EdgeInsets.only(
                left: Get.width * 0.04, right: Get.width * 0.04),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: categoriesData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.PRODUCT, arguments: {
                      "term_id": categoriesData[index].termID,
                      "name": categoriesData[index].name
                    });
                  },
                  child: GridTile(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: 80.0,
                              maxHeight: 80.0,
                              minWidth: 80.0,
                              minHeight: 80.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1.0,
                                color: Color.fromARGB(255, 209, 207, 207)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              fadeOutDuration: Duration(milliseconds: 200),
                              placeholder: AssetImage("images/default.png"),
                              image: NetworkImage(
                                categoriesData[index].imagePath.toString(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          categoriesData[index].name.toString(),
                          style: bodyStyle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
