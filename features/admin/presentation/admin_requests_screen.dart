import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/help_request_model.dart';
import '../../../providers/admin_repository_provider.dart';
import '../../../providers/admin_requests_provider.dart';

class AdminRequestsScreen extends ConsumerStatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  ConsumerState<AdminRequestsScreen> createState() =>
      _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends ConsumerState<AdminRequestsScreen> {
  String selectedStatus = "All";

  final List<String> statuses = [
    "All",
    "open",
    "accepted",
    "in_progress",
    "awaiting_confirmation",
    "completed",
  ];

  List<HelpRequestModel> filterRequests(List<HelpRequestModel> requests) {
    if (selectedStatus == "All") {
      return requests;
    }

    return requests
        .where((request) => request.status == selectedStatus)
        .toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;

      case "accepted":
        return Colors.orange;

      case "in_progress":
        return Colors.blue;

      case "awaiting_confirmation":
        return Colors.deepPurple;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(adminRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Request Management")),
      body: requests.when(
        data: (items) {
          final filtered = filterRequests(items);

          if (filtered.isEmpty) {
            return const Center(child: Text("No requests found"));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: "Filter by Status",
                    border: OutlineInputBorder(),
                  ),
                  items: statuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final request = filtered[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    request.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Chip(
                                  backgroundColor: statusColor(request.status),
                                  label: Text(
                                    request.status,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(request.description),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                const Icon(Icons.category, size: 18),
                                const SizedBox(width: 8),
                                Text(request.category),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.stars, size: 18),
                                const SizedBox(width: 8),
                                Text("${request.creditsReward} points"),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.person, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Requester: ${request.createdBy}",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.handshake, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    request.assignedTo.isEmpty
                                        ? "No helper assigned"
                                        : "Helper: ${request.assignedTo}",
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 28),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton.icon(
                                  onPressed: request.rewardPaid
                                      ? null
                                      : () async {
                                          await ref
                                              .read(adminRepositoryProvider)
                                              .completeRequest(
                                                requestId: request.id,
                                              );

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Request marked completed",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text("Complete"),
                                ),

                                FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await ref
                                        .read(adminRepositoryProvider)
                                        .deleteRequest(request.id);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Request deleted"),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete"),
                                ),

                                FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () async {
                                    await ref
                                        .read(adminRepositoryProvider)
                                        .hideRequest(request.id);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Request hidden"),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.visibility_off),
                                  label: const Text("Hide"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
