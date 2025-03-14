class MotorModel {
  final String deviceId;
  final String lastUpdate;
  final String deviceName;
  final double motorControl;
  final double motorStatus;
  final double energyConsume;
  final String waterLevel;
  final double current;
  final double power;
  final double voltage;
  final double pumpingTime;
  final double enableTimer1;
  final double enableTimer2;
  final double enableTimer3;
  final double onTime1;
  final double onTime2;
  final double onTime3;
  final double onDuration1;
  final double onDuration2;
  final double onDuration3;
  final double timer1Done;
  final double timer2Done;
  final double timer3Done;
  final double last60Daysusage;
  final double autoOffTimer;

  MotorModel(
      {required this.deviceId,
      required this.lastUpdate,
      required this.deviceName,
      required this.motorControl,
      required this.motorStatus,
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
      required this.timer3Done,
      required this.last60Daysusage,
      required this.autoOffTimer});

  factory MotorModel.fromMap(String deviceId, Map<dynamic, dynamic> map) {
    return MotorModel(
      deviceId: deviceId,
      lastUpdate: map['lU'] ?? '',
      deviceName: map['dN'] ?? '',
      motorControl: (map['mC'] ?? 0).toDouble(),
      motorStatus: (map['mS'] ?? 0).toDouble(),
      waterLevel: (map['wL'] as String?) ?? 'low',
      energyConsume: (map['eG'] ?? 0).toDouble(),
      current: (map['cV'] ?? 0).toDouble(),
      power: (map['pW'] ?? 0).toDouble(),
      voltage: (map['vT'] ?? 0).toDouble(),
      pumpingTime: (map['pT'] ?? 0).toDouble(),
      enableTimer1: (map['eT1'] ?? 0).toDouble(),
      enableTimer2: (map['eT2'] ?? 0).toDouble(),
      enableTimer3: (map['eT3'] ?? 0).toDouble(),
      onTime1: (map['oT1'] ?? 0).toDouble(),
      onTime2: (map['oT2'] ?? 0).toDouble(),
      onTime3: (map['oT3'] ?? 0).toDouble(),
      onDuration1: (map['oD1'] ?? 0).toDouble(),
      onDuration2: (map['oD2'] ?? 0).toDouble(),
      onDuration3: (map['oD3'] ?? 0).toDouble(),
      timer1Done: (map['t1D'] ?? 0).toDouble(),
      timer2Done: (map['t2D'] ?? 0).toDouble(),
      timer3Done: (map['t3D'] ?? 0).toDouble(),
      last60Daysusage: (map['l60'] ?? 0).toDouble(),
      autoOffTimer: (map['aOF'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'lastUpdate': lastUpdate,
      'deviceName': deviceName,
      'enableTimer1': enableTimer1,
      'enableTimer2': enableTimer2,
      'enableTimer3': enableTimer3,
      'motorControl': motorControl,
      'motorStatus': motorStatus,
      'onDuration1': onDuration1,
      'onDuration2': onDuration2,
      'onDuration3': onDuration3,
      'onTime1': onTime1,
      'onTime2': onTime2,
      'onTime3': onTime3,
      'power': power,
      'pumpingTime': pumpingTime,
      'timer1Done': timer1Done,
      'timer2Done': timer2Done,
      'timer3Done': timer3Done,
      'voltage': voltage,
      'waterLevel': waterLevel,
      'last60Daysusage': last60Daysusage,
      'aOF': autoOffTimer
    };
  }
}
