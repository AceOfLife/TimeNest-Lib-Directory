import 'package:flutter/material.dart';

class RequestStatusBanner extends StatelessWidget {
  final String status;

  const RequestStatusBanner({
    super.key,
    required this.status,
  });

  Color get color {
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

  IconData get icon {
    switch (status) {
      case "open":
        return Icons.search;

      case "accepted":
        return Icons.handshake_rounded;

      case "in_progress":
        return Icons.directions_walk_rounded;

      case "completion_requested":
        return Icons.task_alt;

      case "completed":
        return Icons.verified_rounded;

      default:
        return Icons.info_outline;
    }
  }

  String get title {
    switch (status) {
      case "open":
        return "Looking for a Helper";

      case "accepted":
        return "Helper Accepted";

      case "in_progress":
        return "Task In Progress";

      case "completion_requested":
        return "Awaiting Your Approval";

      case "completed":
        return "Task Completed";

      default:
        return status;
    }
  }

  String get subtitle {
    switch (status) {
      case "open":
        return "Your request is visible to nearby verified parents.";

      case "accepted":
        return "A helper has accepted your request.";

      case "in_progress":
        return "The helper is currently completing your task.";

      case "completion_requested":
        return "Please review and approve task completion.";

      case "completed":
        return "Credits have been transferred successfully.";

      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}