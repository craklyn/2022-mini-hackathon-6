import 'package:demo_another_brother_prime/models/todo.dart';
import 'package:demo_another_brother_prime/todo_item.dart';
import 'package:flutter/material.dart';

class QlBluetoothPrintPage extends StatefulWidget {
  const QlBluetoothPrintPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  QlBluetoothPrintPageState createState() => QlBluetoothPrintPageState();
}

class QlBluetoothPrintPageState extends State<QlBluetoothPrintPage> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, price: 0.00, checked: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        // onPressed: () => print(context),
        // tooltip: 'Print',
        // child: Icon(Icons.print),
        onPressed: () => _displayDialog(),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}