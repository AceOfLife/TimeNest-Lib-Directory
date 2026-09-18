import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/models/announcement_model.dart';

import '../../providers/announcement_form_provider.dart';

class AnnouncementBasicInfo extends ConsumerWidget {
  const AnnouncementBasicInfo({
    super.key, AnnouncementModel? announcement,
  });

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
              'Basic Information',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: state.title,
              decoration:
                  const InputDecoration(
                labelText: 'Title',
                hintText:
                    'Announcement title',
                border:
                    OutlineInputBorder(),
              ),
              maxLength: 120,
              onChanged:
                  notifier.updateTitle,
            ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue:
                  state.message,
              decoration:
                  const InputDecoration(
                labelText: 'Message',
                hintText:
                    'Announcement message...',
                border:
                    OutlineInputBorder(),
                alignLabelWithHint:
                    true,
              ),
              minLines: 6,
              maxLines: 10,
              maxLength: 5000,
              onChanged:
                  notifier.updateMessage,
            ),
          ],
        ),
      ),
    );
  }
}