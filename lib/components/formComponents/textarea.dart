import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextareaInput extends ConsumerStatefulWidget {
  const TextareaInput(
      {super.key,
      required this.globalKey,
      required this.fieldLabel,
      required this.fieldValue,
      required this.onChanged});

  final Key globalKey;
  final String fieldLabel;
  final String fieldValue;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextareaInputState();
}

class _TextareaInputState extends ConsumerState<TextareaInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        widget.onChanged(value);
      },
      maxLines: 3,
      initialValue: widget.fieldValue,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Colors.grey.shade300, style: BorderStyle.solid)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
              color: Colors.grey.shade200, style: BorderStyle.solid, width: 6),
        ),
        labelText: widget.fieldLabel,
      ),
    );
  }
}
