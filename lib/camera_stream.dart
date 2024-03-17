import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController frontController;
  late CameraController backController;
  late CameraController controller;

  void switchCamera() {
    if (controller == frontController) {
      setState(() {
        controller = backController;
      });
    } else {
      setState(() {
        controller = frontController;
      });
    }
    controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    frontController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    backController =
        CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller = frontController;
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).width * 1.33,
            child: CameraPreview(controller),
          ),
          IconButton(
              onPressed: () => switchCamera,
              icon: Icon(Icons.flip_camera_android))
        ],
      ),
    );
  }
}
