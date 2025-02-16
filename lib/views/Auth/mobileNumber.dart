// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';
import 'package:smart_controller/controller/userStateController.dart';

class MobileNumber extends StatelessWidget {
  final UserStateController userStateController;
  final TextEditingController phoneNumberController;

  const MobileNumber({
    super.key,
    required this.userStateController,
    required this.phoneNumberController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Constant.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_iphone,
                      color: Constant.textSecondary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '+91',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phoneNumberController,
                  cursorColor: Constant.textPrimary,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textSecondary.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    color: Constant.textPrimary,
                    fontSize: 16,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          height: 5.h,
          width: 100.w,
          child: GetBuilder<MutationControlls>(
              init: MutationControlls(),
              builder: (mutationController) {
                if (userStateController.verificationId != null &&
                    mutationController.status == MutationStatus.loading) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    mutationController.status = MutationStatus.done;
                  });
                }
                if (userStateController.mobileVerificationError != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    mutationController.status = MutationStatus.done;
                  });
                }

                return ElevatedButton(
                  onPressed: mutationController.status == MutationStatus.loading
                      ? null
                      : () async {
                          if (phoneNumberController.text.isNotEmpty &&
                              phoneNumberController.text.isNumericOnly &&
                              phoneNumberController.text.length > 9) {
                            userStateController.clearError();
                            mutationController.status = MutationStatus.loading;
                            await userStateController.verifyPhoneNumber(
                                phoneNumberController.value.text);

                            if (kDebugMode) {
                              (phoneNumberController.value.text);
                            }
                          } else {
                            userStateController.mobileVerificationError =
                                'Please enter a valid phone number.';
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.bgSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: mutationController.status == MutationStatus.loading
                      ? const MutationLoader()
                      : Constant.textWithStyle(
                          text: 'COUNTINUE',
                          color: Constant.bgWhite,
                          fontWeight: FontWeight.w700,
                          size: 15.sp,
                        ),
                );
              }),
        ),
        SizedBox(
          height: 3.h,
        ),
      ],
    );
  }
}
