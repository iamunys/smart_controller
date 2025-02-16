import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  static DatabaseManager? _instance;
  final DatabaseReference _dbRef;

  DatabaseManager._() : _dbRef = FirebaseDatabase.instance.ref();

  static Future<DatabaseManager> getInstance() async {
    if (_instance == null) {
      await Firebase.initializeApp();
      _instance = DatabaseManager._();
    }
    return _instance!;
  }

  Future<void> writeData(String path, dynamic data) async {
    try {
      await _dbRef.child(path).set(data);
    } on FirebaseException catch (e) {
      throw DatabaseException('Failed to write data: ${e.message}');
    }
  }

  Future<dynamic> readData(String path) async {
    try {
      DataSnapshot snapshot = await _dbRef.child(path).get();
      return snapshot.value;
    } on FirebaseException catch (e) {
      throw DatabaseException('Failed to read data: ${e.message}');
    }
  }

  Stream<DatabaseEvent> streamData(String path) {
    return _dbRef.child(path).onValue.handleError((error) {
      throw DatabaseException('Error in data stream: $error');
    });
  }

  Future<void> updateValue(String path, String key, int value) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      await ref.update({key: value});
    } on FirebaseException catch (e) {
      throw DatabaseException('Failed to update data: ${e.message}');
    }
  }

  Future<void> updateValueOfEnergy(
      String path, String key, double value) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      await ref.update({key: value});
    } on FirebaseException catch (e) {
      throw DatabaseException('Failed to update data: ${e.message}');
    }
  }

  Future<void> updateMultipleValues(
      String path, Map<String, dynamic> updates) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      await ref.update(updates);
    } on FirebaseException catch (e) {
      throw DatabaseException('Failed to update data: ${e.message}');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
