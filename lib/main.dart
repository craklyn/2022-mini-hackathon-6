import 'package:demo_another_brother_prime/ql_bluetooth_print_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final controller = PageController(initialPage: 1);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Another Brother Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageView(children: const [
        QlBluetoothPrintPage(title: 'QL-1110NWB Bluetooth Sample')
      ]),
    );
  }
}

