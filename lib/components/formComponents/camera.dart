import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/cameraScreen/camera_screen.dart';
import 'package:intl/intl.dart';

class CameraInput extends ConsumerStatefulWidget {
  const CameraInput(
      {super.key,
      required this.fieldLabel,
      required this.fieldValue,
      required this.globalKey,
      required this.onChanged});

  final String fieldLabel;
  final Map<String, dynamic> fieldValue;
  final Key globalKey;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraInputState();
}

class _CameraInputState extends ConsumerState<CameraInput> {
  bool isExtendImage = false;

  void openCameraPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewCameraScreen(onChanged: widget.onChanged)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.fieldValue['value'] != null) ...[
          GestureDetector(
            onTap: () => setState(() {
              isExtendImage = !isExtendImage;
            }),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(widget.fieldValue['value'] ?? ''),
                width: isExtendImage ? MediaQuery.of(context).size.width : 100,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (widget.fieldValue['timestamp'] != null)
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(DateFormat('hh:mm a')
                        .format(widget.fieldValue['timestamp'] as DateTime)),
                    Text(DateFormat('dd MMM yyyy')
                        .format(widget.fieldValue['timestamp'] as DateTime)
                        .toString()),
                  ],
                ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 30,
            child: ElevatedButton(
                onPressed: () {
                  openCameraPage();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                child: const Text('Retake')),
          ),
        ] else
          ElevatedButton(
            onPressed: () {
              // Open Camera Screen
              openCameraPage();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              minimumSize: MaterialStateProperty.all(Size(100, 100)),
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey.shade400,
              // size: 100,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
