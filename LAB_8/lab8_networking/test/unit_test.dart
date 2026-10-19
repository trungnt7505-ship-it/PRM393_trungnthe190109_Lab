import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8_networking/models/post.dart';
import 'package:lab8_networking/services/api_service.dart';

void main() {
  group('Lab 8.2 - Post Model Unit Tests', () {
    test('Post.fromJson correctly converts Map to Post object', () {
      final jsonMap = {
        'id': 1,
        'userId': 10,
        'title': 'Test Title',
        'body': 'Test Body Content',
      };

      final post = Post.fromJson(jsonMap);

      expect(post.id, equals(1));
      expect(post.userId, equals(10));
      expect(post.title, equals('Test Title'));
      expect(post.body, equals('Test Body Content'));
    });

    test('Post.toJson converts Post object to Map correctly', () {
      const post = Post(
        id: 2,
        userId: 20,
        title: 'Sample Title',
        body: 'Sample Body',
      );

      final map = post.toJson();

      expect(map['id'], equals(2));
      expect(map['userId'], equals(20));
      expect(map['title'], equals('Sample Title'));
      expect(map['body'], equals('Sample Body'));
    });
  });

  group('Lab 8.4 - ApiService Unit Tests with Mock Client', () {
    test('fetchPosts returns List<Post> when HTTP call completes successfully (200)', () async {
      final mockClient = MockClient((request) async {
        final mockResponse = [
          {
            'id': 1,
            'userId': 1,
            'title': 'Post 1',
            'body': 'Body 1',
          },
          {
            'id': 2,
            'userId': 1,
            'title': 'Post 2',
            'body': 'Body 2',
          }
        ];
        return http.Response(jsonEncode(mockResponse), 200);
      });

      final apiService = ApiService(client: mockClient);
      final posts = await apiService.fetchPosts();

      expect(posts, isA<List<Post>>());
      expect(posts.length, equals(2));
      expect(posts[0].title, equals('Post 1'));
      expect(posts[1].title, equals('Post 2'));
    });

    test('fetchPosts throws Exception when HTTP call fails (404/500)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);

      expect(() => apiService.fetchPosts(), throwsException);
    });

    test('createPost returns new Post when POST call completes with status 201', () async {
      final mockClient = MockClient((request) async {
        final mockResponse = {
          'id': 101,
          'userId': 1,
          'title': 'New Post',
          'body': 'New Body',
        };
        return http.Response(jsonEncode(mockResponse), 201);
      });

      final apiService = ApiService(client: mockClient);
      final newPost = await apiService.createPost(
        title: 'New Post',
        body: 'New Body',
      );

      expect(newPost.id, equals(101));
      expect(newPost.title, equals('New Post'));
      expect(newPost.body, equals('New Body'));
    });
  });
}
