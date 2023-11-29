import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  /// This will auto start the listening process.
  late final ShakeDetector detector = ShakeDetector.autoStart(
    onPhoneShake: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shake!')),
      );
      // Do stuff on phone shake
    },
    minimumShakeCount: 1,
    shakeSlopTimeMS: 500,
    shakeCountResetTime: 3000,
    shakeThresholdGravity: 2.7,
  );

  @override
  void dispose() {
    // To close: detector.stopListening();
    detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
