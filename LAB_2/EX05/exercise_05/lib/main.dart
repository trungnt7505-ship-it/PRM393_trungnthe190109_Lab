import 'dart:async';

// ==========================================
// 1. CREATE AN ASYNC FUNCTION USING Future + await
// ==========================================
// Simulate fetching user data with a Future
Future<String> fetchUserData() async {
  print('Fetching user data...');

  // 2. USE Future.delayed() TO SIMULATE LOADING
  await Future.delayed(Duration(seconds: 2));

  return 'User: Nguyen Trung (Software Engineering Student)';
}

// ==========================================
// 4. CREATE A SIMPLE STREAM OF INTEGERS
// ==========================================
// A function that returns a Stream emitting numbers every second
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Emit the value into the stream
  }
}

void main() async {
  print('--- EXERCISE 5: ASYNC, FUTURE, NULL SAFETY & STREAMS ---');

  // ==========================================
  // 1 & 2. ASYNC / AWAIT & FUTURE.DELAYED()
  // ==========================================
  print('\n1 & 2. Testing Future & Async/Await:');

  // Call the async function and wait for the result
  String userData = await fetchUserData();
  print('Received: $userData');

  // ==========================================
  // 3. PRACTICE NULL-SAFETY OPERATORS (?, ??, !)
  // ==========================================
  print('\n3. Testing Null-Safety Operators (?, ??, !):');

  // ? : Nullable type declaration
  String? nullableName;
  print('Nullable variable with null value: $nullableName');

  // ?? : Null-coalescing operator (provides a default value if null)
  String displayName = nullableName ?? 'Guest User';
  print('Using "??" operator: $displayName');

  // Assign a value to test non-null scenarios
  nullableName = 'Dart Developer';

  // ! : Null-assertion operator (asserts that the variable is not null)
  int nameLength = nullableName!.length;
  print('Using "!" operator (Length of "$nullableName"): $nameLength');

  // ==========================================
  // 4. LISTEN TO VALUES FROM A STREAM
  // ==========================================
  print('\n4. Testing Streams (Listening to emitted values):');
  print('Listening to countStream(3)...');

  // Create a stream subscription to listen to values
  StreamSubscription<int> subscription = countStream(3).listen(
        (int value) {
      print('Stream value received: $value');
    },
    onDone: () {
      print('Stream finished!');
    },
    onError: (error) {
      print('Stream error: $error');
    },
  );

  // Wait long enough for the stream to finish before ending the main function
  await Future.delayed(Duration(seconds: 4));

  // Optional: Cancel subscription if needed
  // await subscription.cancel();
}