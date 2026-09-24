import 'package:flutter/material.dart';

class CommonUiFixesDemo extends StatelessWidget {
  const CommonUiFixesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Fixes'),
      ),
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

            // SỬA LỖI: Bọc ListView bằng Expanded bên trong Column
            // để tránh lỗi xung đột kích thước (vertical viewport was given unbounded height).
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie A'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie B'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie C'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie D'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}