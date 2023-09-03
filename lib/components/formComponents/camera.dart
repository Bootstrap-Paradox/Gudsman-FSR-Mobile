import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/cameraScreen/camera_screen.dart';

class CameraInput extends ConsumerStatefulWidget {
  const CameraInput(
      {super.key,
      required this.fieldLabel,
      required this.fieldValue,
      required this.globalKey,
      required this.onChanged});

  final String fieldLabel;
  final String fieldValue;
  final Key globalKey;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraInputState();
}

class _CameraInputState extends ConsumerState<CameraInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.fieldLabel,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
          ),
        ),
        if (widget.fieldValue != '')
          Image.file(
            File(widget.fieldValue),
            height: 100,
            width: 100,
          ),
        ElevatedButton(
          onPressed: () {
            // Open Camera Screen
            availableCameras().then((value) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewCameraScreen(
                        cameras: value,
                        onChanged: widget.onChanged,
                      )));
            });
          },
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey.shade400,
            // size: 100,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Take a photo',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
