import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({super.key, String? title, actions, Color? color})
      : super(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: color ?? const Color(0xFFFFFFFF),
          title: Text(
            title ?? 'Gudsman FSR',
            style: const TextStyle(color: Colors.black),
          ),
          actions: actions,
          elevation: 0.0,
          // automaticallyImplyLeading: false,
        );
}
