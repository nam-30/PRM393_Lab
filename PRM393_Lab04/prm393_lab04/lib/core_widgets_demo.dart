import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 – Core Widgets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Material Icon
            const Icon(
              Icons.movie,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),

            // Image.network
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://picsum.photos/400/200',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Text('Không thể tải hình ảnh'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Card chứa ListTile
            const Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.black54),
                title: Text(
                  'Movie Item',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('This is a sample ListTile inside a Card.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}