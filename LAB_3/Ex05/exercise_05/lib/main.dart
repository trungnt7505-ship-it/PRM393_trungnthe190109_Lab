// Settings class implementing the Singleton pattern via a Factory Constructor
class Settings {
  final String theme;
  final String language;

  // Static cache field to hold the single instance
  static Settings? _instance;

  // Private constructor to prevent direct instantiation using 'new' from outside
  Settings._internal({required this.theme, required this.language});

  // Factory constructor checking the cache before creating a new instance
  factory Settings({String theme = 'Dark', String language = 'English'}) {
    if (_instance == null) {
      print('Creating a new Settings instance (Cache was empty).');
      _instance = Settings._internal(theme: theme, language: language);
    } else {
      print('Returning cached Settings instance.');
    }
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: $theme, language: $language)';
}

void main() {
  print('--- Exercise 5: Factory Constructors & Cache ---');

  // Instantiate the first settings object
  print('--- Calling Settings() #1 ---');
  Settings settings1 = Settings(theme: 'Dark', language: 'Vietnamese');
  print('Instance 1: $settings1');

  // Instantiate the second settings object with different configuration parameters
  print('\n--- Calling Settings() #2 ---');
  Settings settings2 = Settings(theme: 'Light', language: 'Japanese');
  print('Instance 2: $settings2');

  // Verify whether both variables point to the exact same object instance (Singleton check)
  bool areIdentical = identical(settings1, settings2);
  print('\nVerification: identical(settings1, settings2) -> $areIdentical');

  if (areIdentical) {
    print('✅ Success: Factory constructor successfully implemented caching / singleton pattern!');
  } else {
    print('❌ Failure: Instances are distinct.');
  }
}