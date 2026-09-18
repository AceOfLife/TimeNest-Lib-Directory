import 'package:flutter/material.dart';

class RequestHeaderCard extends StatelessWidget {
  final String category;
  final String title;
  final String status;

  const RequestHeaderCard({
  super.key,
  required this.category,
  required this.title,
  required this.status,
});

  IconData get icon {
    switch (category) {
      case "Drop-off":
        return Icons.drive_eta_rounded;

      case "Pick-up":
        return Icons.location_on_rounded;

      case "After School":
        return Icons.school_rounded;

      default:
        return Icons.help_outline;
    }
  }

  Color get color {
    switch (category) {
      case "Drop-off":
        return Colors.blue;

      case "Pick-up":
        return Colors.green;

      case "After School":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  Color get statusColor {
    switch (status) {
      case "open":
        return Colors.blue;

      case "accepted":
        return Colors.orange;

      case "in_progress":
        return Colors.deepPurple;

      case "completion_requested":
        return Colors.teal;

      case "completed":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status) {
      case "open":
        return "Open";

      case "accepted":
        return "Accepted";

      case "in_progress":
        return "In Progress";

      case "completion_requested":
        return "Awaiting Approval";

      case "completed":
        return "Completed";

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 34,
                color: color,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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