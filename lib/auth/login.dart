import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gudsman_service/components/custom_appbar.dart';
import 'package:gudsman_service/utils/http_req.dart';

import 'package:http/http.dart' as http;
import 'package:gudsman_service/utils/shared_prefs.dart';

Future<http.Response> login(String email, String password) async {
  final response =
      await AuthHttpRequest.login({'email': email, 'password': password});

  if (response.statusCode == 200) {
    SharedPref.setPrefsData('accessToken', jsonDecode(response.body)['token']);
    return response;
  } else {
    throw Exception('Failed to login');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  // This widget is the root of your application.

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String savedEmail = '';

  Future<void> saveEmail() async {
    setState(() {
      SharedPref.setPrefsData('email', _emailController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPref.setPrefsData('accessToken', '');
    // savedEmail = SharedPref.getPrefsData('email').then((value) => value);
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gudsman Reports',
      ),
      body: Center(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Login',
              style: TextStyle(fontSize: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextField(
              controller: _passwordController,
              autocorrect: false,
              obscureText: true,
              enableSuggestions: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                saveEmail();
                AuthHttpRequest.login({
                  'email': _emailController.text,
                  'password': _passwordController.text,
                }).then((response) {
                  if (response.statusCode == 200) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                });
              },
              child: const Text('Login')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  // @ignore: avoid_print
                  print('Accessing the Token');
                  SharedPref.getAccessToken().then((value) => print(value));
                },
                child: const Text('Register'),
              )
            ],
          ),
        ],
      )),
    );
  }
}
