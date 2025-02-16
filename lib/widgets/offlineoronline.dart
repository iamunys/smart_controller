// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CounterStatusWidget extends StatefulWidget {
  final String motorId;

  const CounterStatusWidget({super.key, required this.motorId});

  @override
  _CounterStatusWidgetState createState() => _CounterStatusWidgetState();
}

class _CounterStatusWidgetState extends State<CounterStatusWidget> {
  int? _currentCounter;
  DateTime? _lastUpdateTime;
  bool _isCounterActive = false;
  StreamSubscription<DatabaseEvent>? _counterSubscription;
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _setupCounterStream();
  }

  void _setupCounterStream() {
    DatabaseReference counterRef =
        FirebaseDatabase.instance.ref('deviceStatus/${widget.motorId}/counter');

    _counterSubscription = counterRef.onValue.listen((event) {
      if (!mounted) return; // Prevent calling setState after dispose

      final data = event.snapshot.value;
      int? parsedCounter;

      if (data is String) {
        parsedCounter = int.tryParse(data);
      } else if (data is int) {
        parsedCounter = data;
      }

      if (parsedCounter != null) {
        setState(() {
          _currentCounter = parsedCounter;
          _lastUpdateTime = DateTime.now();
          _checkCounterStatus();
        });
      }
    });

    // Periodic timer to check counter status
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        _checkCounterStatus();
      }
    });
  }

  void _checkCounterStatus() {
    if (_lastUpdateTime != null) {
      final timeSinceLastUpdate = DateTime.now().difference(_lastUpdateTime!);

      if (mounted) {
        setState(() {
          _isCounterActive = timeSinceLastUpdate.inSeconds < 2;
        });
      }
    }
  }

  @override
  void dispose() {
    _counterSubscription?.cancel(); // Cancel Firebase listener
    _statusCheckTimer?.cancel(); // Cancel the periodic timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _isCounterActive ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isCounterActive ? 'Online' : 'Offline',
              style: TextStyle(
                color: _isCounterActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
