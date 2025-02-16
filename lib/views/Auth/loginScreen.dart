// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/views/Auth/mobileNumber.dart';
import 'package:smart_controller/views/Auth/otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Constant.bgPrimary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark, // or .light
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: const [],
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: GetBuilder<UserStateController>(
              init: UserStateController(),
              builder: (userStateController) {
                return Container(
                  height: 100.h,
                  width: 100.w,
                  color: Constant.bgPrimary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Saron Smart',
                            style: TextStyle(
                                fontFamily: 'Anton',
                                color: Constant.bgSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 22.sp,
                                letterSpacing: 2),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          userStateController.verificationId == null
                              ? Constant.textWithStyle(
                                  text:
                                      'Kindly input your 10-digit mobile phone number',
                                  color: Constant.textPrimary,
                                  size: 15.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w600,
                                )
                              : Constant.textWithStyle(
                                  text:
                                      'Please input the verification code sent to your mobile device',
                                  color: Constant.textPrimary,
                                  size: 15.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w600,
                                ),
                          SizedBox(
                            height: 3.h,
                          ),
                          userStateController.verificationId == null
                              ? MobileNumber(
                                  phoneNumberController: phoneNumberController,
                                  userStateController: userStateController,
                                )
                              : Otp(
                                  userStateController: userStateController,
                                  otpController: otpController,
                                ),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
