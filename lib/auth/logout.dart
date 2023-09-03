import 'package:flutter/material.dart';
import 'package:gudsman_service/utils/shared_prefs.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    SharedPref.setPrefsData('accessToken', '');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Logging out...'),
      ),
    );
  }
}
