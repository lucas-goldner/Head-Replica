import 'package:flutter/material.dart';
import 'package:flutter_airpods/flutter_airpods.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shark bro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Shark bro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Object shark;

  @override
  void initState() {
    shark = Object(fileName: "assets/shark.obj");
    shark.rotation.setValues(0, 90, 0);
    shark.updateTransform();
    super.initState();
  }

  void updateOrientation(DeviceMotionData? data) {
    if (data == null) {
      return;
    }

    int scaleFactor = 75;
    double pitch = data.attitude.pitch * scaleFactor as double;
    double yaw = data.attitude.yaw * scaleFactor as double;
    shark.rotation.setValues(-pitch / 2, 180, yaw);
    shark.updateTransform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Shark bro"),
      ),
      body: StreamBuilder<DeviceMotionData>(
        stream: FlutterAirpods.getAirPodsDeviceMotionUpdates,
        builder:
            (BuildContext context, AsyncSnapshot<DeviceMotionData> snapshot) {
          if (snapshot.hasData) {
            updateOrientation(snapshot.data);
            return Column(
              children: [
                const Text("Connected"),
                Expanded(
                  child: Cube(
                    onSceneCreated: (Scene scene) {
                      scene.world.add(shark);
                      scene.camera.zoom = 7;
                    },
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                const Text("Waiting for data..."),
                Expanded(
                  child: Cube(
                    onSceneCreated: (Scene scene) {
                      scene.world.add(shark);
                      scene.camera.zoom = 7;
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
