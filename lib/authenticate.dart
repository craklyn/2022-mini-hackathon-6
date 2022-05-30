import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QL-1110NWB Bluetooth Sample'),
      ),
      body: Center(
        child: FutureBuilder<void>(
            future: QuickBooksAPI.initializeQuickbooks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing Quickbooks...'),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}
