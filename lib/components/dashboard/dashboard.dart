import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
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
    final serviceReportList = ref.watch(serviceReportListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
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
        const SizedBox(width: 20),
        const SizedBox(width: 20),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: serviceReportList.length,
          itemBuilder: (context, index) {
            return ReportBlock(report: serviceReportList[index]);
          },
        ),
        !serviceReportList.isNotEmpty
            ? Text('No Ongoing Report [Work in Progress]',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ))
            : const SizedBox(),
        // Center(
        //   child: ElevatedButton(
        //       onPressed: () {
        //         ref
        //             .read(serviceReportListProvider.notifier)
        //             .fetchServiceReports();

        //         // print(ref.watch(orgFetchProvider).value?.id);
        //       },
        //       child: const Text('Refresh Reports')),
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

class ReportBlock extends ConsumerStatefulWidget {
  const ReportBlock({
    super.key,
    required this.report,
  });

  final ServiceReport report;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportBlockState();
}

class _ReportBlockState extends ConsumerState<ReportBlock> {
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
