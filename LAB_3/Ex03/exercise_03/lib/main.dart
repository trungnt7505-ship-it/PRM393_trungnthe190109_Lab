import 'dart:async';

void main() {
  print('--- Exercise 3: Async + Microtask Debugging ---');

  // 1. Synchronous code executes first
  print('1. Synchronous task: Start of main');

  // 2. Schedule an event via Future (placed into the Event Queue)
  Future(() {
    print('5. Event Queue: Future callback executed');
  });

  // 3. Schedule a microtask (placed into the Microtask Queue)
  scheduleMicrotask(() {
    print('3. Microtask Queue: scheduleMicrotask callback executed');
  });

  // 4. Another Future variant running immediately as a microtask
  Future.microtask(() {
    print('4. Microtask Queue: Future.microtask callback executed');
  });

  // 5. Schedule another regular Event Future to show queue ordering
  Future(() {
    print('6. Event Queue: Second Future callback executed');
  });

  // 6. Synchronous code at the end of main
  print('2. Synchronous task: End of main');

  
}