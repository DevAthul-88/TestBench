import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketTester extends StatefulWidget {
  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketTester> {
  final _urlController = TextEditingController();
  final _messageController = TextEditingController();
  WebSocketChannel? _channel;
  bool _isConnected = false;
  List<String> _messages = [];

  void _connect() {
    if (_urlController.text.isEmpty) return;

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(_urlController.text),
      );
      
      setState(() {
        _isConnected = true;
      });

      _channel!.stream.listen(
        (message) {
          setState(() {
            _messages.add('Received: $message');
          });
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _messages.add('Error: $error');
          });
        },
        onDone: () {
          setState(() {
            _isConnected = false;
            _messages.add('Connection closed');
          });
        },
      );
    } catch (e) {
      setState(() {
        _messages.add('Connection error: $e');
      });
    }
  }

  void _disconnect() {
    _channel?.sink.close();
    setState(() {
      _isConnected = false;
      _channel = null;
    });
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty || _channel == null) return;
    
    _channel!.sink.add(_messageController.text);
    setState(() {
      _messages.add('Sent: ${_messageController.text}');
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fluent.Card(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: fluent.TextBox(
                          controller: _urlController,
                          placeholder: 'Enter WebSocket URL (ws:// or wss://)',
                          enabled: !_isConnected,
                        ),
                      ),
                      SizedBox(width: 8),
                      fluent.FilledButton(
                        child: Text(_isConnected ? 'Disconnect' : 'Connect'),
                        onPressed: _isConnected ? _disconnect : _connect,
                      ),
                    ],
                  ),
                  if (_isConnected) ...[
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: fluent.TextBox(
                            controller: _messageController,
                            placeholder: 'Enter message to send...',
                          ),
                        ),
                        SizedBox(width: 8),
                        fluent.FilledButton(
                          child: Text('Send'),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: fluent.Card(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: fluent.FluentTheme.of(context).typography.subtitle,
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(_messages[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _messageController.dispose();
    _channel?.sink.close();
    super.dispose();
  }
}