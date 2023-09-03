import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioInput extends ConsumerStatefulWidget {
  const RadioInput(
      {super.key,
      required this.items,
      required this.fieldLabel,
      required this.fieldValue,
      required this.onChanged});

  final List<String> items;
  final String fieldLabel;
  final String fieldValue;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RadioInputState();
}

class _RadioInputState extends ConsumerState<RadioInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // shrinkWrap: true,
      children: [
        Text(
          widget.fieldLabel,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
        for (var item in widget.items)
          RadioListTile(
              title: Text(item),
              value: item,
              groupValue: widget.fieldValue,
              onChanged: (value) {
                widget.onChanged(value ?? '');
              })
      ],
    );
  }
}
