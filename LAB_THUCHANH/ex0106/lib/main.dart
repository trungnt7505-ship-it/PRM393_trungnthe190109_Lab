class User {
  int id;
  String name;
  // TODO 1: Declare email as a nullable variable
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // TODO 2: Declare factory User.fromJson(Map<String, dynamic> json)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      // If name is null, use the ?? operator to set "Khách" as the default value
      name: json['name'] ?? "Khách",
      email: json['email'],
    );
  }

  void showProfile() {
    // TODO 3: Print out the profile details. Use the ?? operator to handle null email.
    String displayEmail = email ?? "Chưa cập nhật";
    print("ID: $id | Tên: $name | Email: $displayEmail");
  }
}

void main() {
  // Simulate JSON data returned from an API
  Map<String, dynamic> rawData1 = {"id": 1, "name": "Nam", "email": "nam@fpt.edu.vn"};
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  // TODO 4: Initialize user1 and user2 from the 2 Maps above using User.fromJson and call showProfile()
  print("--- User 1 Info ---");
  User user1 = User.fromJson(rawData1);
  user1.showProfile();

  print("\n--- User 2 Info (Null Data Handled) ---");
  User user2 = User.fromJson(rawData2);
  user2.showProfile();
}
