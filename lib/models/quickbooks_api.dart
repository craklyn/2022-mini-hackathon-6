import 'package:another_quickbooks/another_quickbooks.dart';
import 'package:another_quickbooks/quickbook_models.dart';
import 'package:demo_another_brother_prime/secrets.dart';
import 'package:flutter/material.dart';

class QuickBooksAPI extends ChangeNotifier {
  String? token;

  void updateToken(String? token) {
    this.token = token;
    notifyListeners();
  }

  static Future<void> initializeQuickbooks() async {
    const String redirectUrl =
        "https://developer.intuit.com/v2/OAuth2Playground/RedirectUrl";

    QuickbooksClient? quickClient = QuickbooksClient(
        applicationId: Secrets.applicationId,
        clientId: Secrets.clientId,
        clientSecret: Secrets.clientSecret,
        environmentType: EnvironmentType.Sandbox);

    await quickClient.initialize();

    String? authUrl = quickClient.getAuthorizationPageUrl(
        scopes: [Scope.Payments, Scope.Accounting],
        redirectUrl: redirectUrl,
        state: "state123");
    debugPrint(authUrl);
  }
}
