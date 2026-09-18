import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timenest/models/announcement_model.dart';

import '../../providers/announcement_form_provider.dart';

class AnnouncementSchedule extends ConsumerWidget {
  const AnnouncementSchedule({
    super.key, AnnouncementModel? announcement,
  });

  Future<void> _pickSchedule(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(
      announcementFormProvider.notifier,
    );

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    notifier.setSchedule(
      DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _pickExpiry(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(
      announcementFormProvider.notifier,
    );

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    notifier.setExpiry(
      DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

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
              'Scheduling',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              contentPadding:
                  EdgeInsets.zero,
              title: const Text(
                'Pin Announcement',
              ),
              subtitle: const Text(
                'Keep this announcement at the top.',
              ),
              value: state.isPinned,
              onChanged:
                  notifier.setPinned,
            ),

            const Divider(),

            SwitchListTile(
              contentPadding:
                  EdgeInsets.zero,
              title: const Text(
                'Archive',
              ),
              subtitle: const Text(
                'Hide this announcement from users.',
              ),
              value: state.isArchived,
              onChanged:
                  notifier.setArchived,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () =>
                  _pickSchedule(
                context,
                ref,
              ),
              icon: const Icon(
                Icons.schedule,
              ),
              label: Text(
                state.scheduledAt == null
                    ? 'Select Schedule'
                    : DateFormat(
                        'dd MMM yyyy • HH:mm',
                      ).format(
                        state
                            .scheduledAt!,
                      ),
              ),
            ),

            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: () =>
                  _pickExpiry(
                context,
                ref,
              ),
              icon: const Icon(
                Icons.event_busy,
              ),
              label: Text(
                state.expiresAt == null
                    ? 'Select Expiry'
                    : DateFormat(
                        'dd MMM yyyy • HH:mm',
                      ).format(
                        state
                            .expiresAt!,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}