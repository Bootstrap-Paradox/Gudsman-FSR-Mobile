import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextInput extends ConsumerStatefulWidget {
  const TextInput(
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
  ConsumerState<ConsumerStatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends ConsumerState<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.globalKey,
      initialValue: widget.fieldValue,
      keyboardType: TextInputType.text,
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
      onChanged: (value) {
        widget.onChanged(value);
      },
    );
  }
}
