import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:demo_another_brother_prime/ql_bluetooth_print_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QBWebView extends ConsumerWidget {
  const QBWebView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WebView(
      initialUrl: ref.read(quickBooksProvider).authUrl ?? '',
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: const <JavascriptChannel>{},
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith(QuickBooksAPI.redirectUrl)) {
          debugPrint('blocking navigation to $request}');
          var url = Uri.parse(request.url);
          String code = url.queryParameters["code"]!;
          String realmId = url.queryParameters['realmId']!;
          // Request access token
          ref.read(quickBooksProvider).requestAccessToken(code, realmId);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const QlBluetoothPrintPage(
                  title: 'QL-1110NWB Bluetooth Sample')));
          return NavigationDecision.prevent;
        }
        debugPrint('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        debugPrint('Page started loading: $url');
      },
      onPageFinished: (String url) {
        debugPrint('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
      backgroundColor: const Color(0x00000000),
    );
  }
}
