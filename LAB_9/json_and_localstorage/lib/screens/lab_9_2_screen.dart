import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/json_storage_service.dart';

// ============================================================================
// Lab 9.2 - Save & Load JSON From Device Storage
// English Step-by-Step implementation following the lab guide.
// ============================================================================
class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  // --------------------------------------------------------------------------
  // Lab 9.2 - Step 1: Add path_provider
  // (path_provider dependency is declared in pubspec.yaml)
  //
  // Lab 9.2 - Step 2: Create a Storage Service
  // (JsonStorageService initialized for file 'lab_9_2_storage.json')
  // --------------------------------------------------------------------------
  final JsonStorageService _storageService =
      JsonStorageService(fileName: 'lab_9_2_storage.json');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<ItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // ------------------------------------------------------------------------
    // Lab 9.2 - Step 3: Load Data at Startup
    // Read JSON file during initState and load items into the list.
    // ------------------------------------------------------------------------
    _loadDataAtStartup();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Helper method for Step 3: Load local storage JSON at startup
  Future<void> _loadDataAtStartup() async {
    setState(() => _isLoading = true);
    final List<dynamic> rawData = await _storageService.readJson();
    setState(() {
      _items = rawData.map((e) => ItemModel.fromJson(e)).toList();
      _isLoading = false;
    });
  }

  // --------------------------------------------------------------------------
  // Lab 9.2 - Step 4: UI for Adding Items
  // TextField + Add button -> append items to list in memory.
  // --------------------------------------------------------------------------
  void _addItemToList() {
    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Title and Category.')),
      );
      return;
    }

    final newId = _items.isEmpty
        ? 1
        : (_items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);

    final newItem = ItemModel(
      id: newId,
      title: title,
      category: category,
      description: description.isEmpty ? 'No description' : description,
    );

    setState(() {
      _items.add(newItem);
    });

    _titleController.clear();
    _categoryController.clear();
    _descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item appended to list. Click "Save to File" to persist!'),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Lab 9.2 - Step 5: Save Button
  // Write list to local JSON file and show confirmation message.
  // --------------------------------------------------------------------------
  Future<void> _saveDataToFile() async {
    final List<Map<String, dynamic>> jsonList =
        _items.map((e) => e.toJson()).toList();
    await _storageService.writeJson(jsonList);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data successfully saved to device storage!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Local File Storage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDataAtStartup,
            tooltip: 'Reload from File',
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // ----------------------------------------------------------
                  // Lab 9.2 - Step 4: UI for Adding Items (Input Form)
                  // ----------------------------------------------------------
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Add New Item',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Item Title',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _addItemToList,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item to Memory List'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Header with Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items List (${_items.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ------------------------------------------------------
                      // Lab 9.2 - Step 5: Save Button to persist to file
                      // ------------------------------------------------------
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _saveDataToFile,
                        icon: const Icon(Icons.save),
                        label: const Text('Save to File'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Display items list
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(
                            child: Text('No items in storage. Add one above!'),
                          )
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${item.id}'),
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text(
                                    '${item.category} • ${item.description}',
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
