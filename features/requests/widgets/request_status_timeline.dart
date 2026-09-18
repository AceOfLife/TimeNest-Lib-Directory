import 'package:flutter/material.dart';

class RequestStatusTimeline extends StatelessWidget {
  final String status;

  const RequestStatusTimeline({
    super.key,
    required this.status,
  });

  static const List<Map<String, String>> steps = [
    {
      "key": "open",
      "title": "Request Posted",
    },
    {
      "key": "accepted",
      "title": "Helper Accepted",
    },
    {
      "key": "in_progress",
      "title": "Task In Progress",
    },
    {
      "key": "completion_requested",
      "title": "Awaiting Approval",
    },
    {
      "key": "completed",
      "title": "Completed",
    },
  ];

  int get currentStep {
    switch (status) {
      case "open":
        return 0;

      case "accepted":
        return 1;

      case "in_progress":
        return 2;

      case "completion_requested":
        return 3;

      case "completed":
        return 4;

      default:
        return 0;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Progress",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            ...List.generate(
              steps.length,
              (index) {
                final completed = index < currentStep;
                final active = index == currentStep;

                return Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: completed
                                ? Colors.green
                                : active
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                    : Colors.grey.shade300,
                          ),
                          child: completed
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : active
                                  ? const Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 10,
                                    )
                                  : null,
                        ),

                        if (index !=
                            steps.length - 1)
                          Container(
                            width: 2,
                            height: 42,
                            color: completed
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 2,
                        ),
                        child: Text(
                          steps[index]["title"]!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: active
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: completed || active
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}