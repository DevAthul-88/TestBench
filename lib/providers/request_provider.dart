import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../models/collection_model.dart';
import '../models/environment_model.dart';

class RequestProvider extends ChangeNotifier {
  List<RequestModel> _requests = [];
  
  List<RequestModel> get requests => _requests;
  
  void addRequest(RequestModel request) {
    _requests.add(request);
    notifyListeners();
  }
}
