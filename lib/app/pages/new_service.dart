import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
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

class CustomerSelect {
  CustomerSelect({required this.id, required this.customerName});
  String id;
  String customerName;
}

class _NewServiceScreenState extends ConsumerState<NewServiceScreen> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  CustomerSelect customerSelect = CustomerSelect(id: '', customerName: '');

  @override
  Widget build(BuildContext context) {
    final reportType = ref.watch(reportTypeProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('New Service Report'), actions: [
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
                  DropdownSearch<CustomerModel>(
                    dropdownBuilder: (context, selectedItem) {
                      if (selectedItem == null) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Select Customer',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.account_circle,
                                color: Colors.grey.shade600),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedItem.displayName,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    // clearButtonProps: const ClearButtonProps(
                    //     isVisible: true),
                    compareFn: (item, selectedItem) {
                      return item.id == selectedItem.id;
                    },
                    popupProps: PopupProps.modalBottomSheet(
                      containerBuilder: (context, popupWidget) {
                        return Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                                // padding: EdgeInsets.only(right: 12),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Customers',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            const Divider(
                              thickness: 1,
                            ),
                            Flexible(
                              child: Container(
                                color: Colors.white,
                                child: popupWidget,
                              ),
                            ),
                          ],
                        );
                      },
                      modalBottomSheetProps: const ModalBottomSheetProps(
                        elevation: 0,
                        useSafeArea: true,
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      ),
                      showSearchBox: true,
                      showSelectedItems: true,
                      isFilterOnline: true,
                      // searchDelay: const Duration(milliseconds: 700),
                      emptyBuilder: (context, searchEntry) {
                        if (searchEntry == '') {
                          return Container(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Search to see Customers',
                                style: TextStyle(color: Colors.grey.shade600),
                              ));
                        }
                        return Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Customer $searchEntry not Found',
                              style: TextStyle(color: Colors.grey.shade600),
                            ));
                      },
                      searchFieldProps: TextFieldProps(
                        controller: customerController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          fillColor: Colors.grey.shade900,
                          labelText: 'Search',
                          isDense: true,
                          contentPadding: const EdgeInsets.all(12),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.grey,
                        ),
                      ),
                      itemBuilder:
                          (context, CustomerModel customer, isSelected) {
                        // print(item);
                        // print(item.customer_display_name);
                        return ListTile(
                          title: Text(customer.displayName),
                          subtitle: Text(customer.id),
                          trailing: isSelected
                              ? const Icon(Icons.check)
                              : const SizedBox(width: 0),
                        );
                      },
                    ),
                    // asyncItems: fetchCustomers(filter),
                    asyncItems: (String filter) async {
                      if (filter == '') {
                        return [];
                      }

                      final orgData = ref.watch(orgProvider);

                      http.Response response = await HttpReq.get(
                          path:
                              '/api/v1/${orgData?.id}/customer?search=$filter',
                          headers: {},
                          authorized: true);

                      final Map<String, dynamic> responseBody =
                          json.decode(response.body);

                      final List<dynamic> customers = responseBody['customers'];

                      if (customers.isEmpty) {
                        return [];
                      }

                      List<CustomerModel> customerList = customers
                          .map((customer) => CustomerModel(
                              id: customer['customer_id'],
                              displayName: customer['customer_display_name'],
                              customerData: customer))
                          .toList();

                      return customerList;
                    },
                    onChanged: (dynamic value) {
                      customerSelect.id = value.id;
                      customerSelect.customerName = value.displayName;
                    },
                    // selectedItem: 'Customer 1',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                      )),

                  const SizedBox(
                    height: 20,
                  ),
                  FetchSelect(
                      elementIdKey: 'customer_id',
                      elementDisplayKey: 'customer_display_name',
                      asyncItemsFetch: (filter) async {
                        return [];
                      },
                      onChanged: (value) {}),

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
                          'customer_name': customerSelect.customerName,
                          'customer_id': customerSelect.id,
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
