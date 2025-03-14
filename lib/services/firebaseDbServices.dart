import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_controller/model/motoModel.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Check if a device exists by deviceId
  Future<bool> doesDeviceExist(String deviceId) async {
    DataSnapshot snapshot = await _database.child('dS').child(deviceId).get();
    return snapshot.exists;
  }

  // Create a new device
  Future<void> createDevice(MotorModel device) async {
    await _database.child('dS').child(device.deviceId).set(device.toJson());
  }

  Future<List<MotorModel>> listDevices() async {
    DataSnapshot snapshot = await _database.child('dS').get();
    List<MotorModel> devices = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        devices.add(MotorModel.fromMap(value, key));
      });
    }
    return devices;
  }

  Future<void> updateDevice(
      String deviceId, Map<String, dynamic> updates) async {
    await _database.child('dS').child(deviceId).update(updates);
  }

  // static Future<String?> getUserIdByEmail(String email) async {
  //   try {
  //     QuerySnapshot userQuery = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: email)
  //         .limit(1)
  //         .get();

  //     if (userQuery.docs.isNotEmpty) {
  //       return userQuery.docs.first.id;
  //     } else {
  //       print("No user found with this email.");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return null;
  //   }
  // }
}
