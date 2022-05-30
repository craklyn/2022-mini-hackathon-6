import 'dart:io';
import 'dart:typed_data';

import 'package:another_quickbooks/another_quickbooks.dart';
import 'package:another_quickbooks/quickbook_models.dart';
import 'package:demo_another_brother_prime/secrets.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum DetailType {
  // ignore: constant_identifier_names
  SalesItemLineDetail,
}

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
    notifyListeners();
  }

  Future<void> requestAccessToken(String code, String newRealmId) async {
    realmId = newRealmId;
    token = await quickClient!
        .getAuthToken(code: code, redirectUrl: redirectUrl, realmId: realmId!);
    notifyListeners();
  }

  Future<Invoice?> createInvoice() async {
    Invoice invoice = Invoice(
      customerRef: ReferenceType(name: 'Test client', value: '1'),
      line: [
        SalesItemLine(
          amount: 100,
          description: 'Test item',
          lineNum: 1,
          detailType: DetailType.SalesItemLineDetail.name,
          salesItemLineDetail: SalesItemLineDetail(
            qty: 1,
            unitPrice: 100,
          ),
        ),
        SalesItemLine(
          amount: 50,
          description: 'Test item 2',
          lineNum: 2,
          detailType: DetailType.SalesItemLineDetail.name,
          salesItemLineDetail: SalesItemLineDetail(
            qty: 5,
            unitPrice: 10,
          ),
        ),
      ],
    );

    Invoice? createdInvoice = await quickClient
        ?.getAccountingClient()
        .createInvoice(
            invoice: invoice, realmId: realmId, authToken: token?.access_token);
    return createdInvoice;
  }

  Future<File?> downloadPDF(Invoice invoice) async {
    if (invoice.id == null) {
      return null;
    } else {
      Uint8List pdfBytes = await quickClient!
          .getAccountingClient()
          .getInvoicePdf(
              realmId: realmId,
              invoiceId: invoice.id!,
              authToken: token?.access_token);

      // create a pdf file in a temporary directory from the Uint8List pdfPytes
      final tempDir = await getTemporaryDirectory();
      final pdf = File('${tempDir.path}/temp.pdf');
      pdf.writeAsBytesSync(pdfBytes);
      return pdf;
    }
  }
}
