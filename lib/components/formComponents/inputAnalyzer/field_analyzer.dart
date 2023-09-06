import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
import "package:gudsman_service/components/formComponents/camera.dart";
import "package:gudsman_service/components/formComponents/number.dart";
import "package:gudsman_service/components/formComponents/radio.dart";
import "package:gudsman_service/components/formComponents/select.dart";
import "package:gudsman_service/components/formComponents/text.dart";
import "package:gudsman_service/components/formComponents/textarea.dart";

class FieldAnalyzer extends ConsumerStatefulWidget {
  final Key globalKey;
  final String fieldName;
  final String fieldLabel;
  final String fieldId;
  final String fieldType;
  final String fieldDescription;
  final Map<String, dynamic> defaultData;
  final dynamic fieldValue;
  final String serviceId;

  const FieldAnalyzer(
      {super.key,
      required this.globalKey,
      required this.serviceId,
      required this.fieldName,
      required this.fieldLabel,
      required this.fieldId,
      required this.fieldType,
      required this.fieldDescription,
      required this.defaultData,
      required this.fieldValue});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FieldAnalyzerState();
}

class _FieldAnalyzerState extends ConsumerState<FieldAnalyzer> {
  void updateFields(dynamic updateValue, formStage) {
    ref.read(serviceReportListProvider.notifier).updateServiceReport(
        widget.serviceId,
        serviceFormSchema.entries.map((e) => e.key).toList()[formStage],
        widget.fieldName,
        updateValue);
  }

  @override
  Widget build(BuildContext context) {
    final formStage = ref.watch(activeFormStageProvider);

    if (widget.fieldType == 'text') {
      return TextInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? '',
        onChanged: (value) {
          updateFields(value, formStage);
        },
      );
    }

    if (widget.fieldType == 'number') {
      return NumberInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? '',
        onChanged: (value) {
          updateFields(value, formStage);
        },
      );
    }

    if (widget.fieldType == 'textarea') {
      return TextareaInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? '',
        onChanged: (value) {
          updateFields(value, formStage);
        },
      );
    }

    if (widget.fieldType == 'select') {
      return SelectInput(
          globalKey: widget.globalKey,
          fieldValue: widget.fieldValue ?? '',
          fieldLabel: widget.fieldLabel,
          onChanged: (value) {
            updateFields(value, formStage);
          },
          items: widget.defaultData['defaultList']);
    }

    if (widget.fieldType == 'radio') {
      return RadioInput(
        items: widget.defaultData['defaultList'],
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? '',
        onChanged: (value) {
          updateFields(value, formStage);
        },
      );
    }

    if (widget.fieldType == 'camera') {
      return CameraInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue?['value'] ?? '',
        onChanged: (String value) {
          updateFields({
            'type': 'image',
            'value': value,
          }, formStage);
        },
      );
    }

    return Container(
      key: widget.globalKey,
      child: Column(
        children: [
          Text(widget.fieldName),
          Text(widget.fieldLabel),
          Text(widget.fieldType),
          Text(widget.fieldDescription),
        ],
      ),
    );
  }
}
