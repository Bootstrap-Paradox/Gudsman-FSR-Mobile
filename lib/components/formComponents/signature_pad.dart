import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignaturePadInput extends ConsumerStatefulWidget {
  const SignaturePadInput(
      {super.key,
      required this.globalKey,
      required this.fieldValue,
      required this.fieldLabel,
      required this.onChanged});

  final Key globalKey;
  final dynamic fieldValue;
  final String fieldLabel;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignaturePadInputState();
}

class _SignaturePadInputState extends ConsumerState<SignaturePadInput> {
  ByteData? _img = ByteData(0);
  final _sign = GlobalKey<SignatureState>();
  var strokeWidth = 5.0;
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 320.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Signature(
            color: Colors.black, // Color of the drawing path
            strokeWidth: 5.0, // with
            backgroundPainter:
                null, // Additional custom painter to draw stuff like watermark
            // onSign: () {
            //   final signatureCanvas = GlobalKey<SignatureState>();
            //   final signature = signatureCanvas.currentState;
            //   // final signatureImage = signature!.
            //   // print(signatureImage);
            // }, // Callback called on user pan drawing
            key:
                _sign, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Retrieve the current image with the help of the GlobalKey
              final signature = _sign.currentState;
              final image = await signature?.getData();
              var data = await image?.toByteData(format: ImageByteFormat.png);
              final encoded = base64.encode(data!.buffer.asUint8List());
              widget.onChanged(encoded);
            },
            child: const Text('Save'),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              // Retrieve the current image with the help of the GlobalKey
              // final signatureCanvas = GlobalKey<SignatureState>();
              final signature = _sign.currentState;
              signature!.clear();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    ]);
  }
}
