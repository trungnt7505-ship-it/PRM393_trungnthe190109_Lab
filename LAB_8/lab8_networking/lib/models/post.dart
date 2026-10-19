// Lab 8.2 - JSON -> Model Conversion
// This file defines the Post model class representing a item from JSONPlaceholder API.

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
  /// Converts raw Map<String, dynamic> received from jsonDecode() into typed Post object.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  /// Converts a Post model object back into a JSON Map.
  /// Useful for sending data via POST or PUT requests to a REST API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
