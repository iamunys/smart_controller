import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/model/motoModel.dart';

class EnergyConsumption extends StatefulWidget {
  const EnergyConsumption({super.key});

  @override
  State<EnergyConsumption> createState() => _EnergyConsumptionState();
}

class _EnergyConsumptionState extends State<EnergyConsumption> {
  final userState = Get.put(UserStateController());
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? motorId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgPrimary,
        centerTitle: true,
        title: Text(
          'Energy Consumption',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Constant.textPrimary,
          ),
        ),
      ),
      body: motorId == null
          ? const Center(child: Text('No motor selected'))
          : StreamBuilder<MotorModel>(
              stream: motorStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final energyData = snapshot.data!;
                return _buildMainContent(energyData);
              },
            ),
    );
  }

  Widget _buildMainContent(MotorModel energyData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Constant.bgPrimary,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 3.h),
            Text('Today\'s Consumption:', style: TextStyle(fontSize: 15.sp)),
            SizedBox(height: 5.h),
            _buildEnergyCard('Today\'s Energy Consumption',
                '${energyData.energyConsume} kwh'),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Current(mA)', energyData.current),
                _buildMetricCard('Power(W)', energyData.power),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Voltage(V)', energyData.voltage),
                _buildMetricCard('Total(kWh)', energyData.energyConsume),
              ],
            ),
            SizedBox(height: 3.h),
            _buildEnergyCard('Today\'s Pumping Time', energyData.pumpingTime),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyCard(String title, String value) {
    return Container(
      width: 80.w,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
          Text(title,
              style: TextStyle(fontSize: 15.sp, color: Constant.textSecondary)),
          SizedBox(height: 0.5.h),
          Text(value,
              style: TextStyle(fontSize: 18.sp, color: Constant.bgSecondary)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
          Text(title,
              style: TextStyle(fontSize: 14.sp, color: Constant.textSecondary)),
          SizedBox(height: 0.5.h),
          Text(value,
              style: TextStyle(fontSize: 15.sp, color: Constant.bgSecondary)),
        ],
      ),
    );
  }
}

// class EnergyModel {
//   final String motorControl;
//   final String energyConsume;
//   final String current;
//   final String power;
//   final String voltage;
//   final String pumpingTime;
//   final String totalEnergyConsumed;

//   EnergyModel({
//     required this.motorControl,
//     required this.energyConsume,
//     required this.current,
//     required this.power,
//     required this.voltage,
//     required this.pumpingTime,
//     required this.totalEnergyConsumed,
//   });

//   factory EnergyModel.fromMap(
//       Map<dynamic, dynamic> deviceData, String totalEnergy) {
//     return EnergyModel(
//       motorControl: deviceData['motorControl']?.toString() ?? '0',
//       energyConsume: deviceData['energy']?.toString() ?? '0',
//       current: deviceData['currentValue']?.toString() ?? '0',
//       power: deviceData['power']?.toString() ?? '0',
//       voltage: deviceData['voltage']?.toString() ?? '0',
//       pumpingTime: deviceData['pumpingTime']?.toString() ?? '0',
//       totalEnergyConsumed: totalEnergy,
//     );
//   }
// }
