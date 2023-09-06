import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/custom_appbar.dart';

class NewCameraScreen extends ConsumerStatefulWidget {
  const NewCameraScreen({super.key, required this.onChanged});

  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCameraScreenState();
}

class _NewCameraScreenState extends ConsumerState<NewCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  // void _initializeCamera() async {
  //   _availableCameras = availableCameras();
  //   _controller = await CameraController(_availableCameras[0], resolutionPreset)
  // }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gudsman Service',
      ),
      body: FutureBuilder(
          future: _initializeCamera(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            widget.onChanged(image.path);

            await Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      DisplayCameraPictureScreen(
                          onChanged: widget.onChanged, imagePath: image.path),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DisplayCameraPictureScreen extends ConsumerWidget {
  const DisplayCameraPictureScreen(
      {super.key, required this.onChanged, required this.imagePath});

  final Function(String path) onChanged;
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Gudsman Reports'),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(2);
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        NewCameraScreen(onChanged: onChanged),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
                },
                child: const Icon(Icons.repeat),
              ),
            ],
          )
        ],
      ),
    );
  }
}
