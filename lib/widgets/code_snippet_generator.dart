import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/services.dart';

class CodeSnippetGenerator extends StatefulWidget {
  final String url;
  final String method;
  final String body;

  const CodeSnippetGenerator({
    required this.url,
    required this.method,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  _CodeSnippetGeneratorState createState() => _CodeSnippetGeneratorState();
}

class _CodeSnippetGeneratorState extends State<CodeSnippetGenerator> {
  final List<String> _languages = ['cURL', 'Python', 'JavaScript', 'Go'];
  String _selectedLanguage = 'cURL';
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: _generateCodeSnippet());
  }

  @override
  void didUpdateWidget(covariant CodeSnippetGenerator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _codeController.text = _generateCodeSnippet();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _generateCodeSnippet() {
    switch (_selectedLanguage) {
      case 'cURL':
        return '''
curl -X ${widget.method} "${widget.url}" \\
  -H "Content-Type: application/json" \\
  -d '${widget.body}'
''';
      case 'Python':
        return '''
import requests

response = requests.${widget.method.toLowerCase()}(
    "${widget.url}",
    json=${widget.body}
)
print(response.json())
''';
      case 'JavaScript':
        return '''
fetch("${widget.url}", {
  method: "${widget.method}",
  headers: {
    "Content-Type": "application/json"
  },
  body: JSON.stringify(${widget.body})
})
.then(response => response.json())
.then(data => console.log(data));
''';
      case 'Go':
        return '''
package main

import (
    "bytes"
    "net/http"
    "io/ioutil"
)

func main() {
    url := "${widget.url}"
    method := "${widget.method}"

    payload := []byte(${widget.body})

    client := &http.Client{}
    req, err := http.NewRequest(method, url, bytes.NewBuffer(payload))
    if err != nil {
        panic(err)
    }
    
    req.Header.Set("Content-Type", "application/json")
    
    res, err := client.Do(req)
    if err != nil {
        panic(err)
    }
    defer res.Body.Close()
    
    body, err := ioutil.ReadAll(res.Body)
    if err != nil {
        panic(err)
    }
    
    println(string(body))
}
''';
      default:
        return 'Unsupported language';
    }
  }

  void _updateCodeSnippet(String? value) {
    if (value == null) return;
    setState(() {
      _selectedLanguage = value;
      _codeController.text = _generateCodeSnippet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return fluent.Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fluent.Text('Select Language:', style: fluent.FluentTheme.of(context).typography.body),
            fluent.ComboBox<String>(
              value: _selectedLanguage,
              items: _languages
                  .map((lang) => fluent.ComboBoxItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: _updateCodeSnippet,
            ),
            const SizedBox(height: 10),
            fluent.TextBox(
              readOnly: true,
              maxLines: 10,
              controller: _codeController,
            ),
            const SizedBox(height: 10),
            fluent.FilledButton(
              child: const Text('Copy Snippet'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _codeController.text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
