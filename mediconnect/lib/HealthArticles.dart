import 'package:flutter/material.dart';

class HealthArticlesPage extends StatefulWidget {
  const HealthArticlesPage({super.key});

  @override
  State<HealthArticlesPage> createState() => _HealthArticlesPageState();
}

class _HealthArticlesPageState extends State<HealthArticlesPage> {
  // ✅ Hardcoded articles
  final List<Map<String, dynamic>> articles = [
    {
      'title': '5 Tips for a Healthy Heart',
      'content': 'Eat healthy, exercise regularly, manage stress, get enough sleep, and avoid smoking.',
      'image_url': 'https://images.unsplash.com/photo-1588776814546-ec7d10b7b4b4?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Importance of Staying Hydrated',
      'content': 'Drinking enough water daily is essential for organ function, energy, and skin health.',
      'image_url': 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Mental Health Matters',
      'content': 'Practicing mindfulness, talking to someone, and taking breaks can improve mental well-being.',
      'image_url': 'https://images.unsplash.com/photo-1587502537745-84f97e65b60b?auto=format&fit=crop&w=800&q=60'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Health Articles'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article['image_url'] != null &&
                    article['image_url'].toString().isNotEmpty)
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      article['image_url'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article['content'] ?? 'No Content',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
