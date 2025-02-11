import 'package:testbench/models/request_model.dart';

class EnvironmentModel {
  String name;
  Map<String, String> variables;

  EnvironmentModel({
    required this.name,
    this.variables = const {},
  });
}