import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timenest/providers/request_repository_provider.dart';
import '../../../providers/user_provider.dart';

import '../../../models/help_request_model.dart';

import '../widgets/request_status_banner.dart';
import '../widgets/request_header_card.dart';
import '../widgets/helper_profile_card.dart';
import '../widgets/searching_helper_card.dart';
import '../widgets/schedule_card.dart';
import '../widgets/credits_summary_card.dart';
import '../widgets/request_timeline.dart';
import '../widgets/about_task_card.dart';
import '../widgets/request_action_button.dart';

class RequestDetailsScreen extends ConsumerWidget {
  final HelpRequestModel request;

  const RequestDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final currentUserId =
        ref.read(requestRepositoryProvider).currentUserId;

    final isRequester =
        currentUserId == request.createdBy;

    final otherUserId = isRequester
        ? request.assignedTo
        : request.createdBy;

    final otherUser = otherUserId.isNotEmpty
        ? ref.watch(liveUserProvider(otherUserId))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //----------------------------------------------------
          // Live Status Banner
          //----------------------------------------------------

          RequestStatusBanner(
            status: request.status,
          ),

          //----------------------------------------------------
          // Header
          //----------------------------------------------------

          RequestHeaderCard(
            category: request.category,
            title: request.title,
            status: request.status,
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // Helper / Requester
          //----------------------------------------------------

          if (otherUser != null)
            otherUser.when(
              data: (user) {
                if (user == null) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    HelperProfileCard(
                      user: user,
                      isRequester: isRequester,
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),
              error: (_, __) =>
                  const SizedBox(),
            )
          else
            const Column(
              children: [
                SearchingHelperCard(),
                SizedBox(height: 20),
              ],
            ),

          //----------------------------------------------------
          // Schedule
          //----------------------------------------------------

          ScheduleCard(
            request: request,
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // Credits
          //----------------------------------------------------

          CreditsSummaryCard(
            credits: request.creditsReward,
            isRequester: isRequester,
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // Progress Timeline
          //----------------------------------------------------

          RequestTimeline(
            status: request.status,
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // About Task
          //----------------------------------------------------

          AboutTaskCard(
            title: request.title,
            description:
                request.description,
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // Bottom Action Button
          //----------------------------------------------------

          RequestActionButton(
            request: request,
            isRequester: isRequester,
            onCompleted: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}