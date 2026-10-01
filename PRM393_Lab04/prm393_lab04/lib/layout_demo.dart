import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<Map<String, String>> movies = const [
    {'title': 'Avatar', 'subtitle': 'Sample description'},
    {'title': 'Inception', 'subtitle': 'Sample description'},
    {'title': 'Interstellar', 'subtitle': 'Sample description'},
    {'title': 'Joker', 'subtitle': 'Sample description'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tiêu đề phần
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Danh sách phim sử dụng Expanded + ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(
                          movie['title']![0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      title: Text(
                        movie['title']!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(movie['subtitle']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}