import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/utils/dataClass/report/report_details.dart';
import 'package:gudsman_service/utils/http_req.dart';

import 'package:http/http.dart' as http;

class ServiceReport {
  const ServiceReport({
    required this.serviceId,
    required this.customerName,
    required this.status,
    required this.serviceType,
    required this.reportDetails,
    required this.itemName,
    required this.itemId,
    required this.startTime,
    this.endTime,
  });

  final String serviceId;
  final String customerName;
  final String itemId;
  final String itemName;
  final String status;
  final DateTime startTime;
  final DateTime? endTime;
  final ReportTypes serviceType;
  final Map<String, dynamic> reportDetails;
}

class ServiceReportList extends StateNotifier<List<ServiceReport>> {
  ServiceReportList(this.orgId, List<ServiceReport>? initialServiceReports)
      : super(initialServiceReports ?? []) {
    fetchServiceReports();
  }

  // String orgId;
  final String orgId;

  Future<String> newServiceReport(
      ReportTypes reportType, Map<String, dynamic> reportDetails) async {
    final http.Response response = await HttpReq.post(
        '/api/v1/$orgId/field-service-report',
        {
          ...reportDetails,
          'service_type': reportType.toString().split('.').last,
        },
        {},
        authorized: true);

    final Map<String, dynamic> responseBody = json.decode(response.body);

    final ServiceReport newReport = ServiceReport(
        serviceId: responseBody['service_id'] ?? '12345678',
        status: responseBody['service_status'],
        itemId: responseBody['item_id'] ?? '',
        itemName: responseBody['item_name'] ?? '',
        startTime: DateTime.now(),
        customerName: reportDetails['customer_name'] ?? 'testing Feature',
        serviceType: reportType,
        reportDetails: reportDetails);

    state = [
      ...state,
      newReport,
    ];
    return responseBody['service_id'];
  }

  void fetchServiceReports() async {
    final List<ServiceReport> reports = await getServiceReportDetails(orgId);
    state = reports;
  }

  void deleteServiceReport(String serviceId) {
    state = [
      for (final serviceReport in state)
        if (serviceReport.serviceId != serviceId) serviceReport,
    ];
  }

  Future<void> publishServiceReport(String serviceId) async {
    final response = await HttpMultiPartReq.multipart(
        method: 'put',
        path: '/api/v1/$orgId/field-service-report',
        body: state
            .firstWhere((element) => element.serviceId == serviceId)
            .reportDetails);

    // final responseBody = await json.decode(response.stream);
    await for (var chunk in response.stream.transform(utf8.decoder)) {
      print(chunk);
    }

    // state = [
    //   for (final report in state)
    //     if (report.serviceId == serviceId)
    //       ServiceReport(
    //           serviceId: report.serviceId,
    //           itemId: report.itemId,
    //           itemName: report.itemName,
    //           status: 'complete',
    //           endTime: DateTime.parse(responseBody['endTime']),
    //           customerName: report.customerName,
    //           startTime: report.startTime,
    //           serviceType: report.serviceType,
    //           reportDetails: report.reportDetails)
    //     else
    //       report
    // ];
  }

  void updateServiceReport(
      String serviceId, String sectionTitle, String fieldName, dynamic value) {
    state = [
      for (final report in state)
        if (report.serviceId == serviceId)
          ServiceReport(
              serviceId: report.serviceId,
              itemId: report.itemId,
              itemName: report.itemName,
              status: report.status,
              customerName: report.customerName,
              startTime: report.startTime,
              serviceType: report.serviceType,
              reportDetails: {
                ...report.reportDetails,
                sectionTitle: {
                  ...report.reportDetails[sectionTitle] ?? {},
                  fieldName: value,
                }
              })
        else
          report
    ];
  }
}

Future<List<ServiceReport>> getServiceReportDetails(String orgId) async {
  http.Response response = await HttpReq.get(
      path: '/api/v1/$orgId/field-service-report',
      headers: {},
      authorized: true);

  // print(response.body);

  final Map<String, dynamic> responseBody = json.decode(response.body);

  final List<dynamic> reports = responseBody['service_reports'];
  final List<ServiceReport> serviceReports = reports
      .map((e) => ServiceReport(
          serviceId: e['service_id'],
          itemId: e['item_id'] ?? '',
          itemName: e['item_name'] ?? '',
          status: e['service_status'],
          customerName: e['customer_name'],
          startTime: DateTime.parse(e['start_date']),
          endTime: e['end_date'] != null ? DateTime.parse(e['end_date']) : null,
          serviceType: ReportTypes.values.firstWhere((element) {
            return element.toString().split('.').last == e['service_type'];
          }),
          reportDetails: e['report_details'] ?? {}))
      .toList();
  return serviceReports;
}
