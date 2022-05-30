import 'package:another_quickbooks/another_quickbooks.dart';
import 'package:another_quickbooks/quickbook_models.dart';
import 'package:demo_another_brother_prime/secrets.dart';
import 'package:flutter/material.dart';

class QuickBooksAPI extends ChangeNotifier {
  TokenResponse? token;
  String? realmId;
  QuickbooksClient? quickClient;
  String? authUrl;

  // Configured in Quickbooks Dashboard.
  static const String redirectUrl =
      "https://developer.intuit.com/v2/OAuth2Playground/RedirectUrl";

  void updateToken(TokenResponse? token) {
    this.token = token;
    notifyListeners();
  }

  Future<void> initializeQuickbooks() async {
    const String redirectUrl =
        "https://developer.intuit.com/v2/OAuth2Playground/RedirectUrl";

    quickClient = QuickbooksClient(
        applicationId: Secrets.applicationId,
        clientId: Secrets.clientId,
        clientSecret: Secrets.clientSecret,
        environmentType: EnvironmentType.Sandbox);

    await quickClient?.initialize();

    authUrl = quickClient?.getAuthorizationPageUrl(
        scopes: [Scope.Payments, Scope.Accounting],
        redirectUrl: redirectUrl,
        state: "state123");
    debugPrint(authUrl);
    notifyListeners();
  }

  Future<void> requestAccessToken(String code, String newRealmId) async {
    realmId = newRealmId;
    token = await quickClient!
        .getAuthToken(code: code, redirectUrl: redirectUrl, realmId: realmId!);
    notifyListeners();
  }
}
