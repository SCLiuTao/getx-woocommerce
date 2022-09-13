// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/address/address_modle.dart';

import '../../../../config.dart';
import '../../../untils/theme.dart';

class AddressManageController extends GetxController {
  List addressList = <AddressListData>[];
  bool isLoading = true;
  @override
  void onInit() {
    getAddresList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  changStatus(bool newval) {
    isLoading = newval;
    update();
  }

  getAddresList() async {
    changStatus(true);
    try {
      Dio dio = Dio();
      GetStorage box = GetStorage();
      Map<String, dynamic> userInfo = jsonDecode(box.read("userInfo"));
      var response = await dio.post(
        Config.addressAll,
        data: {"userID": userInfo["userID"]},
        options: Options(
          sendTimeout: 10,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.statusCode == 200) {
        AddressModel addList = AddressModel.fromJson(jsonDecode(response.data));
        addressList = addList.data!;
        changStatus(false);
      }
    } on DioError {
      changStatus(false);
      errorSnackbar("networkConnectError".tr);
    }
  }
}
