import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import '../widgets/environment_variable_manager.dart';

class EnvironmentsScreen extends StatefulWidget {
  @override
  _EnvironmentsScreenState createState() => _EnvironmentsScreenState();
}

class _EnvironmentsScreenState extends State<EnvironmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(title: Text('Environments')),
      content: fluent.Card(
        child: Column(
          children: [
            EnvironmentVariableManager(),
          ],
        ),
      ),
    );
  }
}