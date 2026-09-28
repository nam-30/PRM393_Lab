class User {
  int id;
  String name;
  // TODO 1: Khai báo biến email nullable (có thể mang giá trị null)
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // TODO 2: Factory constructor chuyển đổi JSON thành đối tượng User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "Khách", // Nếu name null thì dùng mặc định là "Khách"
      email: json['email'],
    );
  }

  void showProfile() {
    // TODO 3: Dùng toán tử ?? để hiển thị "Chưa cập nhật" nếu email null
    print("ID: $id | Tên: $name | Email: ${email ?? 'Chưa cập nhật'}");
  }
}

void main() {
  // Giả lập dữ liệu JSON trả về từ API
  Map<String, dynamic> rawData1 = {"id": 1, "name": "NamLH", "email": "NamLHHE186671@fpt.edu.vn"};
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  // TODO 4: Khởi tạo đối tượng từ JSON và hiển thị thông tin
  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}