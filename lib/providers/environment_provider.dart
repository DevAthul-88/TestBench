import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../models/collection_model.dart';
import '../models/environment_model.dart';

class EnvironmentProvider extends ChangeNotifier {
  List<EnvironmentModel> _environments = [];
  
  List<EnvironmentModel> get environments => _environments;
  
  void addEnvironment(EnvironmentModel environment) {
    _environments.add(environment);
    notifyListeners();
  }
}