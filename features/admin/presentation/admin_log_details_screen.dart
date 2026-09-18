import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/admin_log_model.dart';

class AdminLogDetailsScreen extends StatelessWidget {
  final AdminLogModel log;

  const AdminLogDetailsScreen({
    super.key,
    required this.log,
  });

  Color _colorForAction(
    String action,
  ) {
    switch (action) {
      case 'Approve KYC':
        return Colors.green;

      case 'Reject KYC':
        return Colors.red;

      case 'Issue Strike':
        return Colors.orange;

      case 'Unblock User':
        return Colors.blue;

      case 'Delete Request':
        return Colors.red;

      case 'Hide Request':
        return Colors.deepOrange;

      case 'Complete Request':
        return Colors.green;

      case 'Resolve Report':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  IconData _iconForAction(
    String action,
  ) {
    switch (action) {
      case 'Approve KYC':
        return Icons.verified;

      case 'Reject KYC':
        return Icons.cancel;

      case 'Issue Strike':
        return Icons.gavel;

      case 'Unblock User':
        return Icons.lock_open;

      case 'Delete Request':
        return Icons.delete;

      case 'Hide Request':
        return Icons.visibility_off;

      case 'Complete Request':
        return Icons.check_circle;

      case 'Resolve Report':
        return Icons.report;

      default:
        return Icons.history;
    }
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final created =
        log.createdAt?.toDate();

    final formattedDate =
        created == null
            ? "-"
            : DateFormat(
                "EEEE, dd MMM yyyy • HH:mm:ss",
              ).format(created);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Audit Log Details",
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        children: [

          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor:
                  _colorForAction(
                log.action,
              ),
              child: Icon(
                _iconForAction(
                  log.action,
                ),
                size: 42,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Center(
            child: Text(
              log.action,
              style:
                  Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          _tile(
            icon: Icons.description,
            title: "Description",
            value: log.description,
          ),

          _tile(
            icon: Icons.person,
            title: "Administrator",
            value: log.adminName,
          ),

          _tile(
            icon: Icons.badge,
            title: "Administrator ID",
            value: log.adminId,
          ),

          _tile(
            icon: Icons.ads_click,
            title: "Target",
            value: log.targetName,
          ),

          _tile(
            icon: Icons.fingerprint,
            title: "Target ID",
            value: log.targetId,
          ),

          _tile(
            icon: Icons.schedule,
            title: "Date & Time",
            value: formattedDate,
          ),

          const SizedBox(
            height: 20,
          ),

          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding:
                  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    "Future Audit Information",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "• IP Address",
                  ),

                  Text(
                    "• Device Name",
                  ),

                  Text(
                    "• Browser",
                  ),

                  Text(
                    "• Operating System",
                  ),

                  Text(
                    "• Session ID",
                  ),

                  Text(
                    "• Location",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}