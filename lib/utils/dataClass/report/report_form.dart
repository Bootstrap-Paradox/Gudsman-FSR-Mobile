import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/utils/dataClass/report/report_details.dart';
import 'package:gudsman_service/utils/http_req.dart';

import 'package:http/http.dart' as http;

class ServiceReport {
  const ServiceReport({
    required this.serviceId,
    required this.customerName,
    required this.serviceType,
    required this.reportDetails,
    required this.startTime,
  });

  final String serviceId;
  final String customerName;
  final DateTime startTime;
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
        '/api/v1/${orgId}/field-service-report',
        {
          ...reportDetails,
          'service_type': reportType.toString().split('.').last,
        },
        {},
        authorized: true);

    final Map<String, dynamic> responseBody = json.decode(response.body);

    state = [
      ...state,
      ServiceReport(
          serviceId: responseBody['service_id'] ?? '12345678',
          startTime: DateTime.now(),
          customerName: reportDetails['customer_name'] ?? 'testing Feature',
          serviceType: reportType,
          reportDetails: reportDetails)
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

  void publishServiceReport() {}

  void updateServiceReport(
      String serviceId, String sectionTitle, String fieldName, dynamic value) {
    state = [
      for (final report in state)
        if (report.serviceId == serviceId)
          ServiceReport(
              serviceId: report.serviceId,
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
      path: '/api/v1/$orgId/field-service-report?active=true',
      headers: {},
      authorized: true);

  // print(response.body);

  final Map<String, dynamic> responseBody = json.decode(response.body);

  final List<dynamic> reports = responseBody['service_reports'];
  final List<ServiceReport> serviceReports = reports
      .map((e) => ServiceReport(
          serviceId: e['service_id'],
          customerName: e['customer_name'],
          startTime: DateTime.parse(e['start_date']),
          serviceType: ReportTypes.values.firstWhere((element) {
            return element.toString().split('.').last == e['service_type'];
          }),
          reportDetails: e['report_details'] ?? {}))
      .toList();
  return serviceReports;
}
