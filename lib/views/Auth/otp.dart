import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';

import '../../controller/userStateController.dart';

class Otp extends StatelessWidget {
  final TextEditingController otpController;
  final UserStateController userStateController;
  const Otp({
    super.key,
    required this.userStateController,
    required this.otpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 6.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: Constant.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: otpController,
            maxLength: 6,
            keyboardType: TextInputType.number,
            cursorColor: Constant.textPrimary,
            maxLines: 1,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: 'Enter Otp',
              hintStyle: TextStyle(
                  fontFamily: "Nunito",
                  color: Constant.textSecondary.withOpacity(.5),
                  fontSize: 16.sp,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600),
            ),
            style: TextStyle(
                fontFamily: "Nunito",
                color: Constant.textPrimary,
                fontSize: 16.sp,
                letterSpacing: 5,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          height: 5.h,
          width: 100.w,
          child: ElevatedButton(
            onPressed: userStateController.isLoading
                ? null
                : () async {
                    if (otpController.text.isNotEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      userStateController.isLoading = true;

                      try {
                        await userStateController
                            .verifyOTP(otpController.value.text);
                      } finally {
                        userStateController.isLoading = false;
                      }

                      if (userStateController.mobileVerificationError != null) {
                        otpController.clear();
                      }
                    } else {
                      userStateController.mobileVerificationError =
                          'Please enter a valid Otp';
                    }
                    userStateController.isLoading = false;
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.bgSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: userStateController.isLoading
                ? const MutationLoader()
                : Constant.textWithStyle(
                    text: 'LOGIN',
                    color: Constant.bgWhite,
                    fontWeight: FontWeight.w700,
                    size: 15.sp,
                  ),
          ),
        ),
      ],
    );
  }
}
