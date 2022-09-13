import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../untils/form_helper.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController userName = TextEditingController();
    final TextEditingController password = TextEditingController();
    final controller = Get.put(LoginController());
    GetStorage box = GetStorage();
    Map<String, dynamic> registerInfo = box.read('registerInfo') ?? {};
    if (registerInfo.isNotEmpty) {
      userName.text = registerInfo['email'];
    }

    return SafeArea(
      child: Container(
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              //用戶名
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: FormHelper.textInput(
                  context,
                  "userNameOrEmailOrPhone".tr,
                  userName,
                  TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'thisFieldCannotEmpty'.tr;
                    }
                    return null;
                  },
                ),
              ),
              //密碼
              GetBuilder<LoginController>(
                id: "showTextType",
                init: LoginController(),
                builder: (_) {
                  final isShowPassWord = _.isShowPass;
                  return Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: FormHelper.textInput(context, "password".tr,
                        password, TextInputType.visiblePassword,
                        isPasswordType: isShowPassWord,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isShowPassWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white.withOpacity(0.8),
                            size: 20.0,
                          ),
                          onPressed: () {
                            _.showTextType(!isShowPassWord);
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
              //登錄按鈕
              GetBuilder<LoginController>(
                init: LoginController(),
                initState: (_) {},
                id: "login",
                builder: (_) {
                  final isLogin = _.isLoadingLogin;
                  return Container(
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
                        onPressed: () async {
                          if (isLogin == false) {
                            var loginForm = formkey.currentState;
                            if (loginForm!.validate()) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              box.remove('registerInfo');
                              controller.doLogin({
                                "userName": userName.text,
                                "password": password.text
                              });
                              _.loadingLogin(!isLogin);
                            }
                          } else {}
                        },
                        child: isLogin == false
                            ? Text(
                                'login'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25.0,
                                      height: 25.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25.0,
                                    ),
                                    Text(
                                      'login'.tr,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              //没有账号注册
              InkWell(
                onTap: () => Get.toNamed(Routes.REGISTRATION),
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: Text(
                    "isHaveAccont".tr,
                    style: TextStyle(color: Colors.white54, fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
