import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/app.dart';
import 'package:gudsman_service/app/pages/new_service.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/components/dashboard/dashboard.dart';
import 'package:gudsman_service/components/dashboard/organization_card.dart';
import 'package:gudsman_service/components/dashboard/recent_reports.dart';
import 'package:gudsman_service/utils/dataClass/organization.dart';
import 'package:gudsman_service/utils/dataClass/report/report_form.dart';
import 'package:gudsman_service/utils/exceptions/unauthorized_exception.dart';

final serviceReportListProvider =
    StateNotifierProvider<ServiceReportList, List<ServiceReport>>((ref) {
  return ServiceReportList(ref.watch(orgProvider)?.id ?? '', []);
});

final activeServiceReport = StateProvider<ServiceReport?>((ref) {
  final reportList = ref.watch(serviceReportListProvider);

  if (reportList.isEmpty) {
    return null;
  }

  // return activeReport;

  try {
    final activeReport =
        reportList.firstWhere((element) => element.status == 'active');
    return activeReport;
  } catch (e) {
    return null;
  }
});

final todaysServiceReports = StateProvider<List<ServiceReport>?>((ref) {
  final reports = ref.watch(serviceReportListProvider);
  if (reports.isEmpty) {
    return [];
  }
  // will contain all reports that were started today
  try {
    return reports
        .where((element) =>
            element.startTime.difference(DateTime.now()).inDays == 0)
        .toList()
        .where((element) => element.status != 'active')
        .toList();
  } catch (e) {
    return null;
  }
});

final recentServiceReports = StateProvider<List<ServiceReport>?>((ref) {
  final reports = ref.watch(serviceReportListProvider);
  if (reports.isEmpty) {
    return null;
  }
  // will contain all reports except for the active ones
  return reports.where((element) => element.status != 'active').toList();
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

  int _selectedIndex = 0;

  static const List<Widget> _widgetoptions = [
    DashboardComponent(),
    RecentReportsComponent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // late AsyncValue<Map<String, dynamic>> organizationDetails;
    final AsyncValue<OrganizationModel> orgData = ref.watch(orgFetchProvider);
    final ServiceReport? activeReport = ref.watch(activeServiceReport);

    return orgData.when(data: (orgDetails) {
      Future(() {
        ref.read(orgProvider.notifier).update((state) => orgDetails);
        // ref.read(serviceReportListProvider.notifier).fetchServiceReports();
      });
      return Scaffold(
          appBar: CustomAppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.grey.shade700,
                onPressed: () {
                  ref
                      .read(serviceReportListProvider.notifier)
                      .fetchServiceReports();
                  // do something
                },
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) => _onItemTapped(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                OrganizationCard(
                  orgName: orgDetails.orgName,
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
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Center(child: _widgetoptions.elementAt(_selectedIndex)),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: activeReport == null
              ? Padding(
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
                  ))
              : null);
    }, error: (err, stack) {
      if (err.runtimeType == UnauthorizedException) {
        // Navigator.of(context).pushNamed('/login');
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
            Navigator.of(context).pushReplacementNamed('/login'));
      }

      return Scaffold(
          appBar: CustomAppBar(
            title: 'Gudsman Reports',
          ),
          body: Center(
            child: Text(err.toString()),
          ));
    }, loading: () {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Gudsman Reports',
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
