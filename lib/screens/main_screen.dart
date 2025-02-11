import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'request_tab_screen.dart';
import 'websocket_screen.dart';
import 'collections_screen.dart';
import 'environments_screen.dart';
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        title: Text('Test Bench'),
      ),
      pane: fluent.NavigationPane(
        selected: appState.selectedIndex,
        onChanged: (index) => appState.updateSelectedIndex(index),
        items: [
          fluent.PaneItem(
            icon: Icon(fluent.FluentIcons.send),
            title: Text('Requests'),
            body: RequestTabScreen(),
          ),
          fluent.PaneItem(
            icon: Icon(fluent.FluentIcons.globe),
            title: Text('WebSocket'),
            body: WebSocketScreen(),
          ),
          fluent.PaneItem(
            icon: Icon(fluent.FluentIcons.list),
            title: Text('Collections'),
            body: CollectionsScreen(),
          ),
          fluent.PaneItem(
            icon: Icon(fluent.FluentIcons.globe),
            title: Text('Environments'),
            body: EnvironmentsScreen(),
          ),
          fluent.PaneItem(
            icon: Icon(fluent.FluentIcons.history),
            title: Text('History'),
            body: HistoryScreen(),
          ),
        ],
      ),
    );
  }
}
