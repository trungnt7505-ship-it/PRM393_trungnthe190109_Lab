import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

// Optional Enhancement / POST Request - Form to create a new post via HTTP POST.
// Demonstrates sending JSON payload to REST API endpoint and handling async response.

class CreatePostScreen extends StatefulWidget {
  final ApiService apiService;

  const CreatePostScreen({super.key, required this.apiService});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Sends POST request to API using ApiService
  Future<void> _submitPost() async {
    // Validate form fields before submitting
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Call ApiService.createPost with form values
      final newPost = await widget.apiService.createPost(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (!mounted) return;

      // Show success feedback message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post #${newPost.id} created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Return created post back to list screen
      Navigator.of(context).pop(newPost);
    } catch (e) {
      if (!mounted) return;

      // Show error feedback message if POST request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post (POST)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Send POST Request to API',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter details below to create a new item on https://jsonplaceholder.typicode.com/posts',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Title Input Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter post title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Body Content Input Field
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Body Content',
                  hintText: 'Enter post content body...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button with Loading Indicator State
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? 'Submitting POST...' : 'Create Post',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
