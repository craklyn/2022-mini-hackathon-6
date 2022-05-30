import 'package:demo_another_brother_prime/print_api.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:demo_another_brother_prime/ql_bluetooth_print_page.dart';
import 'package:demo_another_brother_prime/widgets/is_printing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class InvoiceViewer extends ConsumerWidget {
  const InvoiceViewer({Key? key, required this.receiptPath}) : super(key: key);

  final String receiptPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(screenProvider).setIsPrinting(true);
          showDialog(
              context: context, builder: (context) => const IsPrintingDialog());
          await PrintAPI.printPDF(context, receiptPath);
          Get.offAll(() => const QlBluetoothPrintPage(
                  title: 'QL-1110NWB Bluetooth Sample'));
        },
        child: const Icon(Icons.print),
      ),
      body: PDFView(
        filePath: receiptPath,
      ),
    );
  }
}
