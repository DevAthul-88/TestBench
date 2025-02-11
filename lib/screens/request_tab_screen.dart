import 'dart:convert';
import 'package:flutter/material.dart' show MaterialColor;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:syntax_highlight/syntax_highlight.dart';
import '../widgets/authentication_section.dart';
import '../widgets/code_snippet_generator.dart';
import '../providers/request_provider.dart';
import '../models/request_model.dart';

class RequestTabScreen extends StatefulWidget {
  const RequestTabScreen({Key? key}) : super(key: key);

  @override
  _RequestTabScreenState createState() => _RequestTabScreenState();
}

class _RequestTabScreenState extends State<RequestTabScreen> {
  final _urlController = TextEditingController();
  final _bodyController = TextEditingController();
  final _headersController = TextEditingController();
  final _scrollController = ScrollController();

  int _currentTabIndex = 0;

  String _selectedMethod = 'GET';
  String _responseBody = '';
  int _statusCode = 0;
  Map<String, String> _responseHeaders = {};
  bool _isLoading = false;
  Highlighter? _highlighter;

  final _methodOptions = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD'];

  @override
  void initState() {
    super.initState();
    _initializeSyntaxHighlighter();
  }

  Future<void> _initializeSyntaxHighlighter() async {
    await Highlighter.initialize(['json']);
    var theme = await HighlighterTheme.loadDarkTheme();
    setState(() {
      _highlighter = Highlighter(language: 'json', theme: theme);
    });
  }

  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
      _responseBody = '';
      _statusCode = 0;
      _responseHeaders = {};
    });

    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);

    try {
      // Parse additional headers
      Map<String, String> additionalHeaders = {};
      if (_headersController.text.isNotEmpty) {
        LineSplitter.split(_headersController.text).forEach((line) {
          final parts = line.split(':');
          if (parts.length == 2) {
            additionalHeaders[parts[0].trim()] = parts[1].trim();
          }
        });
      }

      final request = RequestModel(
        url: _urlController.text,
        method: _selectedMethod,
        body: _bodyController.text,
        headers: additionalHeaders,
      );

      http.Response response;
      switch (_selectedMethod) {
        case 'GET':
          response = await http.get(
            Uri.parse(request.url),
            headers: additionalHeaders,
          );
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(request.url),
            body: request.body,
            headers: {
              'Content-Type': 'application/json',
              ...additionalHeaders,
            },
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(request.url),
            body: request.body,
            headers: {
              'Content-Type': 'application/json',
              ...additionalHeaders,
            },
          );
          break;
        case 'DELETE':
          response = await http.delete(
            Uri.parse(request.url),
            headers: additionalHeaders,
          );
          break;
        default:
          throw UnimplementedError('Method not supported');
      }

      setState(() {
        _responseBody = response.body;
        _statusCode = response.statusCode;
        _responseHeaders = response.headers;
        _isLoading = false;
      });

      request.response = response;
      requestProvider.addRequest(request);
    } catch (e) {
      setState(() {
        _responseBody = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: PageHeader(
        title: Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            'API Request Builder',
            style: FluentTheme.of(context).typography.title,
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // 🔹 Wrap content with this
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildRequestBar(),
                      const SizedBox(height: 20),
                      _buildRequestTabs(),
                      const SizedBox(height: 20),
                      Expanded(child: _buildResponseSection()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRequestBar() {
    return Card(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: ComboBox<String>(
              value: _selectedMethod,
              items: _methodOptions
                  .map((method) => ComboBoxItem(
                        value: method,
                        child: Text(
                          method,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextBox(
              controller: _urlController,
              placeholder: 'Enter API endpoint URL',
              prefix: Padding(
                padding: const EdgeInsets.only(left: 8),
                child:
                    Icon(FluentIcons.link, size: 16, color: Colors.grey[100]),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _sendRequest,
            child: Row(
              children: [
                const Icon(FluentIcons.send, size: 14),
                const SizedBox(width: 8),
                const Text('Send'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTabs() {
    return SizedBox(
      height: 200,
      child: TabView(
        currentIndex: _currentTabIndex,
        onChanged: (index) => setState(() => _currentTabIndex = index),
        tabs: [
          Tab(
            text: const Text('Body'),
            icon: const Icon(FluentIcons.code),
            body: Card(
              padding: const EdgeInsets.all(16),
              child: TextBox(
                controller: _bodyController,
                placeholder: 'Enter request body in JSON format',
                maxLines: null,
              ),
            ),
          ),
          Tab(
            text: const Text('Headers'),
            icon: const Icon(FluentIcons.header),
            body: Card(
              padding: const EdgeInsets.all(16),
              child: TextBox(
                controller: _headersController,
                placeholder:
                    'Enter headers (one per line)\nExample: Content-Type: application/json',
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseSection() {
    return Card(
      backgroundColor: Colors.grey[20],
      padding: const EdgeInsets.all(20),
      child: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProgressRing(),
                  SizedBox(height: 16),
                  Text('Sending request...'),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Response',
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    const SizedBox(width: 12),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    backgroundColor: Colors.grey[30],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_responseHeaders.isNotEmpty) ...[
                          _buildHeadersSection(),
                          const SizedBox(height: 16),
                        ],
                        Expanded(child: _buildResponseContent()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatusBadge() {
    if (_statusCode == 0) return const SizedBox.shrink();

    final bool isSuccess = _statusCode >= 200 && _statusCode < 300;
    final Color backgroundColor = isSuccess ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? FluentIcons.completed : FluentIcons.error_badge,
            size: 12,
            color: backgroundColor,
          ),
          const SizedBox(width: 6),
          Text(
            '$_statusCode',
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadersSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Headers',
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[40],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _responseHeaders.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[130],
                      fontFamily: 'Consolas',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseContent() {
    if (_responseBody.isEmpty) {
      return SizedBox(
        height: 20,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.code, size: 48, color: Colors.grey[80]),
              const SizedBox(height: 12),
              Text(
                'Response will appear here',
                style: TextStyle(color: Colors.grey[120]),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[40],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body',
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          const SizedBox(height: 8),
          _buildHighlightedResponseBody(),
        ],
      ),
    );
  }

  Widget _buildHighlightedResponseBody() {
    if (_responseBody.isEmpty) return const Text('No response yet');

    final formattedJson = _formatResponseBody();

    if (_highlighter == null) {
      return Text(
        formattedJson,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Consolas',
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: RichText(
        text: _highlighter!.highlight(formattedJson),
      ),
    );
  }

  String _formatResponseBody() {
    try {
      final parsedJson = jsonDecode(_responseBody);
      return JsonEncoder.withIndent('  ').convert(parsedJson);
    } catch (e) {
      return _responseBody;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    _headersController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
