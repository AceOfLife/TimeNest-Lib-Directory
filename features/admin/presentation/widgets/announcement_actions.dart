import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/models/announcement_model.dart';

import '../../providers/announcement_form_provider.dart';

class AnnouncementActions extends ConsumerWidget {
  const AnnouncementActions({
    super.key,
    required this.createdBy,
    this.isEdit = false, AnnouncementModel? announcement, required bool isEditing,
  });

  final String createdBy;
  final bool isEdit;

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

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.loading
                ? null
                : () {
                    Navigator.pop(context);
                  },
            icon: const Icon(
              Icons.close,
            ),
            label: const Text(
              'Cancel',
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.loading
                ? null
                : () async {
                    await notifier.saveAnnouncement(
                      createdBy: createdBy,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Draft saved successfully.',
                        ),
                      ),
                    );

                    Navigator.pop(
                      context,
                    );
                  },
            icon: const Icon(
              Icons.save_outlined,
            ),
            label: const Text(
              'Save Draft',
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: state.loading
                ? null
                : () async {
                    // Publish implementation
                    // will be added in Phase 2.7F

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdit
                              ? 'Update coming in next phase.'
                              : 'Publish coming in next phase.',
                        ),
                      ),
                    );
                  },
            icon: state.loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    isEdit
                        ? Icons.edit
                        : Icons.send,
                  ),
            label: Text(
              state.loading
                  ? 'Please wait...'
                  : isEdit
                      ? 'Update'
                      : 'Publish',
            ),
          ),
        ),
      ],
    );
  }
}