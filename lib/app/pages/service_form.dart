import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/app.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/components/buttons/buttons.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/components/formComponents/inputAnalyzer/field_analyzer.dart';
import 'package:gudsman_service/utils/converts.dart';
import 'package:gudsman_service/utils/dataClass/report/report_form.dart';
import 'package:gudsman_service/utils/http_req.dart';

final Map<String, List<Map<String, dynamic>>> serviceFormSchema = {
  "conditions_of": [
    {
      "label": "Date of Battery Change",
      "type": "date",
      "name": "date_of_battery_change",
      "required": true,
    },
    {
      "label": "Hours of Battery Change",
      "type": "number",
      "name": "hours_of_battery_change",
      "required": true,
    },
    {
      "label": "Date of Lubricating Oil Change",
      "type": "date",
      "name": "date_of_lubricating_oil_change",
      "required": true,
    },
    {
      "label": "Engine Lubricating Oil",
      "type": "number",
      "name": "engine_lubricating_oil",
      "required": true,
    },
    {
      "label": "Flywheel Ring & Starter Pinion Gear",
      "type": "text",
      "name": "customer_phone_number",
      "required": true,
    },
    {
      "label": "Anti Vibration Mounting Pad",
      "type": "textarea",
      "name": "anti_vibration_mounting_pad",
      "required": true,
    },
    {
      "label": "Belt for Radiator Fan and Charging Alternator",
      "type": "select",
      "defaultData": {
        "defaultList": [
          "OK",
          "Not OK",
        ],
      },
      "name": "belt_for_radiator_fan_and_charging_alternator",
      "required": true,
    },
    {
      "label": "Radiator Fins and Fans",
      "type": "radio",
      "defaultData": {
        "defaultList": [
          "OK",
          "Not OK",
        ],
      },
      "name": "radiator_fins_and_fans",
      "required": true,
    },
    {
      "label": "Water Hose Pipes",
      "type": "camera",
      "name": "water_hose_pipes",
      "required": true,
    },
    {
      "label": "Canopy body, Hinges, door Lock, etc",
      "type": "text",
      "name": "canopy_body_hinges_door_lock",
      "required": true,
    },
  ],
  "levels_of": [
    {
      "label": "Engine Lubricating Oil",
      "type": "number",
      "name": "engine_lubricating_oil",
      "required": true,
    },
    {
      "label": "Coolant  in Radiator & Balance Tank",
      "type": "text",
      "name": "coolant_in_radiator_and_balance_tank",
      "required": true,
    },
    {
      "label": "Battery Water",
      "type": "text",
      "name": "battery_water",
      "required": true,
    },
  ],
  "leakage_of": [
    {
      "label": "Diesel Pipes",
      "type": "text",
      "name": "diesel_pipes",
      "required": true,
    },
    {
      "label": "Lub. Oil pipes",
      "type": "text",
      "name": "lub_oil_pipes",
      "required": true,
    },
    {
      "label": "Water Pipes",
      "type": "text",
      "name": "water_pipes",
      "required": true,
    },
    {
      "label": "Air Pipes",
      "type": "text",
      "name": "air_pipes",
      "required": true,
    },
    {
      "label": "leakages",
      "type": "textarea",
      "name": "leakages",
      "required": true,
    },
  ],
  "fastners_of": [
    {
      "label": "Engine Coupling",
      "type": "text",
      "name": "engine_coupling",
      "required": true,
    },
    {
      "label": "Alternator Coupling",
      "type": "text",
      "name": "alternator_coupling",
      "required": true,
    },
    {
      "label": "Inlet and Exhaust Manifold",
      "type": "text",
      "name": "inlet_and_exhaust_manifold",
      "required": true,
    },
  ],
  "freeness_of": [
    {
      "label": "Flywheel",
      "type": "text",
      "name": "flywheel",
      "required": true,
    },
    {
      "label": "Turbo Charger Shaft",
      "type": "text",
      "name": "turbo_charger_shift",
      "required": true,
    },
  ],
  "wiring_systems_of": [
    {
      "label": "Battery Charging",
      "type": "text",
      "name": "battery_charging",
      "required": true,
    },
    {
      "label": "Engine and Control Panel Wiring",
      "type": "text",
      "name": "engine_and_control_panel_wiring",
      "required": true,
    },
  ],
  "check_for": [
    {
      "label": "External Battery Charger",
      "type": "text",
      "name": "external_battery_charger",
      "required": true,
    },
    {
      "label": "Battery Charger Serial No.",
      "type": "text",
      "name": "battery_charger_serial_no",
      "required": true,
    },
    {
      "label": "Air Ventilation",
      "type": "text",
      "name": "air_ventilation",
      "required": true,
    },
    {
      "label": "DG Set Earthing",
      "type": "text",
      "name": "dg_set_earthling",
      "required": true,
    },
  ],
  "cleaned/changed": [
    {
      "label": "Air Filter",
      "type": "text",
      "name": "air_filter",
      "required": true,
    },
    {
      "label": "Diesel Filter",
      "type": "text",
      "name": "diesel_filter",
      "required": true,
    },
    {
      "label": "Lubrication Oil Filter",
      "type": "text",
      "name": "lubricating_oil_filter",
      "required": true,
    },
    {
      "label": "Water Separator filter",
      "type": "text",
      "name": "water_separator_filter",
      "required": true,
    },
    {
      "label": "Feed Pump Strainer",
      "type": "text",
      "name": "feed_pump_strainer",
      "required": true,
    },
  ],
  "safety_devices_of": [
    {
      "label": "Low Lubricating Oil Pressure",
      "type": "text",
      "name": "low_lubricating_oil_pressure",
      "required": true,
    },
    {
      "label": "High Water Temperature",
      "type": "text",
      "name": "diesel_filter",
      "required": true,
    },
    {
      "label": "Lubrication Oil Filter",
      "type": "text",
      "name": "lubricating_oil_filter",
      "required": true,
    },
    {
      "label": "Water Separator filter",
      "type": "text",
      "name": "water_separator_filter",
      "required": true,
    },
    {
      "label": "Emergency Switch",
      "type": "text",
      "name": "emergency_switch",
      "required": true,
    },
  ],
  "load_trail_parameter": [
    {
      "label": "Time",
      "type": "text",
      "name": "time",
      "required": true,
    },
    {
      "label": "RPM",
      "type": "number",
      "name": "rpm",
      "required": true,
    },
    {
      "label": "Temp H20",
      "type": "text",
      "name": "temp_h20",
      "required": true,
    },
    {
      "label": "temp Oil",
      "type": "text",
      "name": "temp_oil",
      "required": true,
    },
    {
      "label": "Oil Press",
      "type": "text",
      "name": "oil_press",
      "required": true,
    },
    {
      "label": "Hz",
      "type": "number",
      "name": "hz",
      "required": true,
    },
    {
      "label": "P.F",
      "type": "text",
      "name": "p_f",
      "required": true,
    },
    {
      "label": "Volt RY",
      "type": "text",
      "name": "volt_ry",
      "required": true,
    },
    {
      "label": "Volt YB",
      "type": "number",
      "name": "volt_yb",
      "required": true,
    },
    {
      "label": "Volt BR",
      "type": "text",
      "name": "volt_br",
      "required": true,
    },
    {
      "label": "Amps R",
      "type": "text",
      "name": "amps_r",
      "required": true,
    },
    {
      "label": "Amps Y",
      "type": "text",
      "name": "apms_y",
      "required": true,
    },
    {
      "label": "Amps B",
      "type": "number",
      "name": "amps_b",
      "required": true,
    },
    {
      "label": "KW",
      "type": "text",
      "name": "kw",
      "required": true,
    },
    {
      "label": "Battery Voltage",
      "type": "text",
      "name": "battery_voltage",
      "required": true,
    },
  ],
  "report_end": [
    {
      "label": "Customer Photo",
      "type": "camera",
      "name": "customer_photo",
      "required": true,
    },
    {
      "label": "Customer Sign",
      "type": "signature",
      "name": "customer_sign",
      "required": true,
    },
    {
      "label": "Technician Photo",
      "type": "camera",
      "name": "technician_photo",
      "required": true,
    },
    {
      "label": "Technician Sign",
      "type": "signature",
      "name": "technician_sign",
      "required": true,
    },
    {
      "label": "Remarks",
      "type": "textarea",
      "name": "remarks",
      "required": true,
    }
  ]
};

final activeFormStageProvider = StateProvider.autoDispose<int>((ref) => 0);

final activeServiceProviderId = StateProvider<String>((ref) => '');

class ServiceFormScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final bool readOnly;

  const ServiceFormScreen(
      {super.key, required this.serviceId, this.readOnly = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceFormScreenState();
}

class _ServiceFormScreenState extends ConsumerState<ServiceFormScreen> {
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    int formStage = ref.watch(activeFormStageProvider);
    final maxPageLimit = serviceFormSchema.length - 1;
    final serviceReportsList = ref.watch(serviceReportListProvider);

    TextEditingController emailToSend = TextEditingController();

    String sectionTitle =
        serviceFormSchema.entries.map((e) => e.key).toList()[formStage];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        // scaffoldKey,
        appBar: CustomAppBar(
          title: serviceTypes[ref.read(reportTypeProvider)] ??
              'Field Service Report',
          actions: [
            if (widget.readOnly) ...[
              // IconButton(
              //     onPressed: () {
              //       Navigator.of(context).pushReplacement(MaterialPageRoute(
              //           builder: (context) => ServiceFormScreen(
              //                 serviceId: widget.serviceId,
              //               )));
              //     },
              //     icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showMyDialog(
                        ctx: context,
                        title: const Text('Mail Report'),
                        content: TextFormField(
                          controller: emailToSend,
                          decoration: const InputDecoration(
                              hintText: 'Enter Email Address'),
                        ),
                        onSubmit: () async {
                          HttpReq.post(
                              '/api/v1/${ref.watch(orgProvider)?.id}/field-service-report/${widget.serviceId}/mail',
                              {'email': emailToSend.text},
                              {},
                              authorized: true);
                        });
                  },
                  icon: const Icon(Icons.mail_rounded))
            ]
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: submitted
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          child: Text(
                            convertToEnglish(sectionTitle),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                            // scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: serviceFormSchema[serviceFormSchema
                                    .entries
                                    .map((e) => e.key)
                                    .toList()[formStage]]
                                ?.length,
                            itemBuilder: (context, index) {
                              dynamic value;
                              final Map<String, dynamic> schemaData =
                                  serviceFormSchema[serviceFormSchema.entries
                                          .map((e) => e.key)
                                          .toList()[formStage]]?[index] ??
                                      {};
                              final String fieldLabel = schemaData['label'];
                              final String fieldName = schemaData['name'];

                              final ServiceReport currentReport =
                                  serviceReportsList.firstWhere((element) =>
                                      element.serviceId == widget.serviceId);

                              if (currentReport.reportDetails[sectionTitle] !=
                                  null) {
                                value = currentReport
                                    .reportDetails[sectionTitle][fieldName];
                              }

                              final Key fieldKey = Key(
                                  '${serviceFormSchema.entries.map((e) => e.key).toList()[formStage]}-$fieldName');

                              return ListTile(
                                title: Text(fieldLabel),
                                subtitle: FieldAnalyzer(
                                  globalKey: fieldKey,
                                  serviceId: widget.serviceId,
                                  fieldName: fieldName,
                                  fieldValue: value,
                                  fieldLabel: '',
                                  fieldDescription: '',
                                  fieldId: fieldKey.toString(),
                                  fieldType: schemaData['type'],
                                  defaultData: schemaData['defaultData'] ?? {},
                                  readOnly: widget.readOnly,
                                ),
                              );
                            }),
                      ]),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (formStage != 0) ...[
                                    Expanded(
                                      child: CustomButton(
                                        text: 'Previous',
                                        onClick: () {
                                          ref
                                              .read(activeFormStageProvider
                                                  .notifier)
                                              .update((state) {
                                            if (state > 0) {
                                              return state - 1;
                                            }
                                            return state;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                  if (formStage == maxPageLimit &&
                                      !widget.readOnly) ...[
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                          text: 'Submit Report',
                                          onClick: () {
                                            showMyDialog(
                                                ctx: context,
                                                title:
                                                    const Text('Submit Report'),
                                                content: const Text(
                                                    'Do you want to Submit this report?'),
                                                onSubmit: () async {
                                                  setState(() {
                                                    submitted = true;
                                                  });
                                                  await ref
                                                      .read(
                                                          serviceReportListProvider
                                                              .notifier)
                                                      .publishServiceReport(
                                                          widget.serviceId)
                                                      .then((value) {
                                                    Navigator.of(context).pop();
                                                  });
                                                });
                                          }),
                                    ),
                                  ],
                                  if (formStage != maxPageLimit) ...[
                                    if (formStage != 0)
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    Expanded(
                                      child: CustomButton(
                                          text: 'Next',
                                          onClick: () {
                                            ref
                                                .read(activeFormStageProvider
                                                    .notifier)
                                                .update((state) {
                                              if (state < maxPageLimit) {
                                                return state + 1;
                                              }
                                              return state;
                                            });
                                          }),
                                    ),
                                  ],
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Future<void> showMyDialog({
  required BuildContext ctx,
  required Widget title,
  Widget? content,
  Function? onSubmit,
}) async {
  return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                content!,
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                onSubmit!();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
