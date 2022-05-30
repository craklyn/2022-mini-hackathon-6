import 'package:demo_another_brother_prime/models/quickbooks_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickBooksProvider = ChangeNotifierProvider<QuickBooksAPI>(
  (ref) => QuickBooksAPI(),
);
