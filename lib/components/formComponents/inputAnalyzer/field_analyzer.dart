import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
import "package:gudsman_service/components/formComponents/camera.dart";
import "package:gudsman_service/components/formComponents/date_input.dart";
import "package:gudsman_service/components/formComponents/number.dart";
import "package:gudsman_service/components/formComponents/radio.dart";
import "package:gudsman_service/components/formComponents/select.dart";
import "package:gudsman_service/components/formComponents/signature_pad.dart";
import "package:gudsman_service/components/formComponents/text.dart";
import "package:gudsman_service/components/formComponents/textarea.dart";
import "package:intl/intl.dart";

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
  final bool? disabled;
  final bool? required;
  final bool? readOnly;

  const FieldAnalyzer({
    super.key,
    required this.globalKey,
    required this.serviceId,
    required this.fieldName,
    required this.fieldLabel,
    required this.fieldId,
    required this.fieldType,
    required this.fieldDescription,
    required this.defaultData,
    required this.fieldValue,
    this.disabled,
    this.required,
    this.readOnly,
  });

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

    if (widget.readOnly == true) {
      // for read only fields

      if (widget.fieldType == 'camera' || widget.fieldType == 'signature') {
        bool isExtendImage = false;
        return Container(
          key: widget.globalKey,
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            // border: Border.all(
            //   color: Colors.grey[300]!,
            // ),
            // color: Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.fieldValue?['value'] != null) ...[
                if (widget.fieldValue['value']
                    .toString()
                    .startsWith('https://'))
                  GestureDetector(
                    onTap: () => setState(() {
                      isExtendImage = !isExtendImage;
                    }),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.fieldValue['value'],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? imageProgress) {
                        if (imageProgress == null) {
                          return child;
                        }
                        return SizedBox(
                          height: 60,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: imageProgress.expectedTotalBytes != null
                                  ? imageProgress.cumulativeBytesLoaded /
                                      imageProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      }, width: MediaQuery.of(context).size.width),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() {
                      isExtendImage = !isExtendImage;
                    }),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(widget.fieldValue['value'],
                          width: MediaQuery.of(context).size.width),
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
                          Text(DateFormat('hh:mm a').format(
                              widget.fieldValue['timestamp'].runtimeType ==
                                      DateTime
                                  ? widget.fieldValue['timestamp']
                                  : DateTime.parse(
                                      widget.fieldValue['timestamp']))),
                          Text(DateFormat('dd MMM yyyy').format(
                              widget.fieldValue['timestamp'].runtimeType ==
                                      DateTime
                                  ? widget.fieldValue['timestamp']
                                  : DateTime.parse(
                                      widget.fieldValue['timestamp']))),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
              ] else
                const Text('No Image Clicked'),
            ],
          ),
        );
      }

      return Container(
        key: widget.globalKey,
        constraints: const BoxConstraints(
          minHeight: 50,
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.fieldValue != null ? widget.fieldValue.toString() : '-',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
        ),
      );
    }

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

    if (widget.fieldType == 'date') {
      return DateInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? '',
        onChanged: (value) {
          updateFields(value, formStage);
        },
      );
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

    if (widget.fieldType == 'signature') {
      // debugPrint(widget.fieldValue);
      return SignaturePadInput(
        globalKey: widget.globalKey,
        fieldLabel: 'Signature',
        fieldValue: widget.fieldValue ?? {},
        onChanged: (value) {
          updateFields({
            'type': 'signature',
            'value': value,
            'timestamp': DateTime.now(),
          }, formStage);
        },
      );
    }

    if (widget.fieldType == 'camera') {
      return CameraInput(
        globalKey: widget.globalKey,
        fieldLabel: widget.fieldLabel,
        fieldValue: widget.fieldValue ?? {},
        onChanged: (String value) {
          updateFields({
            'type': 'image',
            'value': value,
            'timestamp': DateTime.now(),
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
