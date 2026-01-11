import 'package:flutter/foundation.dart';

class BookingItem {
  final dynamic vaccine;
  final int quantity;

  BookingItem({required this.vaccine, required this.quantity});
}

class BookingProvider with ChangeNotifier {
  List<BookingItem> _items = [];

  List<BookingItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + (item.vaccine.price * item.quantity));

  List<Map<String, dynamic>> get bookingItems => _items
      .map((item) => {
            'id': item.vaccine.id,
            'name': item.vaccine.name,
            'quantity': item.quantity,
            'price': item.vaccine.price,
          })
      .toList();

  void addItem(dynamic vaccine, int quantity) {
    // Implement add logic
    notifyListeners();
  }

  void clearBooking() {
    _items.clear();
    notifyListeners();
  }
}
