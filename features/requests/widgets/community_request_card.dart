import 'package:flutter/material.dart';

import '../../../models/help_request_model.dart';

class CommunityRequestCard extends StatelessWidget {
  final HelpRequestModel request;
  final VoidCallback onTap;

  const CommunityRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  IconData get taskIcon {
    switch (request.category) {
      case "Drop-off":
        return Icons.drive_eta_rounded;

      case "Pick-up":
        return Icons.location_on_rounded;

      case "After School":
        return Icons.school_rounded;

      default:
        return Icons.help_outline_rounded;
    }
  }

  Color get taskColor {
    switch (request.category) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              //--------------------------------------------------
              // Top Row
              //--------------------------------------------------

              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: taskColor.withOpacity(.12),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Icon(
                      taskIcon,
                      color: taskColor,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.category,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          request.title,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              //--------------------------------------------------
              // Description
              //--------------------------------------------------

              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              //--------------------------------------------------
              // Task Info
              //--------------------------------------------------

              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  if (request.taskDate != null)
                    _InfoChip(
                      icon: Icons.calendar_today,
                      label:
                          "${request.taskDate!.day}/${request.taskDate!.month}/${request.taskDate!.year}",
                    ),

                  if (request.taskTime.isNotEmpty)
                    _InfoChip(
                      icon: Icons.access_time,
                      label: request.taskTime,
                    ),

                  _InfoChip(
                    icon: Icons.account_balance_wallet,
                    label:
                        "${request.creditsReward} Credit${request.creditsReward > 1 ? 's' : ''}",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //--------------------------------------------------
              // Bottom Row
              //--------------------------------------------------

    Row(
  children: [
    const CircleAvatar(
      radius: 18,
      child: Icon(
        Icons.person,
        size: 18,
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: Text(
        "Community Parent",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    SizedBox(
      width: 90,
      height: 42,
      child: FilledButton(
        onPressed: onTap,
        child: const Text("View"),
      ),
    ),
  ],
)
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}