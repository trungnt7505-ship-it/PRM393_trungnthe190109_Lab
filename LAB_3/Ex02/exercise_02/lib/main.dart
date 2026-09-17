import 'dart:convert';

//Define the User model
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor to instantiate a User object from a Map (JSON decoding)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

//UserRepository simulating fetching data from a JSON API
class UserRepository {
  // Mock API response in JSON string format
  final String _mockApiResponse = '''
  [
    {"name": "Nguyen Thanh Trung", "email": "trungnt7505@gmail.com"},
    {"name": "Nguyen Van A", "email": "nguyenvan@gmail.com"},
    {"name": "Dao Quang Huy", "email": "huydq@gmail.com"}
  ]
  ''';

  // Future<List<User>> simulating async API call and JSON parsing
  Future<List<User>> fetchUsers() async {
    print('🌐 Fetching data from API...');
    await Future.delayed(Duration(seconds: 1)); // Simulate network latency

    // Decode JSON string into a dynamic List
    List<dynamic> jsonList = jsonDecode(_mockApiResponse);

    // Map each JSON item to a User object using User.fromJson
    List<User> users = jsonList.map((jsonItem) => User.fromJson(jsonItem)).toList();

    return users;
  }
}

void main() async {
  print('--- Exercise 2: User Repository with JSON ---');
  final userRepository = UserRepository();

  // Call the asynchronous method to fetch users
  List<User> users = await userRepository.fetchUsers();

  print('✅ Parsed Users successfully:');
  for (var user in users) {
    print(' - $user');
  }
}