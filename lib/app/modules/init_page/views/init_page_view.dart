import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../untils/theme.dart';
import '../controllers/init_page_controller.dart';

class InitPageView extends GetView<InitPageController> {
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(gradient: backgroundLinearGradient),
          // child: Center(
          //   child: Container(
          //     width: 150,
          //     height: 180,
          //     child: ListView.builder(
          //       itemCount: Config.company.length,
          //       itemBuilder: ((context, index) {
          //         return Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             InkWell(
          //               onTap: () {
          //                 box.remove("company");
          //                 box.write("company", Config.company[index]);
          //                 Get.toNamed(Routes.DASHBOARD);
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Container(
          //                       width: 32.0,
          //                       height: 32.0,
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         borderRadius: BorderRadius.circular(16.0),
          //                       ),
          //                       child: CircleAvatar(
          //                         backgroundColor: Colors.white,
          //                         backgroundImage: AssetImage(
          //                             // ignore: prefer_interpolation_to_compose_strings
          //                             "${"images/" + Config.company[index]["code"]}.png"),
          //                       ),
          //                     ),
          //                     Text(
          //                       "${Config.company[index]["name"]}",
          //                       style: TextStyle(
          //                         fontSize: 20.0,
          //                         fontWeight: FontWeight.bold,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //             Divider(
          //               color: Colors.white,
          //             ),
          //             SizedBox(
          //               height: 12.0,
          //             )
          //           ],
          //         );
          //       }),
          //     ),
          //   ),
          // ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 35),
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: Config.company
                            .asMap()
                            .map((key, value) {
                              return MapEntry(
                                  key,
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 20.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: (() {
                                        box.remove("company");
                                        box.write("company", value);
                                        Get.toNamed(Routes.DASHBOARD);
                                      }),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 170, minWidth: 120),
                                        width: Get.width * 0.5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 42,
                                              height: 42,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: AssetImage(
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    "images/${value['code']}.png"),
                                              ),
                                            ),
                                            Text(
                                              "${value['name']}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            })
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    child: Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Text(
                        'clickStorEnterSystem'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
