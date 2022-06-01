import 'package:flutter/foundation.dart';

List<Map<String, dynamic>> customersData = [
  {
    'name': 'Amy\'s Bird Sanctuary',
    'id': 1,
  },
  {
    'name': 'Bill\'s Windsurf Shop',
    'id': 2,
  },
  {'name': 'Cool Cars', 'id': 3},
  {'name': 'Diego Rodriguez', 'id': 4},
  {'name': 'Dukes Basketball Camp', 'id': 5},
  {'name': 'Dylan Sollfrank', 'id': 6},
  {'name': 'Freeman Sporting Goods', 'id': 7},
  {'name': 'Geeta Kalapatapu', 'id': 8},
  {'name': 'Gevelber Photography', 'id': 9},
  {'name': 'Jeff\'s Jalopies', 'id': 10},
];

final List<Customer> currentCustomers = customersData
    .map((customer) => Customer(
          customer['name'],
          customer['id'],
        ))
    .toList();

class SelectedCustomer extends ChangeNotifier {
  Customer _selectedCustomer;

  SelectedCustomer(this._selectedCustomer);

  Customer get selectedCustomer => _selectedCustomer;

  void updateCustomer(Customer customer) {
    _selectedCustomer = Customer(customer.name, customer.id);
    notifyListeners();
  }
}

class Customer extends ChangeNotifier{
  String name;
  int id;

  Customer(this.name, this.id);

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(map['name'], map['id']);
  }

  void updateCustomer(Customer newCustomer) {
    name = newCustomer.name;
    id = newCustomer.id;
    notifyListeners();
  }

  // override equality operator and hashcode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

}
