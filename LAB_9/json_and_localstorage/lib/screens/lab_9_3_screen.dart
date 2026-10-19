import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/json_storage_service.dart';

// ============================================================================
// Lab 9.3 - JSON CRUD Mini Database (Search + Edit + Delete)
// English Step-by-Step implementation following the lab guide.
// ============================================================================
class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final JsonStorageService _storageService =
      JsonStorageService(fileName: 'lab_9_3_crud_database.json');

  // --------------------------------------------------------------------------
  // Lab 9.3 - Step 1: Local Data Structure
  // Prepare in-memory list (_allItems) loaded from local JSON file.
  // --------------------------------------------------------------------------
  List<ItemModel> _allItems = [];
  List<ItemModel> _filteredItems = [];
  bool _isLoading = true;

  // Controller for Step 2 Search Bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDatabaseFromStorage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load JSON database from device storage
  Future<void> _loadDatabaseFromStorage() async {
    setState(() => _isLoading = true);
    final rawData = await _storageService.readJson();
    final items = rawData.map((e) => ItemModel.fromJson(e)).toList();

    setState(() {
      _allItems = items;
      _filterItems(_searchController.text);
      _isLoading = false;
    });
  }

  // --------------------------------------------------------------------------
  // Lab 9.3 - Step 2: Search Bar
  // Filter list by title, category, or description keyword.
  // --------------------------------------------------------------------------
  void _filterItems(String keyword) {
    if (keyword.trim().isEmpty) {
      setState(() {
        _filteredItems = List.from(_allItems);
      });
    } else {
      final query = keyword.toLowerCase().trim();
      setState(() {
        _filteredItems = _allItems.where((item) {
          return item.title.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  // --------------------------------------------------------------------------
  // Lab 9.3 - Step 4: Auto-Save
  // Re-save JSON file automatically after every CRUD action.
  // --------------------------------------------------------------------------
  Future<void> _autoSaveDatabase() async {
    final jsonList = _allItems.map((e) => e.toJson()).toList();
    await _storageService.writeJson(jsonList);
  }

  // --------------------------------------------------------------------------
  // Lab 9.3 - Step 3: Add / Edit / Delete Actions
  // --------------------------------------------------------------------------

  // Step 3.1: Add Item with Auto-generated Incremental ID
  Future<void> _addNewItem(String title, String category, String description) async {
    final nextId = _allItems.isEmpty
        ? 1
        : (_allItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);

    final newItem = ItemModel(
      id: nextId,
      title: title,
      category: category,
      description: description,
    );

    setState(() {
      _allItems.add(newItem);
      _filterItems(_searchController.text);
    });

    // Step 4: Auto-Save
    await _autoSaveDatabase();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added "${newItem.title}" and auto-saved!')),
      );
    }
  }

  // Step 3.2: Edit Item Fields
  Future<void> _editItem(ItemModel updatedItem) async {
    final index = _allItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      setState(() {
        _allItems[index] = updatedItem;
        _filterItems(_searchController.text);
      });

      // Step 4: Auto-Save
      await _autoSaveDatabase();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated "${updatedItem.title}" and auto-saved!')),
        );
      }
    }
  }

  // Step 3.3: Delete Item with Confirmation Dialog
  Future<void> _deleteItemWithConfirmation(ItemModel item) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _allItems.removeWhere((element) => element.id == item.id);
        _filterItems(_searchController.text);
      });

      // Step 4: Auto-Save
      await _autoSaveDatabase();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${item.title}" and auto-saved!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // Modal dialog helper for Add / Edit
  void _showAddEditDialog({ItemModel? existingItem}) {
    final isEditing = existingItem != null;
    final titleController =
        TextEditingController(text: isEditing ? existingItem.title : '');
    final categoryController =
        TextEditingController(text: isEditing ? existingItem.category : '');
    final descController =
        TextEditingController(text: isEditing ? existingItem.description : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Item (ID: ${existingItem.id})' : 'Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final category = categoryController.text.trim();
              final desc = descController.text.trim();

              if (title.isEmpty || category.isEmpty) {
                return;
              }

              Navigator.pop(context);

              if (isEditing) {
                _editItem(
                  existingItem.copyWith(
                    title: title,
                    category: category,
                    description: desc,
                  ),
                );
              } else {
                _addNewItem(title, category, desc);
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD Database'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDatabaseFromStorage,
            tooltip: 'Reload Database',
          ),
        ],
      ),
      // ----------------------------------------------------------------------
      // Lab 9.3 - Step 5: Improved UI
      // Includes search bar, styled cards, ListTile, action controls & FloatingActionButton.
      // ----------------------------------------------------------------------
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Step 2: Search Bar Input
                  TextField(
                    controller: _searchController,
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      hintText: 'Search by title, category, or keyword...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterItems('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter info count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Records: ${_allItems.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_searchController.text.isNotEmpty)
                        Text(
                          'Matching: ${_filteredItems.length}',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // List displaying CRUD items
                  Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'Database is empty. Tap + to add items.'
                                      : 'No items match "${_searchController.text}".',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    child: Text('${item.id}'),
                                  ),
                                  title: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Chip(
                                        label: Text(
                                          item.category,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(item.description),
                                    ],
                                  ),
                                  // Edit & Delete Action Buttons
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showAddEditDialog(
                                          existingItem: item,
                                        ),
                                        tooltip: 'Edit Item',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteItemWithConfirmation(item),
                                        tooltip: 'Delete Item',
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
      // Floating Action Button to Add New Item
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        tooltip: 'Add New Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
