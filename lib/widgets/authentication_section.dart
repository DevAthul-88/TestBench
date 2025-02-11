import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class AuthenticationSection extends StatefulWidget {
  @override
  _AuthenticationSectionState createState() => _AuthenticationSectionState();
}

class _AuthenticationSectionState extends State<AuthenticationSection> {
  final _authTypes = [
    'No Auth', 
    'Bearer Token', 
    'Basic Auth', 
    'API Key'
  ];
  String _selectedAuthType = 'No Auth';

  Widget _buildAuthFields() {
    switch (_selectedAuthType) {
      case 'Bearer Token':
        return fluent.TextBox(
          placeholder: 'Enter Bearer Token',
          obscureText: true,
        );
      case 'Basic Auth':
        return Column(
          children: [
            fluent.TextBox(placeholder: 'Username'),
            SizedBox(height: 8),
            fluent.TextBox(
              placeholder: 'Password',
              obscureText: true,
            ),
          ],
        );
      case 'API Key':
        return Column(
          children: [
            fluent.TextBox(placeholder: 'API Key'),
            fluent.ComboBox<String>(
              value: 'Header',
              items: [
                fluent.ComboBoxItem(value: 'Header', child: Text('Header')),
                fluent.ComboBoxItem(value: 'Query', child: Text('Query Parameter')),
              ],
              onChanged: (value) {},
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return fluent.Card(
      child: Column(
        children: [
          fluent.ComboBox<String>(
            value: _selectedAuthType,
            items: _authTypes.map((type) => 
              fluent.ComboBoxItem(value: type, child: Text(type))
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAuthType = value!;
              });
            },
          ),
          SizedBox(height: 8),
          _buildAuthFields(),
        ],
      ),
    );
  }
}