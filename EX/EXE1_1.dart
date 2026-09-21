// TODO 1: Định nghĩa class Vehicle với các thuộc tính String brand, int year.
// Viết Default constructor và hàm void startEngine().
class Vehicle {
  String brand;
  int year;
  Vehicle(this.brand, this.year);
  void startEngine() {
    print('Khởi động phương tiện...');
  }
}

// TODO 2: Định nghĩa class Car kế thừa từ Vehicle.
// Thêm thuộc tính bool isElectric.
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Viết constructor mặc định cho Car (dùng super để truyền brand và year).
  Car(String brand, int year, this.isElectric) : super(brand, year);

  // Viết Named Constructor: Car.tesla(int year) thiết lập sẵn brand="Tesla" và isElectric=true.
  Car.tesla(int year)
      : isElectric = true,
        super('Tesla', year);

  // TODO 4: Ghi đè (@override) hàm startEngine() để in ra thông báo chi tiết hơn.
  @override
  void startEngine() {
    if (isElectric) {
      print('Khởi động xe điện $brand ($year): Bật nguồn điện, khởi động êm ái không tiếng động...');
    } else {
      print('Khởi động xe xăng $brand ($year): Vroom vroom! Động cơ đốt trong nổ máy...');
    }
  }
}

void main() {
  // TODO 5: Khởi tạo một xe Car bình thường và gọi startEngine()
  Car normalCar = Car('Toyota', 2022, false);
  print('--- Xe thường ---');
  print('Hãng: ${normalCar.brand} | Năm: ${normalCar.year} | Xe điện: ${normalCar.isElectric}');
  normalCar.startEngine();

  print(''); // Dòng trống ngăn cách

  // TODO 6: Khởi tạo một xe Car bằng Named Constructor (Car.tesla) và gọi startEngine()
  Car teslaCar = Car.tesla(2024);
  print('--- Xe Tesla ---');
  print('Hãng: ${teslaCar.brand} | Năm: ${teslaCar.year} | Xe điện: ${teslaCar.isElectric}');
  teslaCar.startEngine();
}