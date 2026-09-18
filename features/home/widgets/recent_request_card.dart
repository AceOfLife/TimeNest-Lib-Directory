import 'package:flutter/material.dart';

import '../../../models/help_request_model.dart';

class RecentRequestCard extends StatelessWidget {
  final HelpRequestModel request;
  final VoidCallback onTap;

  const RecentRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  IconData get taskIcon {
    switch (request.category) {
      case 'Drop-off':
        return Icons.drive_eta_rounded;

      case 'Pick-up':
        return Icons.location_on_rounded;

      case 'After School':
        return Icons.school_rounded;

      default:
        return Icons.help_outline_rounded;
    }
  }

  Color get taskColor {
    switch (request.category) {
      case 'Drop-off':
        return Colors.blue;

      case 'Pick-up':
        return Colors.green;

      case 'After School':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  Color get statusColor {
    switch (request.status) {
      case 'open':
        return Colors.green;

      case 'accepted':
        return Colors.orange;

      case 'in_progress':
        return Colors.deepPurple;

      case 'completion_requested':
        return Colors.indigo;

      case 'completed':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (request.status) {
      case 'open':
        return 'OPEN';

      case 'accepted':
        return 'ACCEPTED';

      case 'in_progress':
        return 'IN PROGRESS';

      case 'completion_requested':
        return 'AWAITING APPROVAL';

      case 'completed':
        return 'COMPLETED';

      default:
        return request.status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: taskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(taskIcon, color: taskColor, size: 30),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.category,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      request.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 18,
                          color: Colors.amber.shade700,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "${request.creditsReward} Credit${request.creditsReward > 1 ? 's' : ''}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
