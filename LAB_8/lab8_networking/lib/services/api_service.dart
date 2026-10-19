import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

// Lab 8.4 - Service Layer Pattern (ApiService)
// Encapsulates all networking operations and decouples API logic from UI widgets.

/// Service class responsible for making REST API calls to JSONPlaceholder.
class ApiService {
  // Base URL for the public REST API endpoint
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Optional http.Client injection for testability and flexibility
  final http.Client client;

  /// Constructor allows injecting a custom http.Client (useful for unit tests)
  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Lab 8.1 & 8.2 & 8.4 - Simple GET Request & JSON parsing
  /// Fetches the list of posts from GET /posts.
  /// 
  /// Returns a Future containing a List of Post objects.
  /// Throws an Exception if the server response status code is not 200 (OK)
  /// or if a network error occurs.
  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');

    try {
      // Make async HTTP GET request with a 10-second timeout
      final response = await client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      // Verify if the HTTP response code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode raw JSON string response into a List of dynamic objects
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Map each JSON object in the list into a Post model object using factory Post.fromJson
        return jsonList
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Handle unexpected HTTP status code
        throw Exception(
            'Failed to load posts. Server responded with status code: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network connectivity issues
      throw Exception('No internet connection. Please check your network settings.');
    } on FormatException {
      // Handle bad JSON format response
      throw Exception('Bad response format received from server.');
    } catch (e) {
      // Rethrow error with user friendly message or original exception
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// Optional / Lab 8.4 - Send POST Request to create a new item.
  /// Sends a POST request to /posts with title and body parameters.
  ///
  /// Returns the newly created Post returned by the API (HTTP 201 Created).
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/posts');

    try {
      // Construct JSON request body
      final requestPayload = jsonEncode({
        'title': title,
        'body': body,
        'userId': userId,
      });

      // Make async HTTP POST request
      final response = await client
          .post(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: requestPayload,
          )
          .timeout(const Duration(seconds: 10));

      // Verify HTTP status code 201 (Created) or 200 (OK)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Post.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to create post. Server returned status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check network and try again.');
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }
}
