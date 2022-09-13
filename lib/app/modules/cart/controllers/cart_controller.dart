import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/product/product_modle.dart';

class CartController extends GetxController {
  GetStorage box = GetStorage();
  List cartList = []; //选中商品list
  int cartCount = 0; //总商品数量
  int cartCheckedCount = 0; //选中商品总数量
  double totalAmount = 0; //选中商品总数量
  bool isAllCheck = true; //单个item 复选按钮改变状态时判断全选按钮状态

  @override
  void onInit() {
    getCartinfo();
    super.onInit();
  }

  @override
  void onClose() {}

  //添加购物车商品
  addCart(ProductModle productInfo) {
    Map<String, dynamic> company = box.read("company");
    List templist = box.read("cartInfo") ?? [];
    bool isHave = false;
    int index = 0;
    for (var item in templist) {
      if (item['goodsID'] == productInfo.id &&
          item['company'] == company['code']) {
        templist[index]['count'] = item['count'] + 1;
        isHave = true;
      }
      index++;
    }

    if (!isHave) {
      templist.add({
        "goodsID": productInfo.id,
        "goodsName": productInfo.postTitle,
        'count': 1,
        "salePrice": productInfo.salePrice,
        "regularPrice": productInfo.regularPrice,
        "image": productInfo.guid,
        "company": company['code'],
        "isCheck": true
      });
    }

    box.write("cartInfo", templist);
    getCartinfo();
    update(["cart"]);
  }

  //清空购物车
  clearCart() {
    box.remove("cartInfo");
    cartList = [];
    getCartinfo();
    update(['cart']);
  }

  //获取购物车信息
  getCartinfo() {
    List tempList = box.read("cartInfo") ?? [];
    cartList = tempList;
    if (tempList.isNotEmpty) {
      cartCount = 0;
      totalAmount = 0;
      cartCheckedCount = 0;
      isAllCheck = true;
      for (var item in tempList) {
        cartCount += (item['count'] as int);
        if (item["isCheck"]) {
          totalAmount = NumUtil.add(
              (item["count"] as int) * double.parse(item['salePrice']),
              totalAmount);

          cartCheckedCount += (item['count'] as int);
        } else {
          isAllCheck = false;
        }
      }
    } else {
      cartCount = 0;
    }
  }

  //删除购物车单位商品
  deleteOneGoods(Map<String, dynamic> delItem) {
    List<dynamic> tempList = box.read("cartInfo") ?? [];
    int tempIndex = 0;
    int delIndex = 0;
    for (var item in tempList) {
      if (item['goodsID'] == delItem["goodsID"] &&
          item['company'] == delItem["company"]) {
        delIndex = tempIndex;
      }
      tempIndex++;
    }
    tempList.removeAt(delIndex);
    box.write("cartInfo", tempList);
    getCartinfo();
    update(['cart']);
  }

  //单个按钮选中与取消
  changcheckState(Map<String, dynamic> changItem) {
    List<dynamic> tempList = box.read("cartInfo") ?? [];
    int tempIndex = 0;
    int checkIndex = 0;
    for (var item in tempList) {
      if (item['goodsID'] == changItem["goodsID"] &&
          item['company'] == changItem["company"]) {
        checkIndex = tempIndex;
      }
      tempIndex++;
    }
    tempList[checkIndex] = changItem;
    box.write("cartInfo", tempList);
    getCartinfo();
    update(['cart']);
  }

  //点击全选按钮操作
  changAllCheck(bool isCheck) {
    List<dynamic> tempList = box.read("cartInfo") ?? [];
    List<dynamic> newList = [];
    for (var item in tempList) {
      var newItem = item;
      newItem["isCheck"] = isCheck;
      newList.add(newItem);
    }
    box.write("cartInfo", newList);
    getCartinfo();
    update(['cart']);
  }

  //商品数量加减操作
  addofReduceAction(Map<String, dynamic> changItem, bool isAdd) {
    List<dynamic> tempList = box.read("cartInfo") ?? [];
    int tempIndex = 0;
    int changIndex = 0;
    for (var item in tempList) {
      if (item['goodsID'] == changItem["goodsID"] &&
          item['company'] == changItem["company"]) {
        changIndex = tempIndex;
      }
      tempIndex++;
    }
    if (isAdd) {
      changItem['count']++;
    } else if (changItem['count'] > 1) {
      changItem['count']--;
    }
    tempList[changIndex] = changItem;
    box.write("cartInfo", tempList);
    getCartinfo();
    update(['cart']);
  }

  //供支付控制器使用
  refreshCart() {
    getCartinfo();
    update(['cart']);
  }
}
