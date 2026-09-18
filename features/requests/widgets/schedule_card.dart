import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timenest/models/help_request_model.dart';

class ScheduleCard extends StatelessWidget {
  final HelpRequestModel request;

  const ScheduleCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final hasSchedule =
        request.taskDate != null &&
        request.taskTime.isNotEmpty;

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
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Colors.blue,
                size: 34,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: hasSchedule
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task Schedule",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('EEEE')
                              .format(request.taskDate!),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d MMMM yyyy')
                              .format(request.taskDate!),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(request.taskTime),
                          ],
                        ),
                      ],
                    )
                  : const Text("No schedule selected"),
            ),
          ],
        ),
      ),
    );
  }
}