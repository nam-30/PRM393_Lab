import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Lab 8.1 & 8.4: Lấy danh sách bài viết (GET Request)
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == 200) {
        // Giải mã JSON
        List<dynamic> body = jsonDecode(response.body);
        // Chuyển đổi danh sách JSON thành List<Post>
        List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw Exception('Lỗi máy chủ! Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng!');
    }
  }

  // (Optional) Tạo bài viết mới (POST Request)
  Future<Post> createPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Không thể tạo bài viết mới.');
      }
    } catch (e) {
      throw Exception('Gửi dữ liệu thất bại: $e');
    }
  }
}