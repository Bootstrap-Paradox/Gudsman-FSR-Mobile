import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/components/dashboard/dashboard.dart';

class RecentReportsComponent extends ConsumerStatefulWidget {
  const RecentReportsComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecentReportsComponentState();
}

class _RecentReportsComponentState
    extends ConsumerState<RecentReportsComponent> {
  @override
  Widget build(BuildContext context) {
    final recentServiceList = ref.watch(recentServiceReports);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Reports'),
              Text('View All'),
            ],
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: recentServiceList!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ReportBlock(report: recentServiceList[index]);
          },
        ),
      ],
    );
  }
}
