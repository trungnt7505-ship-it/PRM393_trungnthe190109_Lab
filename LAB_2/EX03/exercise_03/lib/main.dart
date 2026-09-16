// Normal function using standard syntax
int calculateScoreBonus(int score) {
  if (score >= 80) {
    return 10;
  } else if (score >= 50) {
    return 5;
  } else {
    return 0;
  }
}

// Function using arrow syntax (lambda/shorthand)
String evaluateGrade(int score) => score >= 50 ? 'Passed' : 'Failed';

void main() {
  print('--- EXERCISE 3: CONTROL FLOW & FUNCTIONS ---');

  // ==========================================
  // 1. IF/ELSE BLOCK TO CHECK SCORE
  // ==========================================
  int studentScore = 75;
  print('\n1. If/Else Score Evaluation:');
  print('Student Score: $studentScore');

  if (studentScore >= 85) {
    print('Grade: Excellent');
  } else if (studentScore >= 70) {
    print('Grade: Good');
  } else if (studentScore >= 50) {
    print('Grade: Average');
  } else {
    print('Grade: Poor');
  }

  // ==========================================
  // 2. SWITCH CASE FOR DAY OF THE WEEK
  // ==========================================
  print('\n2. Switch Case (Day of Week):');
  String dayOfWeek = 'Wednesday';

  switch (dayOfWeek) {
    case 'Monday':
      print('Start of the work week.');
      break;
    case 'Wednesday':
      print('Midweek day, keep going!');
      break;
    case 'Friday':
      print('Almost weekend!');
      break;
    case 'Saturday':
    case 'Sunday':
      print('It is the weekend!');
      break;
    default:
      print('Regular weekday.');
      break;
  }

  // ==========================================
  // 3. LOOPS (for, for-in, forEach)
  // ==========================================
  print('\n3. Loop Examples with a Collection:');
  List<String> subjects = ['Math', 'Dart', 'Flutter', 'Database'];

  // Traditional standard 'for' loop using indexing
  print('-> Using standard "for" loop:');
  for (int i = 0; i < subjects.length; i++) {
    print('Index $i: ${subjects[i]}');
  }

  // 'for-in' loop
  print('-> Using "for-in" loop:');
  for (String subject in subjects) {
    print('Subject: $subject');
  }

  // 'forEach()' method with an anonymous function
  print('-> Using "forEach()" method:');
  subjects.forEach((subject) {
    print('Class: $subject');
  });

  // ==========================================
  // 4. FUNCTIONS (Normal syntax and Arrow syntax)
  // ==========================================
  print('\n4. Functions (Normal & Arrow Syntax):');

  int bonus = calculateScoreBonus(studentScore); // Normal function call
  print('Bonus points (Normal function): $bonus');

  String resultStatus = evaluateGrade(studentScore); // Arrow function call
  print('Evaluation status (Arrow function): $resultStatus');
}