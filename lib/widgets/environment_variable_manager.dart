import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class EnvironmentVariableManager extends StatefulWidget {
  @override
  _EnvironmentVariableManagerState createState() => _EnvironmentVariableManagerState();
}

class _EnvironmentVariableManagerState extends State<EnvironmentVariableManager> {
  List<Map<String, dynamic>> _variables = [];

  void _addVariable() {
    setState(() {
      _variables.add({
        'key': '',
        'value': '',
        'type': 'string',
        'enabled': true
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return fluent.Card(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.Text(
            'Environment Variables',
            style: fluent.FluentTheme.of(context).typography.subtitle,
          ),
          SizedBox(height: 16),
          if (_variables.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: fluent.Text(
                  'No variables added yet. Click "Add Variable" to begin.',
                  style: fluent.FluentTheme.of(context).typography.body,
                ),
              ),
            ),
          ...List.generate(_variables.length, (index) {
            var variable = _variables[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: fluent.Card(
                padding: EdgeInsets.all(8),
                backgroundColor: fluent.Colors.grey[10],
                child: fluent.Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: fluent.TextBox(
                        placeholder: 'Variable name',
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: fluent.Text('Name:'),
                        ),
                        onChanged: (value) {
                          _variables[index]['key'] = value;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: fluent.TextBox(
                        placeholder: 'Variable value',
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: fluent.Text('Value:'),
                        ),
                        onChanged: (value) {
                          _variables[index]['value'] = value;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: fluent.ComboBox<String>(
                        value: variable['type'],
                        items: [
                          fluent.ComboBoxItem(
                            value: 'string',
                            child: fluent.Row(
                              children: [
                                Icon(fluent.FluentIcons.text_field, size: 16),
                                SizedBox(width: 8),
                                Text('String'),
                              ],
                            ),
                          ),
                          fluent.ComboBoxItem(
                            value: 'number',
                            child: fluent.Row(
                              children: [
                                Icon(fluent.FluentIcons.number, size: 16),
                                SizedBox(width: 8),
                                Text('Number'),
                              ],
                            ),
                          ),
                          fluent.ComboBoxItem(
                            value: 'boolean',
                            child: fluent.Row(
                              children: [
                                Icon(fluent.FluentIcons.toggle_left, size: 16),
                                SizedBox(width: 8),
                                Text('Boolean'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _variables[index]['type'] = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    fluent.ToggleSwitch(
                      checked: variable['enabled'],
                      onChanged: (value) {
                        setState(() {
                          _variables[index]['enabled'] = value;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    fluent.IconButton(
                      icon: Icon(
                        fluent.FluentIcons.delete,
                        color: fluent.Colors.red,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          _variables.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 16),
          fluent.FilledButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: fluent.Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(fluent.FluentIcons.add),
                  SizedBox(width: 8),
                  Text('Add Variable'),
                ],
              ),
            ),
            onPressed: _addVariable,
          ),
        ],
      ),
    );
  }
}