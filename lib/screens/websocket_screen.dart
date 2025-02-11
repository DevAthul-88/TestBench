import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import '../widgets/websocket_tester.dart';

class WebSocketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(title: Text('WebSocket')),
      content: fluent.Card(
        child: WebSocketTester(),
      ),
    );
  }
}