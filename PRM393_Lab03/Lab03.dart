import 'dart:async';
import 'dart:convert';

// ============================================================================
// EXERCISE 1: Product Model & Repository (Futures & Streams)
// ============================================================================
class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(1, 'Laptop', 999.99),
    Product(2, 'Mouse', 25.50),
  ];

  // StreamController.broadcast giúp nhiều nơi có thể cùng lắng nghe Stream
  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  // Future: Lấy toàn bộ danh sách (trả về 1 lần duy nhất)
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _products;
  }

  // Stream: Luồng dữ liệu phát ra mỗi khi có sản phẩm mới
  Stream<Product> liveAdded() => _controller.stream;

  // Thêm sản phẩm và phát thông báo qua Stream
  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product); // Đẩy dữ liệu vào luồng Stream
  }

  void dispose() {
    _controller.close();
  }
}

// ============================================================================
// EXERCISE 2: User Repository with JSON
// ============================================================================
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  // Factory constructor để ép kiểu dữ liệu Map (từ JSON) sang Object User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'] as String, json['email'] as String);
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

Future<List<User>> fetchUsers() async {
  await Future.delayed(const Duration(milliseconds: 100));

  // Chuỗi JSON giả lập nhận từ API
  const String rawJson = '''
  [
    {"name": "Nguyen Van A", "email": "a@gmail.com"},
    {"name": "Tran Thi B", "email": "b@gmail.com"}
  ]
  ''';

  // Giải mã chuỗi JSON thành List Map
  final List<dynamic> parsedList = jsonDecode(rawJson);

  // Chuyển từng phần tử Map thành đối tượng User
  return parsedList.map((item) => User.fromJson(item)).toList();
}

// ============================================================================
// EXERCISE 3: Async + Microtask Debugging
// ============================================================================
Future<void> runExercise3() async {
  print('1. [Sync] Code đồng bộ chạy đầu tiên');

  // Đưa vào Event Queue (độ ưu tiên thấp)
  Future(() {
    print('4. [Event Queue] Future chạy cuối cùng');
  });

  // Đưa vào Microtask Queue (độ ưu tiên cao)
  scheduleMicrotask(() {
    print('3. [Microtask Queue] Microtask chạy trước Event Queue');
  });

  print('2. [Sync] Code đồng bộ kết thúc');

  await Future.delayed(const Duration(milliseconds: 150));
}

// ============================================================================
// EXERCISE 4: Stream Transformation
// ============================================================================
Future<void> runExercise4() async {
  // Tạo Stream phát ra các số từ 1 đến 5
  final Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  final Stream<int> transformedStream = numbers
      .map((number) => number * number)   // Biến đổi: bình phương -> 1, 4, 9, 16, 25
      .where((square) => square.isEven);  // Lọc: chỉ giữ lại số chẵn -> 4, 16

  // Đọc dữ liệu ra từ Stream
  await for (final value in transformedStream) {
    print('Kết quả qua xử lý Stream: $value');
  }
}

// ============================================================================
// EXERCISE 5: Factory Constructors & Cache (Singleton Pattern)
// ============================================================================
class Settings {
  // Private constructor ngăn việc khởi tạo trực tiếp từ bên ngoài bằng new / Settings._internal()
  Settings._internal();

  // Biến static lưu trữ thể hiện duy nhất trong bộ nhớ
  static final Settings _instance = Settings._internal();

  // Factory constructor trả về thể hiện đã lưu sẵn
  factory Settings() {
    return _instance;
  }
}

// ============================================================================
// MAIN FUNCTION - THỰC THI LẦN LƯỢT 5 BÀI TẬP
// ============================================================================
void main() async {
  // --- EXERCISE 1 ---
  print('=== EXERCISE 1: Product Model & Repository ===');
  final repo = ProductRepository();

  // Đăng ký lắng nghe Stream trước
  repo.liveAdded().listen((product) {
    print('  [Stream Event] Đã thêm sản phẩm: $product');
  });

  final products = await repo.getAll();
  print('  Danh sách ban đầu: $products');

  // Thêm sản phẩm để kích hoạt Stream
  repo.addProduct(Product(3, 'Keyboard', 45.0));
  await Future.delayed(const Duration(milliseconds: 150));


  // --- EXERCISE 2 ---
  print('\n=== EXERCISE 2: User Repository with JSON ===');
  final users = await fetchUsers();
  print('  Danh sách User đã parse từ JSON:');
  for (var u in users) {
    print('   - $u');
  }


  // --- EXERCISE 3 ---
  print('\n=== EXERCISE 3: Async + Microtask Debugging ===');
  await runExercise3();


  // --- EXERCISE 4 ---
  print('\n=== EXERCISE 4: Stream Transformation ===');
  await runExercise4();


  // --- EXERCISE 5 ---
  print('\n=== EXERCISE 5: Factory Constructors & Cache ===');
  final s1 = Settings();
  final s2 = Settings();

  print('  s1 HashCode: ${identityHashCode(s1)}');
  print('  s2 HashCode: ${identityHashCode(s2)}');
  print('  identical(s1, s2) => ${identical(s1, s2)}'); // Trả về true

}