// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_srdz_v1/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        platform: TargetPlatform.windows,

        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: Homapeage(),
    );
  }
}
