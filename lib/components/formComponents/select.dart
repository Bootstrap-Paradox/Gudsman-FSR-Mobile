import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectInput extends ConsumerStatefulWidget {
  const SelectInput(
      {super.key,
      required this.items,
      required this.globalKey,
      required this.fieldLabel,
      required this.fieldValue,
      required this.onChanged});

  final Key globalKey;
  final List<String> items;
  final String fieldLabel;
  final String fieldValue;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectInputState();
}

class _SelectInputState extends ConsumerState<SelectInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldLabel,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11,
          ),
        ),
        DropdownSearch(
          key: widget.globalKey,
          selectedItem: widget.fieldValue,
          dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
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
                  color: Colors.grey.shade200,
                  style: BorderStyle.solid,
                  width: 6),
            ),
          )),
          items: widget.items,
          onChanged: (value) {
            widget.onChanged(value ?? '');
          },
        ),
      ],
    );
  }
}
