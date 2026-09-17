void main() async {
  print('--- Exercise 4: Stream Transformation ---');

  // 1. Create a Stream emitting integers from 1 to 5 using Stream.fromIterable
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Original Stream -> Transformation Pipeline (x * x, then filter even numbers):');

  // 2. Apply stream transformation operators:
  // - map(): Transforms each value x into its square (x * x)
  // - where(): Filters to keep only even numbers
  Stream<int> transformedStream = numberStream
      .map((number) {
    int squared = number * number;
    print('   [map] Transformed $number -> $squared');
    return squared;
  })
      .where((squaredNumber) {
    bool isEven = squaredNumber % 2 == 0;
    print('   [where] Checked if $squaredNumber is even: $isEven');
    return isEven;
  });

  // 3. Listen and print the final emitted values from the transformed stream
  await for (int value in transformedStream) {
    print('🎯 [Stream Output] Emitted final value: $value\n');
  }
}