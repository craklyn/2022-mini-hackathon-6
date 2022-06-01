import 'dart:io';

import 'package:another_quickbooks/quickbook_models.dart';
import 'package:demo_another_brother_prime/add_item_alert_dialog.dart';
import 'package:demo_another_brother_prime/constants.dart';
import 'package:demo_another_brother_prime/customers.dart' as my;
import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:demo_another_brother_prime/models/todo.dart';
import 'package:demo_another_brother_prime/print_api.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:demo_another_brother_prime/widgets/is_generating_invoice_dialog.dart';
import 'package:demo_another_brother_prime/widgets/is_printing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QlBluetoothPrintPage extends ConsumerStatefulWidget {
  const QlBluetoothPrintPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  QlBluetoothPrintPageState createState() => QlBluetoothPrintPageState();
}

class QlBluetoothPrintPageState extends ConsumerState<QlBluetoothPrintPage> {
  Future<void> _displayDialog(List<Todo> todos) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AddItemAlertDialog();
      },
    );
  }

  void _createInvoice(List<Todo> todos) async {
    List<Line>? lines = <Line>[];

    for (var i = 0; i < todos.length; i++) {
      lines.add(SalesItemLine(
          amount: double.parse(todos[i].price.toStringAsFixed(2)),
          description: todos[i].name,
          lineNum: 1,
          detailType: DetailType.SalesItemLineDetail.name,
          salesItemLineDetail: SalesItemLineDetail(
            qty: 1,
            unitPrice: double.parse(todos[i].price.toStringAsFixed(2)),
          )));
    }
    ref.read(screenProvider).setIsGeneratingInvoice(true);
    showDialog(
        context: context,
        builder: (context) => const IsGeneratingInvoiceDialog());

    my.Customer customer = ref.read(customerProvider).selectedCustomer;

    Invoice? newInvoice = await ref
        .read(quickBooksProvider)
        .createInvoiceFromLines(lines, customer);
    ref.read(screenProvider).setIsGeneratingInvoice(false);
    if (newInvoice != null) {
      File? pdf = await ref.read(quickBooksProvider).downloadPDF(newInvoice);
      if (pdf != null) {
        ref.read(screenProvider).setIsPrinting(true);
        showDialog(
            context: context, builder: (context) => const IsPrintingDialog());
        // ignore: use_build_context_synchronously
        await PrintAPI.printPDF(context, pdf.path);
        ref.read(todosProvider).clearTodos();
        Get.offAll(() => const QlBluetoothPrintPage(title: Constants.appName));
      } else {
        Fluttertoast.showToast(
            msg: "Error downloading PDF",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(msg: 'Error creating invoice');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Todo> todos = ref.watch(todosProvider).todos;

    bool isEmpty = todos.isEmpty;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: Text(
          widget.title,
          style: Constants.header,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            SvgPicture.asset(
              'assets/houses.svg',
              width: width * 0.75,
            ),
            Expanded(
              child: (isEmpty)
                  ? Center(
                      child: Text(
                      'Click the button to add your first invoice item',
                      style: GoogleFonts.montserrat(),
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                              label: SizedBox(
                                  width: width * 0.40,
                                  child: const Text(
                                    'Item',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ))),
                          DataColumn(
                              label: Container(
                                  width: width * 0.25,
                                  alignment: const Alignment(0.5, 0.0),
                                  child: const Text(
                                    'Price',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  )))
                        ],
                        rows: todos.map((Todo todo) {
                          return DataRow(cells: <DataCell>[
                            DataCell(Text(todo.name)),
                            DataCell(Container(
                                alignment: const Alignment(1.0, 0.0),
                                child: Text(
                                    '\$${todo.price.toStringAsFixed(2)}'))),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add_task,
        activeIcon: Icons.close,
        spaceBetweenChildren: 16,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            onTap: () => _displayDialog(todos),
            label: 'Add item',
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            onTap: () => _createInvoice(todos),
            label: 'Print invoice',
          ),
        ],
      ),
    );
  }
}
