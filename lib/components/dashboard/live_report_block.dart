import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/app/pages/service_form.dart';
import 'package:gudsman_service/utils/dataClass/report/report_details.dart';

class TimerData {
  final DateTime startTime;
  final Timer timer;

  TimerData(this.startTime, this.timer);
}

final timerProvider = StateNotifierProvider<TimerNotifier, List<TimerData>>(
    (ref) => TimerNotifier());

class TimerNotifier extends StateNotifier<List<TimerData>> {
  TimerNotifier() : super([]);

  void addTimer(DateTime startTime) {
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.map((e) {
        if (e.startTime == startTime) {
          return TimerData(e.startTime, timer);
        } else {
          return e;
        }
      }).toList();
    });

    state = [...state, TimerData(startTime, timer)];
  }

  void removeTimer(DateTime startTime) {
    state = state.where((element) => element.startTime != startTime).toList();
  }

  @override
  void dispose() {
    state.forEach((timerData) {
      timerData.timer.cancel();
    });
    super.dispose();
  }
}

class LiveReportBlock extends ConsumerStatefulWidget {
  const LiveReportBlock({
    super.key,
    required this.serviceReportId,
    required this.customerName,
    required this.reportType,
    required this.startDate,
  });

  final String serviceReportId;
  final String customerName;
  final ReportTypes reportType;
  final DateTime startDate;

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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(widget.startDate);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ServiceFormScreen(serviceId: widget.serviceReportId)));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 32,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customerName,
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade800),
                      ),
                      Text(
                        serviceTypes[widget.reportType] ??
                            'Field Service Report',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${elapsedTime.inHours.toString().padLeft(2, '0')}:${(elapsedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
