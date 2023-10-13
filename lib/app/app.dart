import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/app/new_organization_page.dart';
import 'package:gudsman_service/app/pages/home.dart';
import 'package:gudsman_service/auth/onboarding.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/utils/dataClass/organization.dart';
import 'package:gudsman_service/utils/shared_prefs.dart';

final orgFetchProvider =
    StateNotifierProvider<OrganizationNotifier, AsyncValue<OrganizationModel>>(
        (ref) => OrganizationNotifier(ref));

final orgProvider = StateProvider<OrganizationModel?>((ref) {
  return ref.watch(orgFetchProvider).value;
});

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  // The app screen will be used to check system only

  int CurrentTab = 0;
  final List<Widget> screens = const [
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder(
          future: SharedPref.getAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == '') {
                Future(() => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const OnBoardingScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero)));
              } else {
                Future(() => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const HomeScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero)));
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
