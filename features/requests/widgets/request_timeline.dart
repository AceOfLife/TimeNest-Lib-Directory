import 'package:flutter/material.dart';

class RequestTimeline extends StatelessWidget {
  final String status;

  const RequestTimeline({
    super.key,
    required this.status,
  });

  static const List<String> _steps = [
    'open',
    'accepted',
    'in_progress',
    'completion_requested',
    'completed',
  ];

  int get currentStep {
    final index = _steps.indexOf(status);
    return index == -1 ? 0 : index;
  }

  String labelFor(String status) {
    switch (status) {
      case 'open':
        return 'Request Created';

      case 'accepted':
        return 'Helper Accepted';

      case 'in_progress':
        return 'Task In Progress';

      case 'completion_requested':
        return 'Awaiting Approval';

      case 'completed':
        return 'Completed';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task Progress",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            ...List.generate(_steps.length, (index) {
              final completed = index < currentStep;
              final current = index == currentStep;

              Color color;

              if (completed) {
                color = Colors.green;
              } else if (current) {
                color = Colors.orange;
              } else {
                color = Colors.grey.shade300;
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: completed
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                )
                              : null,
                        ),

                        if (index != _steps.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: completed
                                  ? Colors.green
                                  : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            labelFor(_steps[index]),
                            style: TextStyle(
                              fontWeight: current
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 16,
                              color: current
                                  ? Colors.black
                                  : Colors.grey.shade700,
                            ),
                          ),
                          if (current)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4),
                              child: Text(
                                "Current Stage",
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}