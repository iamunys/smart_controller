// ignore_for_file: library_private_types_in_public_api


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/controller/widget_controller.dart';
import 'package:smart_controller/model/motoModel.dart';

class ChooseMotorScreen extends StatefulWidget {
  const ChooseMotorScreen({super.key});

  @override
  _ChooseMotorScreenState createState() => _ChooseMotorScreenState();
}

class _ChooseMotorScreenState extends State<ChooseMotorScreen> {
  final user = FirebaseAuth.instance.currentUser;

  DatabaseReference get _devicesRef =>
      FirebaseDatabase.instance.ref().child('deviceStatus');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgPrimary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgSecondary,
        centerTitle: false,
        elevation: 5,
        title: Constant.textWithStyle(
            fontWeight: FontWeight.w600,
            text: 'Choose your device',
            size: 18.sp,
            color: Constant.bgWhite),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<WidgetsController>().isAddDevice = true;
              Get.find<WidgetsController>().splashCompleteLogin = false;
              Get.find<WidgetsController>().splashCompleteSelectDevice = true;
              Get.find<WidgetsController>().splashCompleteListDevice = false;
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
      body: StreamBuilder<DatabaseEvent>(
        stream: _devicesRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final devicesMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final devices = devicesMap.entries.where((entry) {
            final deviceData = entry.value as Map<dynamic, dynamic>;
            return deviceData['userId'] == user?.uid;
          }).map((entry) {
            return MotorModel.fromMap(
                entry.key as String, entry.value as Map<dynamic, dynamic>);
          }).toList();

          return Padding(
            padding: EdgeInsets.all(2.w),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 0.9, // Adjust item aspect ratio
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return DeviceGridItem(device: device);
              },
            ),
          );
        },
      ),
    );
  }
}

class DeviceGridItem extends StatelessWidget {
  final MotorModel device;
  final userState = Get.find<UserStateController>();

  DeviceGridItem({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constant.bgWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          await userState.deleteStringPreference('motorId');
          await userState.setStringPreference('motorId', device.deviceId);
          context.push('/landing');
        },
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.device_thermostat,
                  size: 10.w, color: Constant.bgSecondary),
              SizedBox(height: 2.w),
              Text(
                device.deviceName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Constant.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color:
                          device.motorStatus == 1 ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    device.motorStatus == 1 ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          device.motorStatus == 1 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.w),
              Switch(
                value: device.motorControl == 1,
                onChanged: (value) {
                  FirebaseDatabase.instance
                      .ref()
                      .child('deviceStatus')
                      .child(device.deviceId)
                      .update({'motorControl': value ? 1 : 0});
                },
                activeColor: Constant.bgSecondary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
