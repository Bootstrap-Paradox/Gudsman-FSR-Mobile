import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/components/dashboard/live_report_block.dart';

class DashboardComponent extends ConsumerStatefulWidget {
  const DashboardComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardComponentState();
}

class _DashboardComponentState extends ConsumerState<DashboardComponent> {
  @override
  Widget build(BuildContext context) {
    // final List<Map<String, dynamic>> _data = [
    //   {
    //     'title': 'Service Request',
    //     'value': 2,
    //   },
    //   {
    //     'title': 'Report Complete',
    //     'value': 1,
    //   },
    // ];

    final serviceReportList = ref.watch(serviceReportListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // const Wrap(
        //   children: [
        //     DashboardInfoBlock(title: 'Service Request', value: 2),
        //     DashboardInfoBlock(title: 'Report Complete', value: 1),
        //   ],
        // ),
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: serviceReportList.length,
          itemBuilder: (context, index) {
            return LiveReportBlock(
              serviceReportId: serviceReportList[index].serviceId,
              customerName: serviceReportList[index].customerName,
              reportType: serviceReportList[index].serviceType,
              startDate: serviceReportList[index].startTime,
            );
          },
        ),
        !serviceReportList.isNotEmpty
            ? Text('No Ongoing Report [Work in Progress]',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ))
            : const SizedBox(),
        Center(
          child: ElevatedButton(
              onPressed: () {
                ref
                    .read(serviceReportListProvider.notifier)
                    .fetchServiceReports();

                // print(ref.watch(orgFetchProvider).value?.id);
              },
              child: const Text('Refresh Reports')),
        )
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
        width: 100,
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
