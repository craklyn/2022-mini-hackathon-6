import 'package:flutter/foundation.dart';

class Todo {
  Todo({required this.name, required this.price, required this.checked});
  final String name;
  final double price;
  bool checked;
}

class Todos extends ChangeNotifier {
  List<Todo> todos = <Todo>[];

  void addTodo(Todo newTodo) {
    todos.add(newTodo);
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    todos.remove(todo);
    notifyListeners();
  }

  void clearTodos() {
    todos.clear();
    notifyListeners();
  }

  void updateTodos(List<Todo> newTodos) {
    todos = newTodos;
    notifyListeners();
  }
}
