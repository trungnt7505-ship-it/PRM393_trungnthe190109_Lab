// ==========================================
// 1. CREATE A CLASS Car WITH PROPERTIES & A METHOD
// ==========================================
class Car {
  // Property (field)
  String brand;
  int year;

  // Standard constructor
  Car(this.brand, this.year);

  // ==========================================
  // 2. CREATE A NAMED CONSTRUCTOR
  // ==========================================
  // Named constructor to initialize a default/generic car
  Car.factoryDefault()
      : brand = 'Generic Brand',
        year = 2024;

  // Method to be inherited or overridden
  void startEngine() {
    print('The engine of the $brand ($year) car is starting with gasoline power.');
  }
}

// ==========================================
// 3. CREATE A SUBCLASS ElectricCar THAT OVERRIDES A METHOD
// ==========================================
class ElectricCar extends Car {
  // Additional property specific to ElectricCar
  int batteryCapacity;

  // Constructor using 'super' to pass parameters to the parent class
  ElectricCar(String brand, int year, this.batteryCapacity) : super(brand, year);

  // Overriding the parent method
  @override
  void startEngine() {
    print('The silent electric engine of the $brand ($year) car is powering on. Battery: $batteryCapacity kWh.');
  }
}

// ==========================================
// 4. INSTANTIATE OBJECTS AND PRINT RESULTS
// ==========================================
void main() {
  print('--- EXERCISE 4: INTRO TO OOP ---');

  // Instantiate standard Car object using standard constructor
  Car regularCar = Car('Toyota', 2022);
  print('\n[Regular Car Object]:');
  print('Brand: ${regularCar.brand}, Year: ${regularCar.year}');
  regularCar.startEngine();

  // Instantiate Car object using the Named Constructor
  Car defaultCar = Car.factoryDefault();
  print('\n[Named Constructor Car Object]:');
  print('Brand: ${defaultCar.brand}, Year: ${defaultCar.year}');
  defaultCar.startEngine();

  // Instantiate ElectricCar (subclass) object
  ElectricCar myTesla = ElectricCar('Tesla Model 3', 2024, 75);
  print('\n[Subclass ElectricCar Object]:');
  print('Brand: ${myTesla.brand}, Year: ${myTesla.year}, Battery: ${myTesla.batteryCapacity}kWh');
  myTesla.startEngine(); // Calls the overridden method
}