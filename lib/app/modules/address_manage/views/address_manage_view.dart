import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../untils/theme.dart';
import '../controllers/address_manage_controller.dart';
import 'address_add_or_edit_view.dart';

class AddressManageView extends GetView<AddressManageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'addressManage'.tr,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 99, 11, 5),
        elevation: 4.0,
        onPressed: () async {
          var ret = await Get.to(() => AddressAddOrEditView());
          if (ret == 'success') {
            controller.getAddresList();
          }
        },
        label: Text('addShippingAddress'.tr),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        padding:
            EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04),
        child: Container(
          width: Get.width,
          height: Get.height,
          child: GetBuilder<AddressManageController>(
            init: AddressManageController(),
            initState: (_) {},
            builder: (_) {
              if (_.isLoading) {
                return SkeletonListView();
              } else {
                final data = _.addressList;
                final addressLenth = data.length;
                return ListView.builder(
                  itemCount: _.addressList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 0),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Text(
                                data[index].name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 14.0),
                              Text(
                                data[index].phone ?? data[index].email,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          data[index].address,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.0),
                        ),
                        trailing: InkWell(
                          onTap: () async {
                            var ret = await Get.to(
                              () => AddressAddOrEditView(),
                              arguments: {
                                'addressItem': data[index],
                                'addressLenth': addressLenth
                              },
                            );
                            if (ret == 'success') {
                              controller.getAddresList();
                            }
                          },
                          child: Icon(
                            Icons.border_color,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
