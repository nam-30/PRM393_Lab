import 'dart:async';

void main() async {
  print('--- Exercise 1: Basic Syntax & Data Types ---');
  exercise1();

  print('\n--- Exercise 2: Collections & Operators ---');
  exercise2();

  print('\n--- Exercise 3: Control Flow & Functions ---');
  exercise3();

  print('\n--- Exercise 4: Intro to OOP ---');
  exercise4();

  print('\n--- Exercise 5: Async, Future, Null Safety & Streams ---');
  await exercise5();
}
// Exercise 1 - Basic Syntax & Data Types
void exercise1() {
  int age = 25;
  double score = 98.5;
  String name = "Alex";
  bool isActive = true;
  print("User: $name");
  print("Active Status: $isActive");
  print("Score: $score (With bonus: ${score + 5.0})");
  print("Age Details: $age years old, which is ${age * 12} months.");
}
// Exercise 2 - Collections & Operators
void exercise2() {
  List<int> list = [10, 20];
  list.add(30);
  list.remove(20);
  int first = list[0];
  int sum = list[0] + list[1];
  bool check = (sum == 40) && (first > 0);
  String result = check ? "Hợp lệ" : "Lỗi";
  Set<int> set = {1, 2, 2};
  set.add(3);
  set.remove(1);
  Map<String, int> scores = {'An': 90};
  scores['Bình'] = 80;
  int anScore = scores['An']!;
  scores.remove('Bình');

  print("List: $list ($result) | Set: $set | Map: $scores");
}


// Exercise 3 - Control Flow & Functions

void exercise3() {
  int score = 85;
  if (score >= 90) {
    print("Grade: A");
  } else if (score >= 70) {
    print("Grade: B");
  } else {
    print("Grade: C or below");
  }

  String day = "Monday";
  switch (day) {
    case "Monday":
      print("Start of the work week");
    case "Friday":
      print("Weekend is near!");
    default:
      print("Midweek or Weekend");
  }

  List<String> items = ["Dart", "Flutter", "Mobile"];

  for (int i = 0; i < items.length; i++) {
    print("For loop ($i): ${items[i]}");
  }

  for (var item in items) {
    print("For-in loop: $item");
  }

  items.forEach((item) => print("forEach loop: $item"));
  print("Evaluation: ${evaluateScore(score)}");
  print("Square of 5: ${squareNumber(5)}");
}

String evaluateScore(int score) {
  if (score >= 80) return "Excellent";
  if (score >= 50) return "Pass";
  return "Fail";
}

int squareNumber(int n) => n * n;


// Exercise 4 - Intro to OOP

void exercise4() {
  Car myCar = Car("Toyota");
  myCar.drive();
  Car unknownCar = Car.unknown();
  unknownCar.drive();
  ElectricCar myEV = ElectricCar("Tesla", 100);
  myEV.drive();
}

class Car {
  String brand;
  Car(this.brand);
  Car.unknown() : brand = "Unknown Brand";

  void drive() {
    print("The $brand car is driving.");
  }
}

class ElectricCar extends Car {
  int batteryCapacity;
  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print("The electric $brand is driving silently with $batteryCapacity kWh battery.");
  }
}

// ==========================================
// Exercise 5 - Async, Future, Null Safety & Streams
// ==========================================

Future<void> exercise5() async {
  String? nullableString;

  print('Null string with ??: ${nullableString ?? 'Default Value'}');

  nullableString = 'Now not null';
  print('Length of string with ?.: ${nullableString?.length}');
  print('Length of string with !: ${nullableString!.length}');

  print('Fetching data... (simulating network request)');
  String data = await fetchData();
  print(data);

  print('Listening to stream:');
  Stream<int> myStream = countStream(3);
  await for (int value in myStream) {
    print('Stream value: $value');
  }
}

Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded successfully!';
}

Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
