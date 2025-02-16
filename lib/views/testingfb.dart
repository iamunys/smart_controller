import 'package:flutter/material.dart';
import 'package:smart_controller/services/fb_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseManager _dbManager;
  String _data = 'No data';

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      _dbManager = await DatabaseManager.getInstance();
      _loadData();
    } catch (e) {
      _showError('Failed to initialize database: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      var data = await _dbManager.readData('Motcon_wifi/ID_97C');
      setState(() {
        _data = data.toString();
      });
    } on DatabaseException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _writeData() async {
    try {
      await _dbManager
          .writeData('Motcon_wifi/ID_97C', {'motor': 0, 'light': 0});
      _showMessage('Data written successfully');
      _loadData();
    } on DatabaseException catch (e) {
      _showError(e.message);
    }
  }

  void _streamData() {
    _dbManager.streamData('Motcon_wifi/ID_97C').listen(
      (event) {
        setState(() {
          _data = event.snapshot.value.toString();
        });
      },
      onError: (error) {
        _showError('Stream error: $error');
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Realtime Database Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Data: $_data'),
            ElevatedButton(
              onPressed: _writeData,
              child: const Text('Write Data'),
            ),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Read Data'),
            ),
            ElevatedButton(
              onPressed: _streamData,
              child: const Text('Stream Data'),
            ),
          ],
        ),
      ),
    );
  }
}
