import 'dart:io';

import 'package:another_quickbooks/quickbook_models.dart';
import 'package:demo_another_brother_prime/constants.dart';
import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:demo_another_brother_prime/models/todo.dart';
import 'package:demo_another_brother_prime/print_api.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:demo_another_brother_prime/todo_item.dart';
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
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          title: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(0.0),
            color: Theme.of(context).primaryColor,
            child: const Text(
              'Add item to invoice',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          content: Column(
              mainAxisSize:
                  MainAxisSize.min, // shrinks dialog to fit the content
              children: <Widget>[
                TextField(
                  controller: _textFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Enter item description'),
                ),
                TextField(
                  controller: _priceFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Enter item price'),
                ),
              ]),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(
                    _textFieldController.text, _priceFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name, String price) {
    setState(() {
      _todos.add(Todo(name: name, price: double.parse(price), checked: false));
    });
    _textFieldController.clear();
    _priceFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _createInvoice() async {
    List<Line>? lines = <Line>[];

    for (var i = 0; i < _todos.length; i++) {
      lines.add(SalesItemLine(
          amount: double.parse(_todos[i].price.toStringAsFixed(2)),
          description: _todos[i].name,
          lineNum: 1,
          detailType: DetailType.SalesItemLineDetail.name,
          salesItemLineDetail: SalesItemLineDetail(
            qty: 1,
            unitPrice: double.parse(_todos[i].price.toStringAsFixed(2)),
          )));
    }
    ref.read(screenProvider).setIsGeneratingInvoice(true);
    showDialog(
        context: context,
        builder: (context) => const IsGeneratingInvoiceDialog());
    Invoice? newInvoice =
        await ref.read(quickBooksProvider).createInvoiceFromLines(lines);
    ref.read(screenProvider).setIsGeneratingInvoice(false);
    if (newInvoice != null) {
      File? pdf = await ref.read(quickBooksProvider).downloadPDF(newInvoice);
      if (pdf != null) {
        ref.read(screenProvider).setIsPrinting(true);
        showDialog(
            context: context, builder: (context) => const IsPrintingDialog());
        // ignore: use_build_context_synchronously
        await PrintAPI.printPDF(context, pdf.path);
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
    bool isEmpty = _todos.isEmpty;

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
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            Expanded(
              child: (isEmpty)
                  ? Center(
                      child: Text(
                          'Click the button to add your first invoice item', style: GoogleFonts.montserrat(),))
                  : ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      children: _todos.map((Todo todo) {
                        return TodoItem(
                          todo: todo,
                          onTodoChanged: _handleTodoChange,
                        );
                      }).toList(),
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
            onTap: _displayDialog,
            label: 'Add item',
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            onTap: _createInvoice,
            label: 'Print invoice',
          ),
        ],
      ),
    );
  }
}
