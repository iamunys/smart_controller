import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? motorId = '';
  final userState = Get.put(UserStateController());

  @override
  void initState() {
    getid();
    super.initState();
  }

  getid() async {
    motorId = await userState.getStringPreference('motorId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgPrimary,
        centerTitle: true,
        title: Constant.textWithStyle(
            fontWeight: FontWeight.bold,
            text: 'Settings',
            size: 18.sp,
            color: Constant.textPrimary),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Constant.bgPrimary,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 3.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Constant.textWithStyle(
                            textAlign: TextAlign.center,
                            text: userState.currentUser!.phoneNumber!,
                            size: 17.sp,
                            maxLine: 3,
                            fontWeight: FontWeight.bold,
                            color: Constant.textPrimary),
                        Constant.textWithStyle(
                            textAlign: TextAlign.center,
                            text: 'MOTCON V3',
                            size: 16.sp,
                            maxLine: 3,
                            fontWeight: FontWeight.w500,
                            color: Constant.textSecondary),
                        Constant.textWithStyle(
                            textAlign: TextAlign.center,
                            text: motorId!,
                            size: 14.5.sp,
                            maxLine: 3,
                            fontWeight: FontWeight.normal,
                            color: Constant.bgBlue),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Constant.bgWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          child: SizedBox(
                            height: 7.h,
                            width: 100.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 12.w,
                                    width: 12.w,
                                    decoration: const BoxDecoration(
                                      color: Constant.bgPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/constant/icons/phone.png',
                                        color: Constant.textSecondary,
                                        scale: 1.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.h,
                                  ),
                                  Constant.textWithStyle(
                                      text: 'Help Center',
                                      fontWeight: FontWeight.normal,
                                      size: 14.5.sp,
                                      maxLine: 3,
                                      color: Constant.textPrimary),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 2.h,
                          color: Constant.textSecondary,
                          thickness: .1,
                        ),
                        InkWell(
                          onTap: () {
                            Get.find<UserStateController>().signOut();
                          },
                          child: SizedBox(
                            height: 7.h,
                            width: 100.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 12.w,
                                    width: 12.w,
                                    decoration: const BoxDecoration(
                                      color: Constant.bgPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/constant/icons/power.png',
                                        scale: 1.5,
                                        color: Constant.textSecondary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.h,
                                  ),
                                  Constant.textWithStyle(
                                      text: 'Logout',
                                      size: 14.5.sp,
                                      maxLine: 3,
                                      color: Constant.textPrimary),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget energy({required String heading, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 80.w,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Constant.bgPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(-3, -3),
                  blurRadius: 15,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(3, 3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                Constant.textWithStyle(
                    text: heading, size: 15.sp, color: Constant.textSecondary),
                SizedBox(
                  height: .5.h,
                ),
                Constant.textWithStyle(
                    text: value, size: 18.sp, color: Constant.bgSecondary),
              ],
            )),
      ],
    );
  }

  currentAndPower({required String heading, required String value}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Constant.bgPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(-3, -3),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(3, 3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            Constant.textWithStyle(
                text: heading, size: 14.sp, color: Constant.textSecondary),
            SizedBox(
              height: .5.h,
            ),
            Constant.textWithStyle(
                text: value, size: 15.sp, color: Constant.bgSecondary),
          ],
        ));
  }
}
