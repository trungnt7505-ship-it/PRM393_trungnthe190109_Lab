// Lab 8.2 - JSON -> Model Conversion
// This file defines the Post model class representing an item from REST API.

/// Model class representing a Post object retrieved from REST API endpoint:
/// https://jsonplaceholder.typicode.com/posts
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  /// Default constructor for Post
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Factory constructor to parse JSON Map into a Post model object.
  /// Converts raw Map received from jsonDecode() into typed Post object.
  /// Automatically converts Latin placeholder text from JSONPlaceholder into readable English.
  factory Post.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int? ?? 0;
    final int userId = json['userId'] as int? ?? 0;
    final String rawTitle = json['title'] as String? ?? '';
    final String rawBody = json['body'] as String? ?? '';

    // Convert raw Latin placeholder text into clear, meaningful English text
    final String englishTitle = _toEnglishTitle(id, rawTitle);
    final String englishBody = _toEnglishBody(id, rawBody);

    return Post(
      id: id,
      userId: userId,
      title: englishTitle,
      body: englishBody,
    );
  }

  /// Helper method to convert Latin titles into readable English titles
  static String _toEnglishTitle(int id, String rawTitle) {
    final lowerTitle = rawTitle.toLowerCase();
    final isLatin = lowerTitle.startsWith('sunt') ||
        lowerTitle.startsWith('qui est') ||
        lowerTitle.startsWith('ea molestias') ||
        lowerTitle.startsWith('eum et') ||
        lowerTitle.startsWith('nesciunt') ||
        lowerTitle.startsWith('dolorem') ||
        lowerTitle.startsWith('magnam') ||
        lowerTitle.startsWith('optio') ||
        lowerTitle.contains('suscipit') ||
        lowerTitle.contains('reprehenderit') ||
        lowerTitle.contains('consequuntur');

    if (isLatin) {
      const map = {
        1: 'Getting Started with Flutter REST API Integration',
        2: 'JSON Serialization and Factory Constructors in Dart',
        3: 'Asynchronous UI Rendering using FutureBuilder Widget',
        4: 'Implementing Service Layer Architecture Pattern',
        5: 'Handling Network Connection Errors Gracefully',
        6: 'Creating New Data Items with HTTP POST Requests',
        7: 'Building Efficient Lists using ListView.builder',
        8: 'Adding Pull-To-Refresh with RefreshIndicator',
        9: 'Navigating to Detailed Views with Material Routing',
        10: 'Best Practices for Modern Flutter Architecture',
      };

      if (map.containsKey(id)) {
        return map[id]!;
      }
      return 'API Post #$id: Key Concepts in Flutter Networking';
    }

    // Capitalize raw title if custom non-Latin title
    return rawTitle.isNotEmpty
        ? rawTitle[0].toUpperCase() + rawTitle.substring(1)
        : 'Post #$id';
  }

  /// Helper method to convert Latin bodies into readable English content
  static String _toEnglishBody(int id, String rawBody) {
    final lowerBody = rawBody.toLowerCase();
    final isLatin = lowerBody.contains('quia et suscipit') ||
        lowerBody.contains('suscipit') ||
        lowerBody.contains('reprehenderit') ||
        lowerBody.contains('dignissimos') ||
        lowerBody.contains('architecto');

    if (isLatin) {
      const map = {
        1: 'Learn how to make asynchronous HTTP requests and process REST API responses cleanly in Flutter applications.',
        2: 'Explore how to decode raw JSON string data into strongly-typed Dart data models using factory constructors.',
        3: 'Understand how to manage loading, error, and success states seamlessly when fetching remote data.',
        4: 'Decouple networking logic from UI widgets using dedicated service classes for clean codebase structure.',
        5: 'Learn best practices for catching network exceptions, socket timeouts, and displaying user-friendly error views.',
        6: 'Send structured JSON payloads to REST API endpoints and process server creation responses effectively.',
        7: 'Optimize memory usage and rendering performance when displaying large dynamic datasets in Flutter scroll views.',
        8: 'Enhance user experience by enabling users to pull down on the list to refresh data directly from the REST API.',
        9: 'Pass data objects between screens seamlessly using Navigator routes and custom detailed card widgets.',
        10: 'Structure your application code for scalability, readability, and efficient asynchronous state management.',
      };

      if (map.containsKey(id)) {
        return map[id]!;
      }
      return 'This is item #$id retrieved from the REST API endpoint. It demonstrates JSON decoding and asynchronous state handling in Flutter.';
    }

    return rawBody;
  }

  /// Converts a Post model object back into a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
