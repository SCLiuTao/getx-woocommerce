import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/address/address_modle.dart';
import '../../../untils/form_helper.dart';
import '../../../untils/theme.dart';
import '../controllers/address_add_or_edit_controller.dart';

class AddressAddOrEditView extends GetView {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressAddOrEditController());

    AddressListData? addressData =
        Get.arguments != null ? Get.arguments['addressItem'] : null;
    final int addressLenth =
        Get.arguments != null ? Get.arguments['addressLenth'] : 0;

    if (addressData != null) {
      controller.userNameController.text = addressData.name!;
      controller.phoneController.text = addressData.phone!;
      controller.emailController.text = addressData.email!;
      controller.addressController.text = addressData.address!;
      controller.changeSwitch(addressData.defaultAddres == "1" ? true : false);
    }
    return Scaffold(
      appBar: AppBar(
        title: addressData != null
            ? Text(
                'editShippingAddress'.tr,
                style: headingStyle,
              )
            : Text('addShippingAddress'.tr, style: headingStyle),
        centerTitle: true,
        actions: [
          addressLenth > 1
              ? IconButton(
                  onPressed: () {
                    final result = showOkCancelAlertDialog(
                      barrierDismissible: false,
                      context: context,
                      title: 'systemMessage'.tr,
                      message: 'areYouSureDelete'.tr,
                      okLabel: 'confirm'.tr,
                      cancelLabel: 'cancel'.tr,
                      onWillPop: () => Future.value(false),
                      isDestructiveAction: true,
                      builder: (context, child) => Theme(
                        data: ThemeData(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(primary: Colors.green),
                          ),
                        ),
                        child: child,
                      ),
                    );
                    result.then((value) {
                      if (value == OkCancelResult.ok) {
                        Map<String, dynamic> ret = addressData!.toJson();
                        ret.addAll({"delete": true});
                        controller.doSubmit(ret);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 28.0,
                  ))
              : Container()
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        padding:
            EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04),
        child: Form(
          key: controller.formkey,
          child: ListView(
            children: [
              //收货人
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: FormHelper.textInput(
                  context,
                  "receiver".tr,
                  controller.userNameController,
                  TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'thisFieldCannotEmpty'.tr;
                    }
                    return null;
                  },
                ),
              ),

              //邮箱
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: FormHelper.textInput(
                  context,
                  "email".tr,
                  controller.emailController,
                  TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'thisFieldCannotEmpty'.tr;
                    }
                    var emailReg = RegExp(
                        r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
                    if (!emailReg.hasMatch(value)) {
                      return 'emailFormatError'.tr;
                    }
                    return null;
                  },
                ),
              ),

              //手机
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: FormHelper.textInput(
                  context,
                  "phone".tr,
                  controller.phoneController,
                  TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'thisFieldCannotEmpty'.tr;
                    }
                    return null;
                  },
                ),
              ),

              //地址
              GetBuilder<AddressAddOrEditController>(
                init: AddressAddOrEditController(),
                initState: (_) {},
                id: "aMapAddress",
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: FormHelper.textInput(
                      context,
                      'address'.tr,
                      controller.addressController,
                      TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'thisFieldCannotEmpty'.tr;
                        }
                        return null;
                      },
                      maxLines: null,
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.amapLocation(context);
                        },
                        icon: Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              //设置为默认地址
              GetBuilder<AddressAddOrEditController>(
                init: AddressAddOrEditController(),
                id: 'defaultSwitch',
                initState: (_) {},
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(top: 5.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: Colors.white.withOpacity(0.6)))),
                    child: Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        inactiveThumbColor: Colors.grey[600],
                        activeColor: Colors.white,
                        activeTrackColor: Colors.white,
                        title: Text(
                          'defaultAddress'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                        value: _.switchValue,
                        onChanged: ((value) {
                          _.changeSwitch(value);
                        }),
                      ),
                    ),
                  );
                },
              ),

              //按鈕
              Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 45.0,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2.0),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(153, 83, 43, 156)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      var loginForm = controller.formkey.currentState;
                      if (loginForm!.validate()) {
                        FocusNode focusNode = FocusNode();
                        focusNode.addListener(() {
                          if (!focusNode.hasFocus) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        });

                        if (addressData == null) {
                          GetStorage box = GetStorage();

                          Map<String, dynamic> editMap = {
                            "userID":
                                jsonDecode(box.read("userInfo"))['userID'],
                            "address": controller.addressController.text,
                            "defaultAddres": controller.switchValue ? "1" : "0",
                            "name": controller.userNameController.text,
                            "email": controller.emailController.text,
                            "phone": controller.phoneController.text
                          };
                          controller.doSubmit(editMap);
                        } else {
                          Map<String, dynamic> editMap = {
                            "userID": addressData.userId,
                            "addressID": addressData.addressId,
                            "address": controller.addressController.text,
                            "defaultAddres": controller.switchValue ? "1" : "0",
                            "name": controller.userNameController.text,
                            "email": controller.emailController.text,
                            "phone": controller.phoneController.text
                          };

                          controller.doSubmit(editMap);
                        }
                      }
                    },
                    child: Text(
                      'save'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
