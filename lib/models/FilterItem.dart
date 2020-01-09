import 'package:flutter/foundation.dart';

class FilterItem with ChangeNotifier {
  String name;
  bool isSelected;

  void toggle(bool selected){
    this.isSelected = selected;
    notifyListeners();
  }

  FilterItem({this.name, this.isSelected});
}