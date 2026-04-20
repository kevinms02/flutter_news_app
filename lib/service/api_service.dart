import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post.dart';

class ApiService {
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}
