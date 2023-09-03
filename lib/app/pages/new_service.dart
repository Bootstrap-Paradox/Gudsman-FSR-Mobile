import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/components/formComponents/fetch_select.dart';
import 'package:gudsman_service/utils/dataClass/customer.dart';
import 'package:gudsman_service/utils/dataClass/report/report_details.dart';
import 'package:gudsman_service/utils/http_req.dart';
import 'package:http/http.dart' as http;

final reportTypeProvider =
    StateProvider<ReportTypes>((ref) => ReportTypes.maintenance);

final Map<ReportTypes, String> serviceTypes = {
  ReportTypes.maintenance: 'Maintainance Report',
  ReportTypes.incident: 'Incident Report',
  ReportTypes.inspection: 'Inspection Report',
  ReportTypes.installation: 'Installation Report',
  ReportTypes.other: 'Other',
  ReportTypes.repair: 'Repair Reports',
};

class NewServiceScreen extends ConsumerStatefulWidget {
  const NewServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewServiceScreenState();
}

class FieldSelect {
  FieldSelect({required this.id, required this.name});
  String id;
  String name;
}

class _NewServiceScreenState extends ConsumerState<NewServiceScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  FieldSelect customerSelect = FieldSelect(id: '', name: '');
  FieldSelect itemSelect = FieldSelect(id: '', name: '');

  @override
  Widget build(BuildContext context) {
    final reportType = ref.watch(reportTypeProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'New Service Report', actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // do something
            },
          )
        ]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownSearch(
                    items: serviceTypes.entries.map((e) => e.value).toList(),
                    selectedItem: serviceTypes[ref.read(reportTypeProvider)],
                    onChanged: (value) {
                      ref.read(reportTypeProvider.notifier).update((state) =>
                          serviceTypes.keys.firstWhere(
                              (element) => serviceTypes[element] == value));
                    },
                  ),
                  // Field for Report Type
                  const SizedBox(height: 20),

                  FetchSelect(
                      fetchFor: 'Customer',
                      elementIdKey: 'customer_id',
                      elementDisplayKey: 'customer_display_name',
                      asyncItemsFetch: (filter) async {
                        final orgData = ref.watch(orgProvider);
                        final response = await HttpReq.get(
                          path:
                              '/api/v1/${orgData?.id}/customer?search=$filter',
                          authorized: true,
                        );
                        return await json.decode(response.body)['customers'];
                      },
                      onChanged: (value) {
                        customerSelect.id = value['customer_id'];
                        customerSelect.name = value['customer_display_name'];
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  FetchSelect(
                      fetchFor: 'Item',
                      elementIdKey: 'item_id',
                      elementDisplayKey: '_name',
                      asyncItemsFetch: (filter) async {
                        final orgData = ref.watch(orgProvider);
                        final response = await HttpReq.get(
                          path: '/api/v1/${orgData?.id}/item?search=$filter',
                          authorized: true,
                        );
                        final responseBody = json.decode(response.body);
                        // print(responseBody);
                        return responseBody['items'];
                        // return [];
                      },
                      onChanged: (value) {
                        itemSelect.id = value['item_id'];
                        itemSelect.name = value['_name']['value'];
                      }),
                  const SizedBox(height: 20),
                  TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                      )),

                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) =>
                                  Colors.blue.shade700),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )),
                      child: const Text(
                        'Start Report Workflow',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        // Navigator.pushReplacement(context, );

                        ref
                            .read(serviceReportListProvider.notifier)
                            .newServiceReport(reportType, {
                          'customer_name': customerSelect.name,
                          'customer_id': customerSelect.id,
                          'item_id': itemSelect.id,
                          'item_name': itemSelect.name,
                          'service_location': locationController.text,
                        }).then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return ServiceFormScreen(
                                serviceId: value,
                              );
                            },
                          ));
                        });
                      }),
                  const SizedBox(height: 20),
                  const Text(
                    'Note: Reports are Time Tracked',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 20),
        //   child: ButtonTheme(
        //     minWidth: 600.0,
        //     height: 100.0,
        //     child: ElevatedButton(
        //       style: ButtonStyle(
        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //             RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.0),
        //         )),
        //       ),
        //       onPressed: () {},
        //       child: const Text("Submit Report"),
        //     ),
        //   ),
        // )
      ),
    );
  }
}

// Future<List<CustomerModel>> fetchCustomers(dynamic filter) async {
//   if (filter == '') {
//     return [];
//   }

//   final response = await HttpReq.get(
//       '/api/v1/64370043e7e4cb9245f564a9/customer?search=', {},
//       authorized: true);

//   final List<dynamic> customers = response['customers'];
//   // print(customers);
//   return customers
//       .map((customer) => CustomerModel(
//             id: customer['id'],
//             displayName: customer['display_name'],
//             customerData: customer,
//           ))
//       .toList();
// }
