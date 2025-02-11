import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:provider/provider.dart';

import '../providers/collection_provider.dart';
import '../models/collection_model.dart';

class CollectionsScreen extends StatefulWidget {
  @override
  _CollectionsScreenState createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addCollection() {
    if (_formKey.currentState!.validate() && _nameController.text.isNotEmpty) {
      final collection = CollectionModel(name: _nameController.text.trim());
      Provider.of<CollectionProvider>(context, listen: false)
          .addCollection(collection);
      _nameController.clear();
    }
  }

  void _confirmDelete(CollectionModel collection, CollectionProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return fluent.ContentDialog(
          title: Text('Delete Collection'),
          content: Text('Are you sure you want to delete "${collection.name}"? This action cannot be undone.'),
          actions: [
            fluent.Button(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            fluent.FilledButton(
              style: fluent.ButtonStyle(
                backgroundColor: fluent.ButtonState.all(fluent.Colors.red),
              ),
              child: Text('Delete'),
              onPressed: () {
                provider.removeCollection(collection);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = Provider.of<CollectionProvider>(context);

    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Collections',
            style: fluent.FluentTheme.of(context).typography.title,
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fluent.Card(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Collection',
                      style: fluent.FluentTheme.of(context).typography.subtitle,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: fluent.TextBox(
                            controller: _nameController,
                            placeholder: 'Enter collection name...',
                            prefix: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(fluent.FluentIcons.folder, size: 16),
                            ),
                            onSubmitted: (_) => _addCollection(),
                          ),
                        ),
                        SizedBox(width: 8),
                        fluent.FilledButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                Icon(fluent.FluentIcons.add, size: 16),
                                SizedBox(width: 8),
                                Text('Create Collection'),
                              ],
                            ),
                          ),
                          onPressed: _addCollection,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: fluent.Card(
                padding: EdgeInsets.all(16),
                child: collectionProvider.collections.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              fluent.FluentIcons.folder_search,
                              size: 48,
                              color: fluent.Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No Collections Yet',
                              style: fluent.FluentTheme.of(context).typography.subtitle,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Create your first collection to get started',
                              style: TextStyle(color: fluent.Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: collectionProvider.collections.length,
                        itemBuilder: (context, index) {
                          final collection = collectionProvider.collections[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: fluent.Card(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              backgroundColor: fluent.Colors.grey[10],
                              child: Row(
                                children: [
                                  Icon(fluent.FluentIcons.folder_open, size: 20),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      collection.name,
                                      style: fluent.FluentTheme.of(context).typography.body,
                                    ),
                                  ),
                                  fluent.IconButton(
                                    icon: Icon(
                                      fluent.FluentIcons.edit,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      // Implement edit functionality
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  fluent.IconButton(
                                    icon: Icon(
                                      fluent.FluentIcons.delete,
                                      size: 16,
                                      color: fluent.Colors.red,
                                    ),
                                    onPressed: () => _confirmDelete(collection, collectionProvider),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
    _nameController.dispose();
    super.dispose();
  }
}