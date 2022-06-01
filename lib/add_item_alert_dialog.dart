import 'package:demo_another_brother_prime/models/todo.dart';
import 'package:demo_another_brother_prime/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'package:demo_another_brother_prime/customers.dart' as my;

class AddItemAlertDialog extends ConsumerStatefulWidget {
  const AddItemAlertDialog({Key? key}) : super(key: key);

  @override
  AddItemAlertDialogState createState() => AddItemAlertDialogState();
}

class AddItemAlertDialogState extends ConsumerState<AddItemAlertDialog> {
  final List<DropdownMenuItem<int>> _dropdownMenuItems = my.currentCustomers
      .map((my.Customer customer) => DropdownMenuItem<int>(
    value: customer.id,
    child: Text(customer.name),
  ))
      .toList();

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    int? value =
        _dropdownMenuItems[ref.watch(customerProvider).selectedCustomer.id - 1]
            .value;

    void _addTodoItem(String name, String price) {
        ref.read(todosProvider).addTodo(Todo(name: name, price: double.parse(price), checked: false));

      _textFieldController.clear();
      _priceFieldController.clear();
    }

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0.0),
      title: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(0.0),
        color: Theme.of(context).primaryColor,
        child: Text(
          'Add item to invoice',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Column(
              mainAxisSize:
              MainAxisSize.min, // shrinks dialog to fit the content
              children: <Widget>[
                SvgPicture.asset('assets/invoice.svg', width: 150, height: 150),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Customer',
                    style: Constants.customFont,
                  ),
                ),
                DropdownButton<int>(
      
                    value: value,
                    items: _dropdownMenuItems,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        my.Customer selectedCustomer = my.currentCustomers
                            .firstWhere((my.Customer customer) =>
                        customer.id == newValue);
                        ref
                            .read(customerProvider)
                            .updateCustomer(selectedCustomer);
                        setState(() {
                          value = newValue;
                        });
                      }
                    }),
                TextField(
                  controller: _textFieldController,
                  decoration:
                  const InputDecoration(hintText: 'Enter item description'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: _priceFieldController,
                  decoration:
                  const InputDecoration(hintText: 'Enter item price'),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ], // allow two digit decimal numbers
                ),
              ]),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Add', style: Constants.customFont),
          onPressed: () {
            Navigator.of(context).pop();
            _addTodoItem(
                _textFieldController.text, _priceFieldController.text);
          },
        ),
      ],
    );
  }
}
