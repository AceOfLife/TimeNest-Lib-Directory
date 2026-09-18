import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/report_repository_provider.dart';

class ReportUserDialog
    extends ConsumerStatefulWidget {
  final String userId;

  const ReportUserDialog({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ReportUserDialog>
      createState() =>
          _ReportUserDialogState();
}

class _ReportUserDialogState
    extends ConsumerState<
        ReportUserDialog> {
  String selectedReason =
      'Spam';

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Report User',
      ),
      content: DropdownButtonFormField<
          String>(
        value: selectedReason,
        items: const [
          DropdownMenuItem(
            value: 'Spam',
            child: Text('Spam'),
          ),
          DropdownMenuItem(
            value: 'Fraud',
            child: Text('Fraud'),
          ),
          DropdownMenuItem(
            value: 'Harassment',
            child: Text('Harassment'),
          ),
          DropdownMenuItem(
            value:
                'Inappropriate Content',
            child: Text(
              'Inappropriate Content',
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedReason =
                value!;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),
        FilledButton(
          onPressed: () async {
            await ref
                .read(
                  reportRepositoryProvider,
                )
                .submitReport(
                  reportedUserId:
                      widget.userId,
                  reason:
                      selectedReason,
                );

            if (mounted) {
              Navigator.pop(
                context,
              );
            }
          },
          child: const Text(
            'Submit',
          ),
        ),
      ],
    );
  }
}