import 'package:demo_another_brother_prime/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final controller = PageController(initialPage: 1);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Another Brother Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Authenticate(),
    );
  }
}
