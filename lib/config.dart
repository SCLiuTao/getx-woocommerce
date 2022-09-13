class Config {
  //轮播
  static String banner = "https://www.pericles.net/woocommerce/banner.php";
  //類目
  static String category =
      "https://www.pericles.net/woocommerce/categories.php";
  //產品
  static String product = "https://www.pericles.net/woocommerce/product.php";
  //根据类目取产品
  static String catetoproduct =
      "https://www.pericles.net/woocommerce/catetoproduct.php";
  //用户注册
  static String register = "https://pericles.net/woocommerce/register.php";

  //用户登录
  static String login = "https://pericles.net/woocommerce/login.php";
  //用户修改
  static String edit = "https://pericles.net/woocommerce/edit.php";
  //获取用户所有地址
  static String addressAll = "https://pericles.net/woocommerce/getaddress.php";

  //地址添加与修改
  static String addressAddOrEdit =
      "https://pericles.net/woocommerce/addressaddoredit.php";

  //获取paypal支付配置
  static String getPaypalCofig =
      "https://pericles.net/woocommerce/paypal/config.php";

  //写入订单到数据库
  static String orderWriter = "https://pericles.net/woocommerce/orderwrite.php";

  //获取全部订单
  static String allOrder =
      "https://pericles.net/woocommerce/order/allOrder.php";
  //获取完成订单
  static String doneOrder =
      "https://pericles.net/woocommerce/order/completedOrder.php";
  //获取未付款订单
  static String unpaidOrder =
      "https://pericles.net/woocommerce/order/unpaidOrder.php";
  //多店铺
  static List company = [
    {"code": "kwong", "name": "光大"},
    {"code": "ecofood", "name": "天資"},
  ];
}
