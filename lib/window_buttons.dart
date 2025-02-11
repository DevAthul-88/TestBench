import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:window_manager/window_manager.dart';

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        fluent.IconButton(
          icon: Icon(fluent.FluentIcons.chrome_minimize),
          onPressed: () => windowManager.minimize(),
        ),
        fluent.IconButton(
          icon: Icon(fluent.FluentIcons.square_shape),
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
        ),
        fluent.IconButton(
          icon: Icon(fluent.FluentIcons.chrome_close),
          onPressed: () => windowManager.close(),
        ),
      ],
    );
  }
}