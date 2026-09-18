import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/announcement_model.dart';
import '../../../providers/auth_provider.dart';
import 'announcement_form.dart';

class EditAnnouncementScreen extends ConsumerWidget {
  const EditAnnouncementScreen({
    super.key,
    required this.announcement,
  });

  final AnnouncementModel announcement;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authService = ref.read(
      authServiceProvider,
    );

    final currentUser =
        authService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Announcement',
          ),
        ),
        body: const Center(
          child: Text(
            'You must be signed in.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Announcement',
        ),
      ),
      body: AnnouncementForm(
        createdBy: currentUser.uid,
        isEdit: true,
      ),
    );
  }
}