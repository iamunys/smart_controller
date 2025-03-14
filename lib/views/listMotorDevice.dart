// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/model/motoModel.dart';
import 'package:smart_controller/widgets/offlineoronline.dart';
import 'package:smart_controller/widgets/utilis.dart';

class ListDeviceScreen extends StatefulWidget {
  const ListDeviceScreen({super.key});

  @override
  _ListDeviceScreenState createState() => _ListDeviceScreenState();
}

class _ListDeviceScreenState extends State<ListDeviceScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFirstOpen = true;
  List<String> formattedTime = [];

  DatabaseReference get _devicesRef =>
      FirebaseDatabase.instance.ref().child('dS');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgPrimary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgSecondary,
        centerTitle: false,
        elevation: 5,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Constant.bgWhite,
            )),
        title: Constant.textWithStyle(
            fontWeight: FontWeight.w900,
            text: 'Choose your device',
            size: 18.sp,
            color: Constant.bgWhite),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/addDevice');
            },
            icon: Icon(
              Icons.add,
              size: 22.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 2.w)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<DatabaseEvent>(
          stream: _devicesRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final devicesMap =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            final devices = devicesMap.entries.where((entry) {
              final deviceData = entry.value as Map<dynamic, dynamic>;

              if (deviceData.containsKey('uIds')) {
                final userIdsMap = deviceData['uIds'] as Map<dynamic, dynamic>;
                return userIdsMap.containsKey(user!.email!.split(".")[0]);
              }
              return false;
            }).map((entry) {
              return MotorModel.fromMap(
                  entry.key as String, entry.value as Map<dynamic, dynamic>);
            }).toList();
            if (devices.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/constant/icons/motor.png',
                      color: Constant.textPrimary, scale: 6),
                  SizedBox(height: 1.h),
                  Constant.textWithStyle(
                      text: 'No Device found',
                      size: 17.sp,
                      color: Constant.textPrimary,
                      fontWeight: FontWeight.w600),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => context.go('/addDevice'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Constant.bgSecondary),
                          ),
                          child: Center(
                            child: Constant.textWithStyle(
                                text: 'Add Devices',
                                size: 16.sp,
                                color: Constant.bgSecondary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () => context.push('/profile'),
                    child: Center(
                      child: Constant.textWithStyle(
                          text: 'Settings -->',
                          size: 15.sp,
                          color: Constant.textSecondary,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: List.generate(
                    devices.length,
                    (index) {
                      final device = devices[index];
                      return deviceGridItem(device: device);
                    },
                  ),
                ),
              );

              // Padding(
              //   padding: EdgeInsets.all(2.w),
              //   child: GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2, // Number of columns
              //       crossAxisSpacing: 2.w,
              //       mainAxisSpacing: 2.w,
              //       childAspectRatio: 0.9, // Adjust item aspect ratio
              //     ),
              //     itemCount: devices.length,
              //     itemBuilder: (context, index) {
              //       final device = devices[index];
              //       return DeviceGridItem(device: device);
              //     },
              //   ),
              // );
            }
          },
        ),
      ),
    );
  }

  Widget deviceGridItem({required MotorModel device}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFirstOpen) {
        setState(() {
          if (device.enableTimer1 == 1) {
            formattedTime.add(
                '${Utilis.formatTime(device.onTime1.toInt().toString())}  for  ${device.onDuration1.toString()} Min');
          }

          if (device.enableTimer2 == 1) {
            formattedTime.add(
                '${Utilis.formatTime(device.onTime2.toInt().toString())}  for  ${device.onDuration2.toString()} Min');
          }

          if (device.enableTimer3 == 1) {
            formattedTime.add(
                '${Utilis.formatTime(device.onTime3.toInt().toString())}  for  ${device.onDuration3.toString()} Min');
          }
          isFirstOpen = false;
        });
      }
    });
    return Card(
      color: Constant.bgWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          context.push('/landing', extra: device.deviceId);
        },
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  minVerticalPadding: 0,
                  minTileHeight: 0,
                  contentPadding: EdgeInsets.zero,
                  title: Constant.textWithStyle(
                    fontWeight: FontWeight.w700,
                    text: device.deviceName,
                    size: 16.sp,
                    color: Constant.textPrimary,
                  ),
                  subtitle: CounterStatusWidget(motorId: device.deviceId),
                  leading: Image.asset('lib/constant/icons/battery.png',
                      color: Constant.bgSecondary, scale: 3),
                  trailing: Switch(
                    value: device.motorControl == 1,
                    onChanged: (value) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('dS')
                          .child(device.deviceId)
                          .update({'mC': value ? 1 : 0});
                    },
                    activeColor: Constant.bgSecondary,
                    inactiveTrackColor: Constant.bgPrimary,
                    inactiveThumbColor: Constant.textPrimary,
                    activeTrackColor: Constant.bgSecondary.withOpacity(.4),
                  ),
                ),
                SizedBox(height: 2.h),
                Constant.textWithStyle(
                  text: 'Last Updated : ${device.lastUpdate}',
                  color: Constant.textPrimary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                if (device.waterLevel != '') ...[
                  SizedBox(height: 2.h),
                  tankStatusWidget(motorId: device.waterLevel),
                ],
                // if (formattedTime.isNotEmpty) ...[
                //   SizedBox(height: 2.h),
                //   Constant.textWithStyle(
                //     text: 'Scheduled Time :',
                //     color: Constant.textPrimary,
                //     size: 16.sp,
                //     fontWeight: FontWeight.w700,
                //   ),
                //   SizedBox(height: 1.h),
                //   timerScheduled(data: device),
                // ]
              ],
            )

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Image.asset('lib/constant/icons/battery.png',
            //         color: Constant.bgSecondary, scale: 4),
            //     SizedBox(height: 2.w),
            //     Constant.textWithStyle(
            //       fontWeight: FontWeight.w700,
            //       text: device.deviceName,
            //       size: 15.sp,
            //       color: Constant.textSecondary,
            //       textAlign: TextAlign.center,
            //     ),
            //     SizedBox(height: 1.w),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         CounterStatusWidget(motorId: device.deviceId),
            //       ],
            //     ),
            //     SizedBox(height: 2.w),
            //     Switch(
            //       value: device.motorControl == 1,
            //       onChanged: (value) {
            //         FirebaseDatabase.instance
            //             .ref()
            //             .child('dS')
            //             .child(device.deviceId)
            //             .update({'motorControl': value ? 1 : 0});
            //       },
            //       activeColor: Constant.bgSecondary,
            //       inactiveTrackColor: Constant.bgPrimary,
            //       inactiveThumbColor: Constant.textPrimary,
            //       activeTrackColor: Constant.bgSecondary.withOpacity(.4),
            //     )
            //   ],
            // ),
            ),
      ),
    );
  }

  tankStatusWidget({required String motorId}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Constant.textWithStyle(
          text: 'Status : ',
          color: Constant.textPrimary,
          size: 16.sp,
          fontWeight: FontWeight.w700,
        ),
        Constant.textWithStyle(
          text: motorId,
          color: Constant.bgOrange,
          size: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  timerScheduled({required MotorModel data}) {
    return Column(
      children: List.generate(formattedTime.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Constant.textWithStyle(
                text: '${index + 1} - ',
                color: Constant.textSecondary,
                size: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              Container(
                child: Constant.textWithStyle(
                  text: formattedTime[index],
                  color: Constant.textPrimary,
                  size: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
