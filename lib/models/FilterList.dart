import 'package:flutter/cupertino.dart';
import 'package:ondemand_overdrive/models/FilterItem.dart';

class FilterList extends Iterable<FilterItem> with ChangeNotifier {
  List<FilterItem> _items;
  
  operator [](int i) => this._items[i];

  FilterList(Iterable<String> items){
    this._items = new List<FilterItem>();

    items.forEach((s) {
      var filterItem = new FilterItem(name: s, isSelected: true);
      filterItem.addListener(notify);
      this._items.add(filterItem);
    });
  }

  bool hasSelectedItems(){
    return _items.any((i) => i.isSelected);
  }

  bool isActive(String item){
    return this._items.firstWhere((i) => i.name == item).isSelected;
  }

  void selectNone(){
    this._items.forEach((i){
      i.isSelected = false;
    });
    notifyListeners();
  }

  void selectAll(){
    this._items.forEach((i){
      i.isSelected = true;
    });
    notifyListeners();
  }

  void toggleAll(bool selected){
    this._items.forEach((i){
      i.isSelected = selected;
    });
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

  @override
  Iterator<FilterItem> get iterator => this._items.iterator;
}