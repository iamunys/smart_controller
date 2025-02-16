class MotorModel {
  final String deviceId;
  final String deviceName;
  final int motorControl;
  final int motorStatus;
  final String userId;
  final String energyConsume;
  final String waterLevel;
  final String current;
  final String power;
  final String voltage;
  final String pumpingTime;
  // Add other fields as needed
  final int enableTimer1;
  final int enableTimer2;
  final int enableTimer3;
  final String onTime1;
  final String onTime2;
  final String onTime3;
  final String onDuration1;
  final String onDuration2;
  final String onDuration3;
  final int timer1Done;
  final int timer2Done;
  final int timer3Done;

  MotorModel(
      {required this.deviceId,
      required this.deviceName,
      required this.motorControl,
      required this.motorStatus,
      required this.userId,
      required this.waterLevel,
      required this.energyConsume,
      required this.current,
      required this.power,
      required this.voltage,
      required this.pumpingTime,
      required this.enableTimer1,
      required this.enableTimer2,
      required this.enableTimer3,
      required this.onTime1,
      required this.onTime2,
      required this.onTime3,
      required this.onDuration1,
      required this.onDuration2,
      required this.onDuration3,
      required this.timer1Done,
      required this.timer2Done,
      required this.timer3Done});

  factory MotorModel.fromMap(String deviceId, Map<dynamic, dynamic> map) {
    return MotorModel(
      deviceId: deviceId,
      deviceName: map['deviceName'] ?? '',
      motorControl: map['motorControl'] ?? 0,
      motorStatus: map['motorStatus'] ?? 0,
      userId: map['userId'] ?? '',
      waterLevel: (map['waterLevel'] as String?) ?? 'low',
      energyConsume: map['energy']?.toString() ?? '0',
      current: map['currentValue']?.toString() ?? '0',
      power: map['power']?.toString() ?? '0',
      voltage: map['voltage']?.toString() ?? '0',
      pumpingTime: map['pumpingTime']?.toString() ?? '0',
      enableTimer1: map['enableTimer1'] ?? 0,
      enableTimer2: map['enableTimer2'] ?? 0,
      enableTimer3: map['enableTimer3'] ?? 0,
      onTime1: map['onTime1']?.toString() ?? '0',
      onTime2: map['onTime2']?.toString() ?? '0',
      onTime3: map['onTime3']?.toString() ?? '0',
      onDuration1: map['onDuration1']?.toString() ?? '0',
      onDuration2: map['onDuration2']?.toString() ?? '0',
      onDuration3: map['onDuration3']?.toString() ?? '0',
      timer1Done: map['timer1Done'] ?? 0,
      timer2Done: map['timer2Done'] ?? 0,
      timer3Done: map['timer3Done'] ?? 0,
    );
  }
}
