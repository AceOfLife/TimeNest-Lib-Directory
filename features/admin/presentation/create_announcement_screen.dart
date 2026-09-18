import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import 'announcement_form.dart';

class CreateAnnouncementScreen extends ConsumerWidget {
  const CreateAnnouncementScreen({
    super.key,
  });

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
            'Create Announcement',
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
          'Create Announcement',
        ),
      ),
      body: AnnouncementForm(
        createdBy: currentUser.uid,
      ),
    );
  }
}