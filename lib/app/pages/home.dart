import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/components/dashboard/dashboard.dart';
import 'package:gudsman_service/utils/dataClass/organization.dart';
import 'package:gudsman_service/utils/dataClass/report/report_form.dart';
import 'package:gudsman_service/utils/exceptions/unauthorized_exception.dart';

final orgFetchProvider =
    StateNotifierProvider<OrganizationNotifier, AsyncValue<OrganizationModel>>(
        (ref) => OrganizationNotifier(ref));

final orgProvider = StateProvider<OrganizationModel?>((ref) => null);

final serviceReportListProvider =
    StateNotifierProvider<ServiceReportList, List<ServiceReport>>((ref) {
  return ServiceReportList(ref.watch(orgFetchProvider).value?.id ?? '', []);
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ref.read(serviceReportListProvider.notifier).fetchServiceReports();
  }

  @override
  Widget build(BuildContext context) {
    // late AsyncValue<Map<String, dynamic>> organizationDetails;
    final AsyncValue<OrganizationModel> orgData = ref.watch(orgFetchProvider);

    return orgData.when(data: (orgDetails) {
      Future(() {
        // ref.read(orgProvider.notifier).update((state) => orgDetails);
        // ref.read(serviceReportListProvider.notifier).fetchServiceReports();
      });
      return Scaffold(
          appBar: CustomAppBar(title: 'Gudsman Reports', context: context),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: Colors.green.shade300,
                        ),
                        height: 40,
                        width: 40,
                        child: const Text(
                          'ON',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(orgDetails.orgName),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
          body: const SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DashboardComponent(),
              ],
            )),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewServiceScreen()));
                },
                child: const Icon(Icons.add),
                // This trailing comma makes auto-formatting nicer for build methods.
              )));
    }, error: (err, stack) {
      if (err.runtimeType == UnauthorizedException) {
        // Navigator.of(context).pushNamed('/login');
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
            Navigator.of(context).pushReplacementNamed('/login'));
      }

      return Scaffold(
          appBar: CustomAppBar(
            title: 'Gudsman Reports',
            context: context,
          ),
          body: Center(
            child: Text(err.toString()),
          ));
    }, loading: () {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Gudsman Reports',
          context: context,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
