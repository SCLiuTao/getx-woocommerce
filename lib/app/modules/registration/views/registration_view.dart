import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reister_modle.dart';
import '../../../untils/form_helper.dart';
import '../../../untils/theme.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //当前用户登录信息
    final currentUserInfoJson = Get.arguments;
    if (currentUserInfoJson != null) {
      Map currentUserInfoMap = jsonDecode(currentUserInfoJson);
      _userNameController.text = currentUserInfoMap['name'];
      _emailController.text = currentUserInfoMap['email'];
      _phoneController.text = currentUserInfoMap['phone'];
      _birthdayController.text = currentUserInfoMap['birthday'];
      _passwordController.text = currentUserInfoMap['password'];
      controller.radioGroupValue = int.parse(currentUserInfoMap['gender']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUserInfoJson == null
              ? 'registration'.tr
              : 'personalInformation'.tr,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: backgroundLinearGradient),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                //用戶名
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: FormHelper.textInput(
                    context,
                    "userName".tr,
                    _userNameController,
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
                    _emailController,
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
                    enabled: currentUserInfoJson == null ? true : false,
                  ),
                ),

                //密碼
                GetBuilder<RegistrationController>(
                  init: RegistrationController(),
                  initState: (_) {},
                  id: "password",
                  builder: (_) {
                    final isShowpassword = controller.isShowPassword;
                    return Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: FormHelper.textInput(context, "password".tr,
                          _passwordController, TextInputType.visiblePassword,
                          isPasswordType: isShowpassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isShowpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white.withOpacity(0.8),
                              size: 20.0,
                            ),
                            onPressed: () {
                              _.showTextType(!isShowpassword);
                            },
                          ), validator: (value) {
                        if (value!.isEmpty) {
                          return 'thisFieldCannotEmpty'.tr;
                        }
                        return null;
                      }),
                    );
                  },
                ),

                //手机
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: FormHelper.textInput(
                    context,
                    "phone".tr,
                    _phoneController,
                    TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'thisFieldCannotEmpty'.tr;
                      }
                      return null;
                    },
                  ),
                ),

                //性别
                GetBuilder<RegistrationController>(
                  id: "radioGroupValue",
                  init: RegistrationController(),
                  initState: (_) {},
                  builder: (_) {
                    return Container(
                      margin: EdgeInsets.only(top: 5.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.white.withOpacity(0.5)))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: Get.width * 0.2,
                            child: Text(
                              'gender'.tr,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                          Container(
                            width: Get.width * 0.72,
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Colors.white,
                                      title:
                                          Text('mister'.tr, style: bodyStyle),
                                      value: 0,
                                      groupValue: controller.radioGroupValue,
                                      onChanged: (value) {
                                        _.changRadioGroupValue(
                                            int.parse(value.toString()));
                                      },
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  child: Container(
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Colors.white,
                                      title: Text('woman'.tr, style: bodyStyle),
                                      value: 1,
                                      groupValue: controller.radioGroupValue,
                                      onChanged: (value) {
                                        _.changRadioGroupValue(
                                            int.parse(value.toString()));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

                //生日
                FormHelper.cuptinoDateInput(
                    context, "birthday".tr, _birthdayController),
                //地址
                currentUserInfoJson == null
                    ? Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: FormHelper.textInput(
                            context,
                            'address'.tr,
                            _addressController,
                            TextInputType.multiline, validator: (value) {
                          if (value!.isEmpty) {
                            return 'thisFieldCannotEmpty'.tr;
                          }
                          return null;
                        }, maxLines: null),
                      )
                    : Container(),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        var loginForm = _formkey.currentState;
                        if (loginForm!.validate()) {
                          FocusNode focusNode = FocusNode();
                          focusNode.addListener(() {
                            if (!focusNode.hasFocus) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          });

                          if (currentUserInfoJson == null) {
                            RegisterModle modle = RegisterModle(
                                name: _userNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                gender: controller.radioGroupValue,
                                birthday: _birthdayController.text,
                                phone: _phoneController.text,
                                address: _addressController.text);
                            controller.doRegister(modle);
                          } else {
                            Map currentUserInfoMap =
                                jsonDecode(currentUserInfoJson);
                            Map<String, dynamic> editMap = {
                              "userID": currentUserInfoMap['userID'],
                              "name": _userNameController.text,
                              "email": _emailController.text,
                              "password": _passwordController.text,
                              "gender": controller.radioGroupValue,
                              "birthday": _birthdayController.text,
                              "phone": _phoneController.text,
                            };
                            controller.doEdit(editMap);
                          }
                        }
                      },
                      child: Text(
                        currentUserInfoJson == null
                            ? 'registration'.tr
                            : 'save'.tr,
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
      ),
    );
  }
}
