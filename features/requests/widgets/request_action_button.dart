import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/help_request_model.dart';
import '../../../providers/request_repository_provider.dart';
import '../../../core/widgets/success_dialog.dart';

class RequestActionButton extends ConsumerWidget {
  final HelpRequestModel request;
  final bool isRequester;
  final VoidCallback? onCompleted;

  const RequestActionButton({
    super.key,
    required this.request,
    required this.isRequester,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (request.status) {
      //--------------------------------------------------
      // OPEN
      //--------------------------------------------------
      case "open":
        if (isRequester) {
          return _disabledButton(
            "Waiting for Helper",
            Icons.hourglass_top,
          );
        }

        return FilledButton.icon(
          icon: const Icon(Icons.volunteer_activism),
          label: const Text("Accept Request"),
          onPressed: () async {
            try {
              await ref
                  .read(requestRepositoryProvider)
                  .acceptRequest(request.id);

              if (context.mounted) {
                await SuccessDialog.show(
                  context: context,
                  title: "Request Accepted",
                  subtitle:
                      "You can now begin helping this family.",
                  icon: Icons.handshake_rounded,
                  color: Colors.blue,
                );
              }

              onCompleted?.call();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString().replaceAll(
                        "Exception: ",
                        "",
                      ),
                    ),
                  ),
                );
              }
            }
          },
        );

      //--------------------------------------------------
      // ACCEPTED
      //--------------------------------------------------
      case "accepted":
        if (isRequester) {
          return _disabledButton(
            "Helper is on the way",
            Icons.directions_car,
          );
        }

        return FilledButton.icon(
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start Task"),
          onPressed: () async {
            try {
              await ref
                  .read(requestRepositoryProvider)
                  .updateRequestStatus(
                    requestId: request.id,
                    status: "in_progress",
                  );

              if (context.mounted) {
                await SuccessDialog.show(
                  context: context,
                  title: "Task Started",
                  subtitle:
                      "Drive safely and keep the requester updated.",
                  icon: Icons.directions_car,
                  color: Colors.orange,
                );
              }

              onCompleted?.call();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString().replaceAll(
                        "Exception: ",
                        "",
                      ),
                    ),
                  ),
                );
              }
            }
          },
        );

      //--------------------------------------------------
      // IN PROGRESS
      //--------------------------------------------------
      case "in_progress":
        if (isRequester) {
          return _disabledButton(
            "Task in Progress",
            Icons.timer,
          );
        }

        return FilledButton.icon(
          icon: const Icon(Icons.flag),
          label: const Text("Request Completion"),
          onPressed: () async {
            try {
              await ref
                  .read(requestRepositoryProvider)
                  .updateRequestStatus(
                    requestId: request.id,
                    status: "completion_requested",
                  );

              if (context.mounted) {
                await SuccessDialog.show(
                  context: context,
                  title: "Completion Requested",
                  subtitle:
                      "Waiting for the requester to approve.",
                  icon: Icons.flag_circle,
                  color: Colors.teal,
                );
              }

              onCompleted?.call();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString().replaceAll(
                        "Exception: ",
                        "",
                      ),
                    ),
                  ),
                );
              }
            }
          },
        );

      //--------------------------------------------------
      // COMPLETION REQUESTED
      //--------------------------------------------------
      case "completion_requested":
        if (!isRequester) {
          return _disabledButton(
            "Waiting for Approval",
            Icons.hourglass_bottom,
          );
        }

        return FilledButton.icon(
          icon: const Icon(Icons.check_circle),
          label: const Text("Approve Completion"),
          onPressed: () async {
            try {
              await ref
                  .read(requestRepositoryProvider)
                  .completeRequest(request);

              if (context.mounted) {
                await SuccessDialog.show(
                  context: context,
                  title: "Task Completed",
                  subtitle:
                      "Credits have been transferred successfully.",
                  icon: Icons.verified,
                  color: Colors.green,
                );
              }

              onCompleted?.call();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString().replaceAll(
                        "Exception: ",
                        "",
                      ),
                    ),
                  ),
                );
              }
            }
          },
        );

      //--------------------------------------------------
      // COMPLETED
      //--------------------------------------------------
      case "completed":
        return FilledButton.icon(
          onPressed: null,
          icon: const Icon(Icons.verified),
          label: const Text("Completed"),
        );

      default:
        return FilledButton(
          onPressed: null,
          child: Text(request.status),
        );
    }
  }

  Widget _disabledButton(
    String text,
    IconData icon,
  ) {
    return FilledButton.icon(
      onPressed: null,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}