import 'package:flutter/material.dart';

import 'widgets/announcement_actions.dart';
import 'widgets/announcement_basic_info.dart';
import 'widgets/announcement_schedule.dart';
import 'widgets/announcement_targeting.dart';

class AnnouncementForm extends StatelessWidget {
  const AnnouncementForm({
    super.key,
    required this.createdBy,
    this.isEdit = false,
  });

  final String createdBy;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const AnnouncementBasicInfo(),

            const SizedBox(height: 20),

            AnnouncementTargeting(),

            const SizedBox(height: 20),

            const AnnouncementSchedule(),

            const SizedBox(height: 32),

            AnnouncementActions(
              createdBy: createdBy,
              isEditing: isEdit,
            ),
          ],
        ),
      ),
    );
  }
}