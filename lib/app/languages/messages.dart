import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'languages': '语言',
          'home': '首页',
          'categroies': '类目',
          'member': '会员中心',
          "product": '商品',
          'cart': '购物车',
          'addCart': '加入购物车',
          'viewAll': '查看全部',
          'checkAll': '全选',
          'total': '合计',
          'checkOut': '结算(%s)',
          'login': '登录',
          'loginOut': '退出登录',
          'loginSuccess': '登录成功',
          'registration': '注册',
          'done': '完成',
          'userNameOrEmailOrPhone': '用户名或邮箱或手机号',
          'password': '密码',
          'thisFieldCannotEmpty': '此字段不能为空',
          'isHaveAccont': '没有账号?注册',
          'userName': '用户名',
          'email': '邮箱',
          'emailFormatError': '邮箱格式错误',
          'address': '地址',
          'registrationError': '注册失败',
          'registrationSuccess': '注册成功',
          'gender': '性别',
          'birthday': '生日',
          'woman': "女士",
          'mister': '先生',
          'systemMessage': '系统提示',
          'networkConnectError': '网络连接错误',
          'phone': '手机号',
          'loadingFromat': '%s...',
          'loading': '加载中',
          'saving': '保存中',
          'emailExits': '邮箱已存在',
          'loggingIn': '登录中',
          'accountOrpasswordError': '账号或密码错误',
          'myOrder': '我的订单',
          'addressManage': '地址管理',
          'customerPhone': '客服电话',
          'personalInformation': '个人资料',
          'signOut': '退出登录',
          'signOutSuccess': '退出登录成功',
          'save': '保存',
          'editSuccess': '修改成功',
          'editShippingAddress': '编辑收货地址',
          'addShippingAddress': '新增收货地址',
          'defaultAddress': '设为默认收货地址',
          'receiver': '收货人',
          'updateSuccess': '更新成功',
          "areYouSureDelete": "你确定删除吗?",
          "cancel": "取消",
          "confirm": "确定",
          "deleteSuccess": "删除成功",
          "deleteFailed": "删除失败",
          "confirmOrder": "确认订单",
          'noCheckedProdcut': '你还没有选择宝贝哦!',
          'pleaseSigin': '请先登录',
          'priceDetail': '价格明细',
          'deliveryService': '配送服务',
          'productTotalAmount': '商品总价',
          'totalPiece': '共%s件',
          'freeShipping': '免费配送',
          'deliveryAddress': '配送地址',
          'changeShippingAddress': '更改收货地址',
          'noShippingAddress': '还没有收货地址，现在去添加？',
          'submitOrder': '提交订单',
          'paymentMethod': '支付方式',
          'orderSubmitting': '订单提交中',
          'orderPay': '订单支付',
          'paySuccess': '支付成功',
          'continueToPay': '继续支付',
          'pleaseWait': '请稍等',
          'cancelPayment': '取消支付',
          'paymentError': '支付出错',
          'all': '全部',
          'completed': '已完成',
          'pendingPayment': '待付款',
          'orderDate': '订单日期: %s',
          'orderAmount': '订单金额: %s',
          'viewDetails': '查看详情',
          'orderTotalAmount': '订单金额',
          'Unpaid': '未付款',
          'orderDetails': '订单详情',
          'noRelatedOrders': '没有相关订单',
          'noMoreData': '没有更多数据',
          'loadingCompleted': '加载完成',
          'updateAt': '更新于 %T',
          'orderNo': '订单编号: ',
          'copy': '复制',
          'copySuccess': '复制成功',
          'NoLocationPermission': '没有定位权限',
          'openNow': '现在开启',
          'positioning': '定位中',
          'clickStorEnterSystem': '点击店铺进入系统'
        },
        'zh_HK': {
          'languages': '語言',
          'home': '首頁',
          'categroies': '類目',
          'member': '會員中心',
          "product": '商品',
          'cart': '購物車',
          'addCart': '加入購物車',
          'viewAll': '查看全部',
          'checkAll': '全選',
          'total': '合計',
          'checkOut': '結算(%s)',
          'login': '登錄',
          'loginSuccess': '登錄成功',
          'loginOut': '退出登錄',
          'registration': '註冊',
          'done': '完成',
          'userNameOrEmailOrPhone': '用戶名或郵件',
          'password': '密碼',
          'thisFieldCannotEmpty': '此字段不能為空',
          'isHaveAccont': '沒有賬號？ 註冊',
          'userName': '用戶名',
          'email': '郵箱',
          'emailFormatError': '郵箱格式錯誤',
          'address': '地址',
          'registrationError': '註冊失敗',
          'registrationSuccess': '註冊成功',
          'gender': '性別',
          'birthday': '生日',
          'woman': "女士",
          'mister': '先生',
          'systemMessage': '系統提示',
          'networkConnectError': '網絡連接錯誤',
          'phone': '手機號',
          'loadingFromat': '%s...',
          'loading': '加載中',
          'saving': '保存中',
          'emailExits': '郵箱已存在',
          'loggingIn': '登錄中',
          'accountOrpasswordError': '賬號或密碼錯誤',
          'myOrder': '我的訂單',
          'addressManage': '地址管理',
          'customerPhone': '客服電話',
          'personalInformation': '個人資料',
          'signOut': '退出登錄',
          'signOutSuccess': '退出登錄成功',
          'save': '保存',
          'editSuccess': '修改成功',
          'editShippingAddress': '编辑收貨地址',
          'addShippingAddress': '新增收貨地址',
          'defaultAddress': '設為默認收貨地址',
          'receiver': '收貨人',
          'updateSuccess': '更新成功',
          "areYouSureDelete": "你確定刪除嗎?",
          "cancel": "取消",
          "confirm": "確定",
          "deleteSuccess": "刪除成功",
          "deleteFailed": "删除失败",
          "confirmOrder": "確認訂單",
          'noCheckedProdcut': '你還沒有選擇寶貝哦!',
          'pleaseSigin': '请先登录',
          'priceDetail': '價格明細',
          'deliveryService': '配送服務',
          'productTotalAmount': '商品總價',
          'totalPiece': '共%s件',
          'freeShipping': '免費配送',
          'deliveryAddress': '配送地址',
          'changeShippingAddress': '更改收貨地址',
          'noShippingAddress': '還沒有收貨地址,現在去添加?',
          'submitOrder': '提交訂單',
          'paymentMethod': '支付方式',
          'orderSubmitting': '訂單提交中',
          'orderPay': '訂單支付',
          'paySuccess': '支付成功',
          'continueToPay': '繼續支付',
          'pleaseWait': '請稍等',
          'cancelPayment': '取消支付',
          'paymentError': '支付出錯',
          'all': '全部',
          'completed': '已完成',
          'pendingPayment': '待付款',
          'orderDate': '訂單日期: %s',
          'orderAmount': '訂單金額: %s',
          'viewDetails': '查看詳情',
          'orderTotalAmount': '訂單金額',
          'Unpaid': '未付款',
          'orderDetails': '訂單詳情',
          'noRelatedOrders': '沒有相關訂單',
          'noMoreData': '沒有更多數據',
          'loadingCompleted': '加載完成',
          'updateAt': '更新於 %T',
          'orderNo': '訂單編號: ',
          'copy': '複製',
          'copySuccess': '複製成功',
          'NoLocationPermission': '沒有定位權限',
          'openNow': '現在開啟',
          'positioning': '定位中',
          'clickStorEnterSystem': '點擊店鋪進入系統'
        },
        'en_us': {
          'languages': 'Languages',
          'home': 'Home',
          'categroies': 'Categories',
          'member': 'Member Center',
          "product": 'Products',
          'cart': 'Cart',
          'addCart': 'Add Cart',
          'viewAll': 'View All',
          'checkAll': 'Check All',
          'total': 'Total',
          'checkOut': 'Checkout(%s)',
          'login': 'Login',
          'loginSuccess': 'Login successful',
          'loginOut': 'Logout',
          'registration': 'Registration',
          'done': 'Done',
          'userNameOrEmailOrPhone': 'User name or email or phone',
          'password': 'Password',
          'thisFieldCannotEmpty': 'This field cann\'t be empty',
          'isHaveAccont': 'Don\'t have account? Sign up',
          'userName': 'Username',
          'email': 'Email',
          'emailFormatError': 'Email format error',
          'address': 'address',
          'registrationError': 'Registration failed',
          'registrationSuccess': 'Registration successful',
          'gender': 'Gender',
          'birthday': 'Birthday',
          'woman': "Ms.",
          'mister': 'Mr.',
          'systemMessage': 'System message',
          'networkConnectError': 'Network connection error',
          'phone': 'Phone',
          'loadingFromat': '%s...',
          'loading': 'loading',
          'saving': 'saving',
          'emailExits': 'Email exits',
          'loggingIn': 'Logging in',
          'accountOrpasswordError': 'Account or password error',
          'myOrder': 'My order',
          'addressManage': 'Address management',
          'customerPhone': 'Customer Phone',
          'personalInformation': 'Personal information',
          'signOut': 'Sign out',
          'signOutSuccess': 'Sign out success',
          'save': 'Save',
          'editSuccess': 'Edit success',
          'editShippingAddress': ' Edit shipping address',
          'addShippingAddress': 'Add shipping address',
          'defaultAddress': 'Set as default shipping address',
          'receiver': 'Receiver',
          'updateSuccess': 'Update success',
          "areYouSureDelete": "Are you sure you want to delete?",
          "cancel": "Cancel",
          "confirm": "Confirm",
          "deleteSuccess": "Delete success",
          "deleteFailed": "Delete failed",
          "confirmOrder": "Confirm the order",
          'noCheckedProdcut': 'You haven\'t chosen baby yet!',
          'pleaseSigin': 'Please log in first',
          'priceDetail': 'Price detail',
          'deliveryService': 'Delivery service',
          'productTotalAmount': 'Product total amount',
          'totalPiece': 'Total %s piece',
          'freeShipping': 'Free shipping',
          'deliveryAddress': 'Delivery address',
          'changeShippingAddress': 'Change shipping address',
          'noShippingAddress': 'No shipping address yet, add it now?',
          'submitOrder': 'Submit Order',
          'paymentMethod': 'Payment method',
          'orderSubmitting': 'Order submitting',
          'orderPay': 'Order pay',
          'paySuccess': 'Pay success',
          'continueToPay': 'Continue to pay',
          'pleaseWait': 'Please wait',
          'cancelPayment': 'Cancel payment',
          'paymentError': 'Payment error',
          'all': 'ALL',
          'completed': 'Completed',
          'pendingPayment': 'Pending payment',
          'orderDate': 'Order Date: %s',
          'orderAmount': 'Order Amount: %s',
          'viewDetails': 'View Details',
          'orderTotalAmount': 'Order amount',
          'Unpaid': 'Unpaid',
          'orderDetails': 'Order Details',
          'noRelatedOrders': 'No related orders',
          'noMoreData': 'No more data',
          'loadingCompleted': 'loading completed',
          'updateAt': 'Update at %T',
          'orderNo': 'Order No.: ',
          'copy': 'Copy',
          'copySuccess': 'Copy success',
          'NoLocationPermission': 'No Location Permission',
          'openNow': 'Open Now',
          'positioning': 'Positioning',
          'clickStorEnterSystem': 'Click On The Store To Enter The System'
        }
      };
}
