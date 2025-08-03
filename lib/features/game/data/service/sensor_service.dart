import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final StreamController<bool> _shakeController =
      StreamController<bool>.broadcast();
  Stream<bool> get shakeStream => _shakeController.stream;

  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      final acceleration =
          (event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15) {
        _shakeController.add(true);
      }
    });
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
  }

  void dispose() {
    stopListening();
    _shakeController.close();
  }
}
