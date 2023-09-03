import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/custom_appbar.dart';

class NewCameraScreen extends ConsumerStatefulWidget {
  const NewCameraScreen(
      {super.key, required this.cameras, required this.onChanged});

  final List<CameraDescription> cameras;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCameraScreenState();
}

class _NewCameraScreenState extends ConsumerState<NewCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // availableCameras().then((cameras) {
    //   _controller = CameraController(cameras[0], ResolutionPreset.medium);
    //   _initializeControllerFuture = _controller.initialize();
    // });

    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);

    // _availableCameras = getCameras();

    // _controller =
    //     CameraController(_availableCameras[0], ResolutionPreset.medium);

    // // _initializeCamera();

    _initializeControllerFuture = _controller.initialize();
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
        context: context,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            widget.onChanged(image.path);

            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DisplayCameraPictureScreen(imagePath: image.path)));
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
  const DisplayCameraPictureScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gudsman Reports')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: ButtonBar(children: [
        FloatingActionButton(
          onPressed: () {
            // should pop twice
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        FloatingActionButton(onPressed: () {}, child: const Icon(Icons.repeat)),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
