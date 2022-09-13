import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'app/languages/messages.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 235, 72, 99),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
          ),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 212, 130, 6)),
            overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            textStyle:
                MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 14.0)),
            elevation: MaterialStateProperty.all<double>(0.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(
            //     Color.fromARGB(197, 18, 86, 212)),
            // elevation: MaterialStateProperty.all(4.0),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            textStyle:
                MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 15.0)),
          ),
        ),
        // colorScheme: const ColorScheme.dark(
        //   primary: Color.fromARGB(255, 247, 247, 247),
        //   onPrimary: Colors.black87,
        // ),
        primarySwatch: Colors.blue,
        //scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: "商城",
      defaultTransition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: ui.window.locale,
      fallbackLocale: Locale("zh", "CN"),
      translations: Messages(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // builder: EasyLoading.init(),
      builder: (context, child) {
        final easyload = EasyLoading.init();
        child = easyload(context, child);
        child = Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () => hideKeyboard(context),
            child: child,
          ),
        );
        child = MediaQuery(
          ///设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
        return child;
      },
    ),
  );
  if (GetPlatform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

///点击空白处隐藏键盘
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
