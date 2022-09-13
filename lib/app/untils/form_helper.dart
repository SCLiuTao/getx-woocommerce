import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormHelper {
  static Widget dateInput(
    BuildContext context,
    String labelText,
    TextEditingController controller, {
    Function(DateTime?)? onSave,
    DateTime? initialValue,
    FormFieldValidator<DateTime>? validator,
  }) {
    return DateTimeField(
      resetIcon: const Icon(Icons.cancel),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          color: Color.fromARGB(255, 93, 93, 93),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        // contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffD5D5D5),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
      controller: controller,
      onSaved: onSave,
      format: DateFormat("yyyy-MM-dd"),
      initialValue: initialValue,
      validator: validator,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
  }

  static Widget cuptinoDateInput(
    BuildContext context,
    String labelText,
    TextEditingController controller, {
    Function(DateTime?)? onSave,
    DateTime? initialValue,
    FormFieldValidator<DateTime>? validator,
  }) {
    var systemLang = Get.locale;
    Locale currentLang;
    if (systemLang.toString() == "en_US") {
      currentLang = const Locale("en", "US");
    } else if (systemLang.toString() == "zh_HK") {
      currentLang = const Locale("zh", "HK");
    } else {
      currentLang = const Locale("zh", "CN");
    }

    return DateTimeField(
      style: TextStyle(color: Colors.white),
      resetIcon: const Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
      controller: controller,
      format: DateFormat("yyyy-MM-dd"),
      onShowPicker: (context, currentValue) async {
        await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return BottomSheet(
                builder: (context) => Localizations.override(
                  context: context,
                  locale: currentLang,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: CupertinoDatePicker(
                          initialDateTime: controller.text != ""
                              ? DateTime.parse(controller.text)
                              : DateTime.now(),
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime date) {
                            initialValue = date;
                            controller.text = DateFormat("yyyy-MM-dd")
                                .format(date)
                                .toString();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextButton(
                            onPressed: () => {
                                  if (controller.text == "")
                                    controller.text = DateFormat("yyyy-MM-dd")
                                        .format(DateTime.now())
                                        .toString(),
                                  Navigator.pop(context)
                                },
                            child: Text(
                              'done'.tr,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromARGB(255, 66, 66, 66)),
                            )),
                      ),
                    ],
                  ),
                ),
                onClosing: () {},
              );
            });
        return initialValue;
      },
      onSaved: onSave,
    );
  }

  static Widget timeInput(
    BuildContext context,
    String labelText,
    TextEditingController controller, {
    Function(DateTime?)? onSave,
    DateTime? initialValue,
    FormFieldValidator<DateTime>? validator,
  }) {
    return DateTimeField(
      format: DateFormat("HH:mm"),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          color: Color.fromARGB(255, 93, 93, 93),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        // contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffD5D5D5),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
      resetIcon: const Icon(Icons.cancel),
      validator: validator,
      onShowPicker: (context, currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!),
        );
        return DateTimeField.convert(time);
      },
    );
  }

  static Widget cuptinoTimeInput(
    BuildContext context,
    String labelText,
    TextEditingController controller, {
    Function(DateTime?)? onSave,
    Duration? initialValue,
    FormFieldValidator<DateTime>? validator,
  }) {
    var systemLang = Get.locale;
    Locale currentLang;
    if (systemLang.toString() == "en_US") {
      currentLang = const Locale("en", "US");
    } else if (systemLang.toString() == "zh_HK") {
      currentLang = const Locale("zh", "HK");
    } else {
      currentLang = const Locale("zh", "CN");
    }

    return DateTimeField(
      style: TextStyle(color: Colors.white),
      resetIcon: const Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          color: Color.fromARGB(255, 93, 93, 93),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        // contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffD5D5D5),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
      ),
      controller: controller,
      format: DateFormat("HH:mm"),
      onShowPicker: (context, currentValue) async {
        await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return BottomSheet(
                builder: (context) => Localizations.override(
                  context: context,
                  locale: currentLang,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          initialTimerDuration: controller.text == ""
                              ? const Duration(hours: 0, minutes: 0)
                              : Duration(
                                  hours:
                                      int.parse(controller.text.split(":")[0]),
                                  minutes:
                                      int.parse(controller.text.split(":")[1]),
                                ),
                          onTimerDurationChanged: (Duration value) {
                            initialValue = value;
                            controller.text =
                                "${value.inHours.toString().padLeft(2, "0")}:${(value.inMinutes % 60).toString().padLeft(2, "0")}";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextButton(
                            onPressed: () => {
                                  if (controller.text == "")
                                    controller.text = DateFormat("HH:mm")
                                        .format(DateTime.now())
                                        .toString(),
                                  Navigator.pop(context)
                                },
                            child: Text(
                              "done".tr,
                              style: const TextStyle(fontSize: 20.0),
                            )),
                      ),
                    ],
                  ),
                ),
                onClosing: () {},
              );
            });
        return null;
      },
      onSaved: onSave,
    );
  }

  static Widget textInput(
    BuildContext context,
    String labelText,
    TextEditingController controller,
    TextInputType keyboardType, {
    FormFieldSetter? onSave,
    bool isPasswordType = false,
    bool readOnly = false,
    bool filled = false,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator, //验证
    FocusNode? focusNode, //焦点
    int? maxLines = 1,
    bool? enabled = true,
  }) {
    return TextFormField(
      enabled: enabled,
      autofocus: false,
      maxLines: maxLines,
      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode,
      style: TextStyle(
          color:
              enabled == true ? Colors.white : Colors.white.withOpacity(0.6)),
      cursorColor: Colors.white,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
          filled: filled, //填充顏色
          suffixIcon: suffixIcon,
          fillColor: Colors.white.withOpacity(0.3),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1.0, color: Color.fromARGB(255, 152, 0, 1))),
          errorStyle: TextStyle(color: Color.fromARGB(255, 152, 0, 1)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.white)),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          enabledBorder: filled == true
              ? InputBorder.none
              : UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: readOnly == true ? const Color(0xffD5D5D5) : Colors.white,
              width: 1.0,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color(0xffD5D5D5)))),
      keyboardType: keyboardType,
      obscureText: isPasswordType,
      onSaved: onSave,
      validator: validator,
    );
  }

  static InputDecoration fieldInputDecoration(
    BuildContext context,
    String labelText,
  ) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 93, 93, 93),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).hintColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // enabledBorder: const OutlineInputBorder(
      //     borderSide: BorderSide(
      //       color: Color(0xffD5D5D5),
      //       width: 1,
      //     ),
      //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffD5D5D5),
          width: 1,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
    );
  }

  static BoxDecoration containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      border: Border.all(
        width: 1.0,
        color: const Color.fromARGB(255, 220, 220, 221),
      ),
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {String? color,
      String? textColor,
      bool? fullWidth,
      double width = 150.0}) {
    return SizedBox(
      height: 40.0,
      width: width,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 61, 203, 128),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: const Color.fromARGB(255, 61, 203, 128),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                onPressed();
              },
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 20.0),
              ),
            )
          ],
        );
      },
    );
  }
}
