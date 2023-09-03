class ReportWorkFlowDetails {
  static late String reportId;
  static late String reportName;
  static late String customerId;
  static late String customerName;

  factory ReportWorkFlowDetails() => ReportWorkFlowDetails._internal();
  ReportWorkFlowDetails._internal();
}

enum ReportTypes {
  maintenance,
  repair,
  installation,
  inspection,
  incident,
  other,
}
