import 'package:flutter/material.dart';

class CommonUiFixesDemo extends StatefulWidget {
  const CommonUiFixesDemo({super.key});

  @override
  State<CommonUiFixesDemo> createState() => _CommonUiFixesDemoState();
}

class _CommonUiFixesDemoState extends State<CommonUiFixesDemo> {
  int _counter = 0;
  DateTime? _selectedDate;

  // Sửa lỗi 4: Gọi DatePicker đúng cách với BuildContext hợp lệ từ widget tree
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Sửa lỗi 3: Gọi setState() để giao diện cập nhật ngày mới
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _incrementCounter() {
    // Sửa lỗi 3: Bọc thay đổi biến trạng thái trong setState()
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
      ),
      // Sửa lỗi 2: Dùng SingleChildScrollView / layout hợp lý để chống overflow trên màn hình nhỏ
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Sửa lỗi 1: Bọc ListView trong Expanded để định kích thước không gian dọc hợp lệ
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(movies[index]),
                  );
                },
              ),
            ),

            const Divider(),

            // Minh họa sửa lỗi setState() và DatePicker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: Text('Đếm: $_counter'),
                ),
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(_selectedDate == null
                      ? 'Chọn ngày'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}