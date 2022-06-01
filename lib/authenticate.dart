import 'package:demo_another_brother_prime/constants.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:demo_another_brother_prime/q_b_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Authenticate extends ConsumerStatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  ConsumerState<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends ConsumerState<Authenticate> {
  late final Future<void> _initializeQuickbooks;

  @override
  void initState() {
    _initializeQuickbooks = ref.read(quickBooksProvider).initializeQuickbooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.appName,
          style: Constants.header,
        ),
      ),
      body: Center(
        child: FutureBuilder<void>(
            future: _initializeQuickbooks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Initializing Quickbooks...',
                      style: Constants.customFont,
                    ),
                  ],
                );
              }

              bool hasToken = ref.read(quickBooksProvider).token != null;
              if (hasToken) {
                return Text(
                  'You have been authenticated!',
                  style: Constants.customFont,
                );
              } else {
                return const QBWebView();
              }
            }),
      ),
    );
  }
}
