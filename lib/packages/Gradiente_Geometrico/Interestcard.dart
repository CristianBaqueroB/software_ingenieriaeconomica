import 'package:flutter/material.dart';

class InterestCard extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;
  final String explanation;
  final List<String> images;
  final List<String> imageTitles;

  const InterestCard({
    required this.title,
    required this.content,
    required this.imagePath,
    required this.explanation,
    required this.images,
    required this.imageTitles,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(content),
                    const SizedBox(height: 20),
                    Image.asset(imagePath),
                    const SizedBox(height: 20),
                    Text(explanation),
                    const SizedBox(height: 20),
                    for (int i = 0; i < images.length; i++) ...[
                      Text(imageTitles[i], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Image.asset(images[i]),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cerrar"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
