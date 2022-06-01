import 'package:demo_another_brother_prime/customers.dart';
import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:demo_another_brother_prime/models/screen_management.dart';
import 'package:demo_another_brother_prime/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickBooksProvider = ChangeNotifierProvider<QuickBooksAPI>(
  (ref) => QuickBooksAPI(),
);

final screenProvider = ChangeNotifierProvider<ScreenManagement>(
  (ref) => ScreenManagement(),
);

final customerProvider = ChangeNotifierProvider<SelectedCustomer>(
  (ref) => SelectedCustomer(currentCustomers.first),
);

final todosProvider = ChangeNotifierProvider<Todos>((ref) => Todos());