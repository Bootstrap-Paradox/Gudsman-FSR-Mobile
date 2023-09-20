import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/custom_appbar.dart';

class ViewServiceReportScreen extends ConsumerStatefulWidget {
  const ViewServiceReportScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewServiceReportScreenState();
}

class _ViewServiceReportScreenState
    extends ConsumerState<ViewServiceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              const Center(child: Text('View Service Report')),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  }),
            ]))
          ],
        ),
      ),
    );
  }
}
