import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../../model/item.dart';

class ItemData with ChangeNotifier {
  // List<Item> _items = [
  //   Item(item: 'abc', completed: false),
  // ];
  List<Item> _items = [];
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  get size => _items.length;

  void addItem(Item item) {
    debugPrint('0 item_data: addItem()');
    String s = item.item;
    bool b = item.completed;
    debugPrint('$s and $b');
    debugPrint('1 item_data: addItem()');
    for (var i = 0; i < _items.length; i++) {
      String s = _items[i].item;
      bool b = _items[i].completed;
      debugPrint('$s and $b');
    }

    _items.add(item);
    notifyListeners();
    debugPrint('2 item_data: addItem()');
    for (var i = 0; i < _items.length; i++) {
      String s = _items[i].item;
      bool b = _items[i].completed;
      debugPrint('$s and $b');
    }
    debugPrint('3 item_data: addItem()');
  }

  void toggleItem(Item item) {
    item.toggle();
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
    debugPrint('item_data: removeItem()');
  }
}
