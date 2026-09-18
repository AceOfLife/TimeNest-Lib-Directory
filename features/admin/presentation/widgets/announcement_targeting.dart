import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/models/announcement_model.dart';

import '../../providers/announcement_form_provider.dart';

class AnnouncementTargeting extends ConsumerWidget {
  AnnouncementTargeting({
    super.key, AnnouncementModel? announcement,
  });

  static const audiences = [
    'Everyone',
    'Helpers',
    'Requesters',
    'Verified Users',
    'Pending KYC',
    'Blocked Users',
    'Admins',
  ];

  static const priorities = [
    'Low',
    'Normal',
    'High',
    'Critical',
  ];

  final statuses = [
  'Draft',
  'Scheduled',
  'Published',
  'Expired',
  'Archived',
];

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(
      announcementFormProvider,
    );

    final notifier = ref.read(
      announcementFormProvider.notifier,
    );

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Targeting',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: state.audience,
              decoration: const InputDecoration(
                labelText: 'Audience',
                border: OutlineInputBorder(),
              ),
              items: audiences
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  notifier.updateAudience(
                    value,
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: state.priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: priorities
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  notifier.updatePriority(
                    value,
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: state.status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: statuses
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  notifier.updateStatus(
                    value,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}