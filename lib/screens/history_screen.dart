import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:provider/provider.dart';

import '../providers/request_provider.dart';
import '../models/request_model.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';

  Color _getStatusColor(int? statusCode) {
    if (statusCode == null) return fluent.Colors.grey;
    if (statusCode >= 200 && statusCode < 300) return fluent.Colors.green;
    if (statusCode >= 400) return fluent.Colors.red;
    return fluent.Colors.orange;
  }

  String _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return '#4CAF50';
      case 'POST':
        return '#2196F3';
      case 'PUT':
        return '#FF9800';
      case 'DELETE':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final filteredRequests = requestProvider.requests
        .where((request) =>
            request.url.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Request History',
            style: fluent.FluentTheme.of(context).typography.title,
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            fluent.Card(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: fluent.TextBox(
                      placeholder: 'Search by URL...',
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(fluent.FluentIcons.search, size: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  fluent.FilledButton(
                    child: Text('Clear History'),
                    onPressed: () {
                      // Implement clear history logic
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            fluent.FluentIcons.history,
                            size: 48,
                            color: fluent.Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No requests found',
                            style: fluent.FluentTheme.of(context)
                                .typography
                                .subtitle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Start making requests to see them here'
                                : 'Try adjusting your search query',
                            style: TextStyle(color: fluent.Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: fluent.Card(
                            padding: EdgeInsets.all(12),
                            backgroundColor: fluent.Colors.grey[10],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Color(
                                            int.parse(_getMethodColor(request.method)
                                                .replaceAll('#', '0xFF'))),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        request.method,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        request.url,
                                        style: fluent.FluentTheme.of(context)
                                            .typography
                                            .body,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (request.response != null)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                              request.response?.statusCode),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${request.response!.statusCode}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    SizedBox(width: 8),
                                    fluent.IconButton(
                                      icon: Icon(fluent.FluentIcons.sync),
                                      onPressed: () {
                                        // Implement logic to re-send request
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}