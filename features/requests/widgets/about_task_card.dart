import 'package:flutter/material.dart';

class AboutTaskCard extends StatelessWidget {
  final String title;
  final String description;

  const AboutTaskCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.12),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                const Text(
                  "About this Task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.55,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}