// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';

class Utilis {
  static showAlertDialog(
      {required BuildContext context,
      required String title,
      required String description,
      required bool needSecondButton,
      required String button1name,
      required String button2name,
      required button2onpress}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Constant.textWithStyle(
          textAlign: TextAlign.center,
          text: button1name,
          size: 15.sp,
          color: Constant.textPrimary),
      onPressed: () {
        context.pop();
      },
    );
    Widget okButton = TextButton(
      child: Constant.textWithStyle(
          textAlign: TextAlign.center,
          text: button2name,
          size: 15.sp,
          color: Constant.textPrimary),
      onPressed: () {
        button2onpress();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Constant.textWithStyle(
          textAlign: TextAlign.center,
          text: title,
          size: 17.sp,
          fontWeight: FontWeight.w700,
          color: Constant.textPrimary),
      content: Constant.textWithStyle(
          text: description,
          size: 15.sp,
          fontWeight: FontWeight.w600,
          maxLine: 5,
          textAlign: TextAlign.center,
          color: Constant.textSecondary),
      actions: [
        cancelButton,
        needSecondButton ? okButton : const SizedBox.shrink(),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static snackBar(
      {required BuildContext context,
      required String title,
      required String message,
      bool failure = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constant.textWithStyle(
              text: title,
              size: 14.sp,
              fontWeight: FontWeight.w600,
              maxLine: 2,
              color: failure ? Constant.bgRed : Constant.bgGreen,
            ),
            Constant.textWithStyle(
              text: message,
              size: 13.sp,
              fontWeight: FontWeight.normal,
              maxLine: 3,
              color: Constant.textPrimary,
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Constant.bgWhite,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  static Widget toastToExitApp = Container(
    width: 40.w,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Constant.bgWhite,
    ),
    child: Center(
      child: Constant.textWithStyle(
        text: "Press again to exit",
        color: Constant.bgPrimary,
        size: 15.sp,
      ),
    ),
  );

  static getThefields(
      {required String hintText,
      required int maxLine,
      required int height,
      required TextEditingController controller}) {
    return Container(
      height: height.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: Constant.textSecondary.withOpacity(.07),
          // border: Border.all(color: Constant.textPrimary, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        cursorColor: Constant.textPrimary,
        maxLines: maxLine,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: "Nunito",
                color: Constant.textSecondary,
                fontSize: 16.sp,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
        style: TextStyle(
            fontFamily: "Nunito",
            color: Constant.textPrimary,
            fontSize: 16.sp,
            letterSpacing: 2,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
