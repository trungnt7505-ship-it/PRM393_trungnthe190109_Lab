import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách dữ liệu mẫu cho phim
    final List<Map<String, String>> movies = [
      {'title': 'Avatar', 'initial': 'A', 'desc': 'Sample description'},
      {'title': 'Inception', 'initial': 'I', 'desc': 'Sample description'},
      {'title': 'Interstellar', 'initial': 'I', 'desc': 'Sample description'},
      {'title': 'Joker', 'initial': 'J', 'desc': 'Sample description'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 – Layout Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề phần Layout
            const Center(
              child: Text(
                'Now Playing',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Sử dụng Expanded kết hợp ListView.builder để hiển thị danh sách cuộn trong Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          movie['initial']!,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      title: Text(movie['title']!),
                      subtitle: Text(movie['desc']!),
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