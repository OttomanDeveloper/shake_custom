library shake;

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Callback for phone shakes
typedef PhoneShakeCallback = void Function();

/// ShakeDetector class for phone shake functionality
class ShakeDetector {
  // Callback for phone shake
  final PhoneShakeCallback onPhoneShake;

  // Shake detection threshold
  final double shakeThresholdGravity;

  // Minimum time between shakes
  final int shakeSlopTimeMS;

  // Time before shake count resets
  final int shakeCountResetTime;

  // Number of shakes required before shake is triggered
  final int minimumShakeCount;

  // Private variables
  int _shakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int _shakeCount = 0;

  // StreamSubscription for Accelerometer events
  StreamSubscription? _streamSubscription;

  // Constructor for waiting until startListening is called
  ShakeDetector.waitForStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
    this.minimumShakeCount = 1,
  });

  // Constructor for automatically starting listening
  ShakeDetector.autoStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
    this.minimumShakeCount = 1,
  }) {
    startListening();
  }

  // Start listening to accelerometer events
  void startListening() {
    _streamSubscription =
        accelerometerEventStream().listen(_handleAccelerometerEvent);
  }

  // Stop listening to accelerometer events
  void stopListening() {
    _streamSubscription?.cancel();
  }

  // Handle accelerometer events
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    final double gX = x / 9.80665;
    final double gY = y / 9.80665;
    final double gZ = z / 9.80665;

    // Calculate gForce
    final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

    if (gForce > shakeThresholdGravity) {
      final int now = DateTime.now().millisecondsSinceEpoch;

      // Ignore shake events too close to each other (500ms)
      if (_shakeTimestamp + shakeSlopTimeMS > now) {
        return;
      }

      // Reset the shake count after 3 seconds of no shakes
      if (_shakeTimestamp + shakeCountResetTime < now) {
        _shakeCount = 0;
      }

      _shakeTimestamp = now;
      _shakeCount++;

      // Trigger onPhoneShake when the required shake count is reached
      if (_shakeCount >= minimumShakeCount) {
        onPhoneShake();
      }
    }
  }
}
