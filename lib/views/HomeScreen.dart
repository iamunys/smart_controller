// ignore_for_file: file_names, depend_on_referenced_packages, unnecessary_null_comparison

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/model/motoModel.dart';
import 'package:smart_controller/widgets/offlineoronline.dart';
import 'package:smart_controller/widgets/power_button.dart';
import 'package:smart_controller/widgets/water_level.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userState = Get.put(UserStateController());
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? motorId;
  bool isFirstOpen = true;
  List<TextEditingController> minuteController = List.generate(
    3,
    (index) => TextEditingController(text: ''),
  );

  List<TimeOfDay>? selectedTime = List.generate(
    3,
    (index) => const TimeOfDay(hour: 00, minute: 0),
  );
  List<String> formattedTime = List.generate(
    3,
    (index) => '6.00 AM',
  );
  String selectedUnitFrame = 'Hour(s)';

  @override
  void initState() {
    super.initState();
    _getMotorId();
  }

  Future<void> _getMotorId() async {
    motorId = await userState.getStringPreference('motorId');
    setState(() {});
  }

  Stream<MotorModel> get motorStream {
    if (motorId == null) return const Stream.empty();

    return _database.child('deviceStatus/$motorId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return MotorModel.fromMap(motorId!, data);
    });
  }

  Future<void> updateMotorControl(int value) async {
    try {
      await _database.child('deviceStatus/$motorId/motorControl').set(value);
      _showMessage(value == 1 ? 'Motor is on' : 'Motor is off',
          isOn: value == 1);
    } catch (e) {
      _showError('Update failed: $e');
    }
  }

  Future<void> updateMotorSchedule(int value) async {
    try {
      await _database.child('deviceStatus/$motorId/motorControl').set(value);
      _showMessage(value == 1 ? 'Motor is on' : 'Motor is off',
          isOn: value == 1);
    } catch (e) {
      _showError('Update failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: motorId == null
          ? const Center(child: Text('No motor selected'))
          : _buildMainContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Constant.bgPrimary,
      centerTitle: true,
      title: Text(
        'Saron Smart',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Constant.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return StreamBuilder<MotorModel>(
      stream: motorStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final motor = snapshot.data!;
        return Container(
          height: 100.h,
          width: 100.w,
          color: Constant.bgPrimary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              //_buildWaterAnimation(motor),
              _buildControlInterface(motor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaterAnimation(MotorModel motor) {
    return AdvancedWaterAnimation(
      fillPercentage: _getFillPercentage(motor.waterLevel),
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
      height: 100.h,
      width: 100.w,
      showPercentage: true,
    );
  }

  double _getFillPercentage(String waterLevel) {
    switch (waterLevel.toLowerCase()) {
      case 'medium':
        return 0.5;
      case 'full':
        return 1.0;
      default:
        return 0.0;
    }
  }

  Widget _buildControlInterface(MotorModel motor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          CounterStatusWidget(motorId: motorId!),
          SizedBox(height: 1.h),
          _buildStatusText(motor),
          SizedBox(height: 1.h),
          PowerButton(
            value: motor.motorControl.toString(),
            onPressed: () =>
                updateMotorControl(motor.motorControl == 1 ? 0 : 1),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(3, (index) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (isFirstOpen) {
                      setState(() {
                        if (index == 0) {
                          formattedTime[index] = motor.onTime1;
                          minuteController[index].text =
                              motor.onDuration1.toString();
                        } else if (index == 1) {
                          formattedTime[index] = motor.onTime2;
                          minuteController[index].text =
                              motor.onDuration2.toString();
                        } else {
                          formattedTime[index] = motor.onTime3;
                          minuteController[index].text =
                              motor.onDuration3.toString();
                          isFirstOpen = false;
                        }
                      });
                    }
                  });
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Constant.bgWhite,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0
                            ? motor.enableTimer1 == 1
                            : index == 1
                                ? motor.enableTimer2 == 1
                                : motor.enableTimer3 == 1)
                          if (index == 0
                              ? motor.timer1Done == 1
                              : index == 1
                                  ? motor.timer2Done == 1
                                  : motor.timer3Done == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Constant.textWithStyle(
                                  text: 'Done',
                                  color: Constant.textPrimary,
                                  size: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                        // else
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //         width: 8,
                        //         height: 8,
                        //         decoration: const BoxDecoration(
                        //           color: Colors.green,
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //       SizedBox(width: 1.w),
                        //       Constant.textWithStyle(
                        //         text: 'Done',
                        //         color: Constant.textPrimary,
                        //         size: 14.sp,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ],
                        //   ),

                        SizedBox(height: 1.h),
                        Constant.textWithStyle(
                          text: 'Schedule - ${index + 1}',
                          color: Constant.textPrimary,
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            buildTimeWid(
                                index == 0
                                    ? motor.enableTimer1
                                    : index == 1
                                        ? motor.enableTimer2
                                        : motor.enableTimer3,
                                index),
                            SizedBox(width: 2.w),
                            buildPeriodWid(
                                index == 0
                                    ? motor.enableTimer1
                                    : index == 1
                                        ? motor.enableTimer2
                                        : motor.enableTimer3,
                                index),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (index == 0
                                ? motor.enableTimer1 == 1
                                : index == 1
                                    ? motor.enableTimer2 == 1
                                    : motor.enableTimer3 == 1)
                              Constant.textWithStyle(
                                text: 'Timer scheduled',
                                color: Constant.bgSecondary,
                                size: 16.sp,
                                fontWeight: FontWeight.w600,
                              )
                            else
                              Constant.textWithStyle(
                                text: 'Timer not scheduled',
                                color: Constant.bgRed,
                                size: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            Switch(
                              value: index == 0
                                  ? motor.enableTimer1 == 1
                                  : index == 1
                                      ? motor.enableTimer2 == 1
                                      : motor.enableTimer3 == 1,
                              onChanged: (value) {
                                FirebaseDatabase.instance
                                    .ref()
                                    .child('deviceStatus')
                                    .child(motor.deviceId)
                                    .update({
                                  'enableTimer${index + 1}': value ? 1 : 0
                                });
                                FirebaseDatabase.instance
                                    .ref()
                                    .child('deviceStatus')
                                    .child(motor.deviceId)
                                    .update({
                                  'onTime${index + 1}': formattedTime[index]
                                });
                                FirebaseDatabase.instance
                                    .ref()
                                    .child('deviceStatus')
                                    .child(motor.deviceId)
                                    .update({
                                  'onDuration${index + 1}':
                                      minuteController[index].text
                                });
                              },
                              activeColor: Constant.bgSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(MotorModel motor) {
    return Constant.textWithStyle(
      fontWeight: FontWeight.w900,
      text: motor.motorStatus == 0 ? 'Off' : 'On',
      size: 17.sp,
      color: motor.motorStatus == 0 ? Constant.bgRed : Constant.bgGreen,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showMessage(String message, {required bool isOn}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        backgroundColor: isOn ? Constant.bgGreen : Constant.bgRed,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 15.sp,
            color: Constant.bgWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  buildTimeWid(
    int enableTimer,
    int index,
  ) {
    return enableTimer == 0
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: 'Start time',
                  color: Constant.textPrimary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Constant.textPrimary,
                              onPrimary: Constant.bgPrimary,
                              onSurface: Constant.textPrimary,
                            ),
                            timePickerTheme: TimePickerThemeData(
                              dayPeriodColor:
                                  WidgetStateColor.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Constant
                                      .textPrimary; // Color when AM/PM is selected
                                }
                                return Constant
                                    .textSecondary; // Color when AM/PM is not selected
                              }),
                              dayPeriodTextColor:
                                  WidgetStateColor.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Constant
                                      .textSecondary; // Text color when selected
                                }
                                return Colors
                                    .black; // Text color when not selected
                              }),

                              dialBackgroundColor:
                                  Constant.bgPrimary, // Clock face background
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime![index] = pickedTime;
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day,
                            pickedTime.hour, pickedTime.minute);
                        // formattedTime[index] = DateFormat('hh:mm a').format(dt);
                        formattedTime[index] = DateFormat('HH:mm').format(dt);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Constant.textPrimary)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 6.w,
                          width: 6.w,
                          child: const Center(child: Icon(Icons.timer)),
                        ),
                        SizedBox(width: 1.w),
                        Constant.textWithStyle(
                          text: selectedTime![index] != null
                              ? '${formattedTime[index]} '
                              : 'Select Time',
                          color: selectedTime![index] != null
                              ? Constant.textPrimary
                              : Constant.textPrimary,
                          size: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: Constant.textSecondary,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: 'Start time',
                  color: Constant.textSecondary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textSecondary)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 6.w,
                        width: 6.w,
                        child: const Center(
                            child: Icon(
                          Icons.timer,
                          color: Constant.textSecondary,
                        )),
                      ),
                      SizedBox(width: 1.w),
                      Constant.textWithStyle(
                        text: selectedTime![index] != null
                            ? '${formattedTime[index]} '
                            : 'Select Time',
                        color: Constant.textSecondary,
                        size: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                        color: Constant.textSecondary,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  buildPeriodWid(int enableTimer, int index) {
    return enableTimer == 0
        ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: 'Duration (Minutes)',
                  color: Constant.textPrimary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textPrimary)),
                  child: TextFormField(
                    controller: minuteController[index],
                    cursorColor: Constant.textPrimary,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Minutes',
                      hintStyle: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textSecondary,
                        fontSize: 15.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textPrimary,
                      fontSize: 15.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.textWithStyle(
                  text: 'Duration (Minutes)',
                  color: Constant.textSecondary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 1.h),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Constant.textSecondary)),
                  child: TextFormField(
                    enabled: false,
                    controller: minuteController[index],
                    cursorColor: Constant.textPrimary,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Minutes',
                      hintStyle: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textSecondary,
                        fontSize: 15.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textSecondary,
                      fontSize: 16.sp,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
