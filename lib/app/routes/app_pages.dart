import 'package:get/get.dart';

import '../modules/address_manage/bindings/address_manage_binding.dart';
import '../modules/address_manage/views/address_manage_view.dart';
import '../modules/all_categroies/bindings/all_categroies_binding.dart';
import '../modules/all_categroies/views/all_categroies_view.dart';
import '../modules/all_product/bindings/all_product_binding.dart';
import '../modules/all_product/views/all_product_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/common/bindings/common_binding.dart';
import '../modules/common/views/common_view.dart';
import '../modules/confirm_order/bindings/confirm_order_binding.dart';
import '../modules/confirm_order/views/confirm_order_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/init_page/bindings/init_page_binding.dart';
import '../modules/init_page/views/init_page_view.dart';
import '../modules/member/bindings/member_binding.dart';
import '../modules/member/views/member_view.dart';
import '../modules/my_order/bindings/my_order_binding.dart';
import '../modules/my_order/views/my_order_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.INIT_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ALL_CATEGROIES,
      page: () => AllCategroiesView(),
      binding: AllCategroiesBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRODUCT,
      page: () => AllProductView(),
      binding: AllProductBinding(),
    ),
    GetPage(
      name: _Paths.INIT_PAGE,
      page: () => InitPageView(),
      binding: InitPageBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.MEMBER,
      page: () => MemberView(),
      binding: MemberBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_MANAGE,
      page: () => AddressManageView(),
      binding: AddressManageBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_ORDER,
      page: () => ConfirmOrderView(),
      binding: ConfirmOrderBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDER,
      page: () => MyOrderView(),
      binding: MyOrderBinding(),
    ),
    GetPage(
      name: _Paths.COMMON,
      page: () => const CommonView(),
      binding: CommonBinding(),
    ),
  ];
}
