import 'package:testbench/models/request_model.dart';

class CollectionModel {
  String name;
  List<RequestModel> requests;

  CollectionModel({ 
    required this.name,
    this.requests = const [],
  });
}
