// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ALL_CATEGROIES = _Paths.ALL_CATEGROIES;
  static const PRODUCT = _Paths.PRODUCT;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const ALL_PRODUCT = _Paths.ALL_PRODUCT;
  static const INIT_PAGE = _Paths.INIT_PAGE;
  static const CART = _Paths.CART;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const MEMBER = _Paths.MEMBER;
  static const REGISTRATION = _Paths.REGISTRATION;
  static const ADDRESS_MANAGE = _Paths.ADDRESS_MANAGE;
  static const CONFIRM_ORDER = _Paths.CONFIRM_ORDER;
  static const MY_ORDER = _Paths.MY_ORDER;
  static const COMMON = _Paths.COMMON;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const ALL_CATEGROIES = '/all-categroies';
  static const PRODUCT = '/product';
  static const PRODUCT_DETAIL = '/product-detail';
  static const ALL_PRODUCT = '/all-product';
  static const INIT_PAGE = '/init-page';
  static const CART = '/cart';
  static const DASHBOARD = '/dashboard';
  static const MEMBER = '/member';
  static const REGISTRATION = '/registration';
  static const ADDRESS_MANAGE = '/address-manage';
  static const CONFIRM_ORDER = '/confirm-order';
  static const MY_ORDER = '/my-order';
  static const COMMON = '/common';
}
