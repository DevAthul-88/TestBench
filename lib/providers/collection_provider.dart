import 'package:flutter/material.dart';
import '../models/collection_model.dart';

class CollectionProvider extends ChangeNotifier {
  final List<CollectionModel> _collections = [];
  
  List<CollectionModel> get collections => _collections;
  
  void addCollection(CollectionModel collection) {
    _collections.add(collection);
    notifyListeners();
  }

  void removeCollection(CollectionModel collection) {
    _collections.remove(collection);
    notifyListeners();
  }
}
