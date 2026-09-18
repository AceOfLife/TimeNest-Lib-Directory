import 'package:flutter/material.dart';

import '../../../models/help_request_model.dart';
import '../presentation/request_details_screen.dart';

class RequestCard extends StatelessWidget {
  final HelpRequestModel request;

  const RequestCard({
    super.key,
    required this.request,
  });

  Color _statusColor() {
    switch (request.status) {
      case 'accepted':
        return Colors.orange;

      case 'in_progress':
        return Colors.deepPurple;

      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RequestDetailsScreen(
              request: request,
            ),
          ),
        );
      },
      child: Card(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                request.title,
                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                request.description,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(
                      request.category,
                    ),
                  ),

                  Chip(
                    backgroundColor:
                        _statusColor()
                            .withValues(
                      alpha: 0.15,
                    ),
                    label: Text(
                      request.status
                          .toUpperCase(),
                      style: TextStyle(
                        color:
                            _statusColor(),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.stars,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${request.creditsReward} Credit${request.creditsReward > 1 ? "s" : ""}',
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
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