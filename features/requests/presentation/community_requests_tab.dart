import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/requests_provider.dart';
import '../../../core/widgets/shimmer_loading.dart';

import '../../../models/help_request_model.dart';

import '../presentation/request_details_screen.dart';
import '../widgets/community_request_card.dart';

class CommunityRequestsTab extends ConsumerWidget {
  const CommunityRequestsTab({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final requests =
        ref.watch(requestsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          requestsProvider,
        );
      },
      child: requests.when(
        loading: () =>
            const ShimmerLoading(),

        error: (e, _) => Center(
          child: Text(
            e.toString(),
          ),
        ),

        data: (items) {
          if (items.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),

                Icon(
                  Icons.search_off_rounded,
                  size: 70,
                  color: Colors.grey,
                ),

                SizedBox(height: 20),

                Center(
                  child: Text(
                    "No community requests available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: Text(
                    "Pull down to refresh.",
                  ),
                ),
              ],
            );
          }

          final openRequests = items
              .where(
                (r) =>
                    r.status == "open",
              )
              .toList();

          if (openRequests.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),

                Icon(
                  Icons.check_circle_outline,
                  size: 70,
                  color: Colors.green,
                ),

                SizedBox(height: 20),

                Center(
                  child: Text(
                    "You're all caught up!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: Text(
                    "There are no open requests right now.",
                  ),
                ),
              ],
            );
          }

          return ListView(
            padding:
                const EdgeInsets.all(20),

            children: [
              const Text(
                "Available Requests",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "${openRequests.length} task${openRequests.length == 1 ? "" : "s"} available nearby",
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              ...openRequests.map(
                (HelpRequestModel request) {
                  return CommunityRequestCard(
                    request: request,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RequestDetailsScreen(
                            request:
                                request,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}