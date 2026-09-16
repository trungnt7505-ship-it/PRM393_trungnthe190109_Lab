void main() {
  print('--- EXERCISE 2: COLLECTIONS & OPERATORS ---');

  // ==========================================
  // 1. CREATE A LIST OF INTEGERS & USE OPERATORS
  // ==========================================
  // Create a list of integer values
  List<int> numbers = [10, 20, 30, 40, 50];
  print('Original List: $numbers');

  // Use indexing and arithmetic operators (+, -)
  int sumOfFirstAndLast = numbers[0] + numbers[4]; // 10 + 50
  int subtractionResult = numbers[3] - numbers[1]; // 40 - 20
  print('Sum of first and last elements: $sumOfFirstAndLast');
  print('Subtraction result (index 3 - index 1): $subtractionResult');

  // Use comparison operators (==, >, <, etc.) and conditional operator (? :)
  bool isEqual = (numbers[0] == 10);
  print('Is the first element equal to 10? $isEqual');

  String evaluation = (sumOfFirstAndLast > 50) ? 'Sum is large' : 'Sum is small';
  print('Evaluation using ternary operator (? :): $evaluation');

  // Use logical operators (&&, ||)
  bool isValid = (numbers.length > 3) && (numbers[0] < numbers[1]);
  print('Logical check (&&): $isValid');

  // ==========================================
  // 2. CREATE A SET AND A MAP
  // ==========================================
  // Create a Set to store unique values (duplicates will be automatically ignored)
  Set<String> uniqueTags = {'flutter', 'dart', 'mobile', 'flutter'};
  print('\nUnique Set (duplicates removed): $uniqueTags');

  // Create a Map for key-value storage
  Map<String, dynamic> studentInfo = {
    'name': 'Nguyen Trung',
    'age': 21,
    'isStudent': true,
  };
  print('Initial Map: $studentInfo');

  // ==========================================
  // 3. USE INDEXING, add(), remove(), AND MAP ACCESS
  // ==========================================
  // List modifications using add() and remove()
  numbers.add(60); // Add an element to the list
  numbers.remove(20); // Remove a specific element from the list
  print('Modified List after add(60) and remove(20): $numbers');

  // Set modifications using add() and remove()
  uniqueTags.add('programming');
  uniqueTags.remove('mobile');
  print('Modified Set after add and remove: $uniqueTags');

  // Map access using keys and updating values
  // Accessing values
  print('Student Name (Map access): ${studentInfo['name']}');

  // Adding/Updating key-value pairs in the Map
  studentInfo['major'] = 'Software Engineering'; // Add new key-value
  studentInfo['age'] = 22; // Update existing value
  print('Updated Map: $studentInfo');

  // Removing a key-value pair from the Map
  studentInfo.remove('isStudent');
  print('Map after removing "isStudent": $studentInfo');
}