import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
import 'package:gudsman_service/components/buttons/buttons.dart';
import 'package:gudsman_service/utils/dataClass/report/report_form.dart';

class DashboardComponent extends ConsumerStatefulWidget {
  const DashboardComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardComponentState();
}

class _DashboardComponentState extends ConsumerState<DashboardComponent> {
  @override
  Widget build(BuildContext context) {
    final activeReport = ref.watch(activeServiceReport);
    final recentReports = ref.watch(recentServiceReports);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        if (activeReport != null)
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Ongoing Report',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              LiveReportBlock(report: activeReport),
            ],
          ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Reports',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(width: 20),
        if (recentReports != null) ...[
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: recentReports.length,
            itemBuilder: (context, index) {
              return ReportBlock(report: recentReports[index]);
            },
          ),
        ] else
          const Center(
              child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('No recent reports'),
          )),
        // CustomButton(
        //   text: 'Fetch Reports',
        //   onClick: () {
        //     ref.read(serviceReportListProvider.notifier).fetchServiceReports();
        //   },
        // )
      ],
    );
  }
}

class DashboardInfoBlock extends StatefulWidget {
  final String title;
  final int value;
  const DashboardInfoBlock(
      {super.key, required this.title, required this.value});

  @override
  State<DashboardInfoBlock> createState() => _DashboardInfoBlockState();
}

class _DashboardInfoBlockState extends State<DashboardInfoBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
            ]),
      ),
    );
  }
}

class LiveReportBlock extends ConsumerStatefulWidget {
  const LiveReportBlock({
    super.key,
    required this.report,
  });

  final ServiceReport report;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LiveReportBlockState();
}

class _LiveReportBlockState extends ConsumerState<LiveReportBlock> {
  Duration elapsedTime = Duration.zero;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    if (widget.report.endTime == null) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          elapsedTime = DateTime.now().difference(widget.report.startTime);
        });
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF1E52A2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.report.customerName,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          serviceTypes[widget.report.serviceType] ??
                              'Field Service Report',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      widget.report.itemName == ''
                          ? 'Gudsman eFSR'
                          : widget.report.itemName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          widget.report.endTime == null
                              ? '${elapsedTime.inHours.toString().padLeft(2, '0')}:${(elapsedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}'
                              : widget.report.endTime
                                      ?.difference(widget.report.startTime)
                                      .toString() ??
                                  '',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceFormScreen(
                                        serviceId: widget.report.serviceId)));
                          },
                          style: ButtonStyle(
                            shape:
                                MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                          ),
                          child: const Text('Continue'))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportBlock extends ConsumerWidget {
  const ReportBlock({super.key, required this.report});

  final ServiceReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Container(
        // height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 6,
              blurRadius: 16,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          report.customerName,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C1C)),
                        ),
                        Text(
                          serviceTypes[report.serviceType] ??
                              'Field Service Report',
                          style: const TextStyle(
                              color: Color(0xFF42495B), fontSize: 14),
                        ),
                        if (report.itemName != '') ...[
                          const SizedBox(height: 10),
                          Text(
                            'Report of : ${report.itemName}',
                            style: const TextStyle(
                                color: Color(0xFF42495B), fontSize: 14),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 1.0),
                        child: Text(
                          report.endTime != null
                              ? '${report.endTime?.difference(report.startTime).inHours.toString()} hour, ${(report.endTime?.difference(report.startTime).inMinutes).toString()} min'
                              : '00:00',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 118, 127, 150)),
                        ),
                      ),
                      if (report.endTime != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 1.0),
                          child: Text(
                            '${report.endTime?.day.toString()}-${report.endTime?.month.toString()}-${report.endTime?.year.toString()}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 118, 127, 150)),
                          ),
                        ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
