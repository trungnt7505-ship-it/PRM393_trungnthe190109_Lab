import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

// ============================================================================
// Lab 9.2 - Step 2: Create a Storage Service
// Helper service to manage reading, creating, and saving JSON files locally.
// ============================================================================
class JsonStorageService {
  final String fileName;

  JsonStorageService({required this.fileName});

  // Lab 9.2 - Step 2.1: Locate the application documents directory
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // Lab 9.2 - Step 2.2: Read existing JSON file or create a new file if not found
  Future<List<dynamic>> readJson() async {
    try {
      final file = await _localFile;

      // Create new file pre-filled with asset template if file does not exist
      if (!await file.exists()) {
        String initialData = '[]';
        try {
          initialData = await rootBundle.loadString('assets/data/items.json');
        } catch (_) {
          initialData = '[]';
        }
        await file.writeAsString(initialData);
        return jsonDecode(initialData) as List<dynamic>;
      }

      final contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return [];
      }
      return jsonDecode(contents) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // Lab 9.2 - Step 2.3: Write updated JSON data back to local device storage
  Future<File> writeJson(List<dynamic> dataList) async {
    final file = await _localFile;
    final String jsonString = jsonEncode(dataList);
    return await file.writeAsString(jsonString);
  }
}
