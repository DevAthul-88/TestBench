import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../models/collection_model.dart';
import '../models/environment_model.dart';

class AppStateProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  
  int get selectedIndex => _selectedIndex;
  
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
