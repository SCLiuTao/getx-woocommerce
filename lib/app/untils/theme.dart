import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextStyle get headingStyle {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

//简短说明样式
TextStyle get postExcerptStyle {
  return TextStyle(
    fontSize: 15.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get bodyStyle {
  return TextStyle(fontSize: 15.0, color: Colors.white);
}

TextStyle get regularPriceStyle {
  return TextStyle(
    fontSize: 17.0,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.grey,
  );
}

TextStyle get detaileRegularPriceStyle {
  return TextStyle(
    fontSize: 17.0,
    color: Colors.grey[800],
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.grey[800],
    fontWeight: FontWeight.bold,
  );
}

TextStyle get salePriceStyle {
  return TextStyle(
    fontSize: 17.0,
    color: Colors.orange,
  );
}

TextStyle get detailSalePriceStyle {
  return TextStyle(
    fontSize: 25.0,
    color: Color.fromARGB(255, 26, 219, 226),
    fontWeight: FontWeight.bold,
  );
}

TextStyle get shopTitleStyle {
  return TextStyle(
    fontSize: 13.0,
  );
}

LinearGradient get backgroundLinearGradient {
  return LinearGradient(
    colors: [
      Color.fromARGB(255, 235, 72, 99),
      Color.fromARGB(179, 214, 51, 10),
      Color.fromARGB(223, 146, 91, 137),
      Color.fromARGB(255, 212, 112, 179),
    ],
    stops: const <double>[0.0, 0.25, 0.7, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

LinearGradient get swiperLinearGradient {
  return LinearGradient(
    colors: [
      Color.fromARGB(255, 90, 37, 34),
      Color.fromARGB(255, 209, 180, 13),
      Color.fromARGB(255, 172, 95, 120),
      Color.fromARGB(255, 89, 68, 209),
    ],
    stops: const <double>[0.0, 0.4, 0.7, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

SnackbarController errorSnackbar(String messages, {String? title}) {
  return Get.snackbar(
    "",
    "",
    titleText: Text(
      title ?? "systemMessage".tr,
      style: TextStyle(
          color: Color.fromARGB(255, 233, 32, 17),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
    ),
    messageText: Text(messages,
        style:
            TextStyle(color: Color.fromARGB(255, 233, 32, 17), fontSize: 14.0)),
    icon: Icon(
      Icons.highlight_off,
      color: Color.fromARGB(255, 233, 32, 17),
      size: 30.0,
    ),
    backgroundColor: Color.fromARGB(136, 5, 2, 2),
    duration: Duration(seconds: 3),
  );
}

SnackbarController successSnackbar(String messages,
    {String? title, int showTime = 3}) {
  return Get.snackbar(
    "",
    "",
    titleText: Text(
      title ?? "systemMessage".tr,
      style: TextStyle(
          color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    messageText:
        Text(messages, style: TextStyle(color: Colors.green, fontSize: 14.0)),
    icon: Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 30.0,
    ),
    backgroundColor: Color.fromARGB(136, 5, 2, 2),
    duration: Duration(seconds: showTime),
  );
}
