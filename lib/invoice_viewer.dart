import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceViewer extends ConsumerWidget {
  const InvoiceViewer({Key? key, required this.receiptPath}) : super(key: key);

  final String receiptPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
        },
        child: const Icon(Icons.print),
      ),
      body: PDFView(
        filePath: receiptPath,
      ),
    );
  }
}
