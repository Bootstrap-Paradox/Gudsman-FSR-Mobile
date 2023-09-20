import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateInput extends ConsumerStatefulWidget {
  const DateInput(
      {super.key,
      required this.globalKey,
      required this.fieldValue,
      required this.fieldLabel,
      required this.onChanged});

  final Key globalKey;
  final String fieldValue;
  final String fieldLabel;
  final Function(String value) onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DateInputState();
}

class _DateInputState extends ConsumerState<DateInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: DateTimeField(
          onDateSelected: (DateTime value) {
            widget.onChanged(value.toString());
          },
          dateFormat: DateFormat('dd-MM-yyyy'),
          decoration: InputDecoration(
            icon: const Icon(Icons.calendar_today),
            border: InputBorder.none,
            fillColor: Colors.grey.shade50,
          ),
          mode: DateTimeFieldPickerMode.date,
          selectedDate: widget.fieldValue != ''
              ? DateTime.parse(widget.fieldValue)
              : DateTime.now(),
        ),
      ),
    );
  }
}
