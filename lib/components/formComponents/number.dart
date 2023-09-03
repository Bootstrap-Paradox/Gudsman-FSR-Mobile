import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberInput extends ConsumerStatefulWidget {
  const NumberInput(
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
  ConsumerState<ConsumerStatefulWidget> createState() => _NumberInputState();
}

class _NumberInputState extends ConsumerState<NumberInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.globalKey,
      initialValue: widget.fieldValue,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        widget.onChanged(value);
      },
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

class NumberInputButton extends ConsumerWidget {
  const NumberInputButton(
      {super.key, required this.icon, required this.onPressed});
  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            )),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          ),
          child: icon),
    );
  }
}
