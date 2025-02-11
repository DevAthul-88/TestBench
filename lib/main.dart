import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'providers/collection_provider.dart';
import 'providers/environment_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/request_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ChangeNotifierProvider(create: (_) => CollectionProvider()),
      ChangeNotifierProvider(create: (_) => EnvironmentProvider()),
      ChangeNotifierProvider(create: (_) => RequestProvider()),
    ],
    child: PostmanCloneApp(),
  ));
}

class PostmanCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return fluent.FluentApp(
      title: 'API Companion',
      themeMode: themeProvider.themeMode,
      theme: fluent.FluentThemeData(
        brightness: Brightness.light,
        accentColor: fluent.Colors.blue,
      ),
      darkTheme: fluent.FluentThemeData(
        brightness: Brightness.dark,
        accentColor: fluent.Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}