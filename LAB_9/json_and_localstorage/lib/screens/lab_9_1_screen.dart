import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/item_model.dart';

// ============================================================================
// Lab 9.1 - Read JSON From Assets (Local Embedded File)
// English Step-by-Step implementation following the lab guide.
// ============================================================================
class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<ItemModel> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  // --------------------------------------------------------------------------
  // Lab 9.1 - Step 1: Project Setup
  // (Assets folder 'assets/data/items.json' contains the initial embedded JSON data)
  //
  // Lab 9.1 - Step 2: Register Assets in pubspec.yaml
  // (Configured under 'flutter: assets: - assets/data/items.json' in pubspec.yaml)
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // Lab 9.1 - Step 3: Load JSON File
  // Asynchronous method using rootBundle.loadString() to read the file content.
  // --------------------------------------------------------------------------
  Future<void> _loadAssetJson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step 3: Load raw JSON string from assets/data/items.json
      final String jsonString = await rootBundle.loadString('assets/data/items.json');

      // ----------------------------------------------------------------------
      // Lab 9.1 - Step 4: Decode JSON
      // Convert loaded string into a Dart List using jsonDecode().
      // ----------------------------------------------------------------------
      final List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        _items = jsonList.map((json) => ItemModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load JSON asset: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Read JSON From Assets'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Asset JSON',
            onPressed: _loadAssetJson,
          ),
        ],
      ),
      // ----------------------------------------------------------------------
      // Lab 9.1 - Step 5: Display Data
      // Use ListView / ListView.builder to show at least 2 fields per item.
      // ----------------------------------------------------------------------
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _items.isEmpty
                  ? const Center(child: Text('No items found in JSON asset.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              child: Text('${item.id}'),
                            ),
                            // Field 1: Title (Field per item)
                            title: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Field 2: Category & Description (Multiple fields per item)
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(item.description),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
