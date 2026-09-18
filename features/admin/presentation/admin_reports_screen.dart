import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/request_repository_provider.dart';

class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Reports',
        ),
      ),
      body: StreamBuilder(
        stream: ref
            .read(
              requestRepositoryProvider,
            )
            .getReports(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final reports =
              snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(
              child: Text(
                'No reports found',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(12),
            itemCount:
                reports.length,
            itemBuilder:
                (context, index) {
              final report =
                  reports[index];

              final isResolved =
                  report.status ==
                      'resolved';

              return Card(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.report,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              report.reason,
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        'Reported User:',
                      ),

                      Text(
                        report
                            .reportedUserId,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          const Text(
                            'Status: ',
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration:
                                BoxDecoration(
                              color: isResolved
                                  ? Colors
                                      .green
                                  : Colors
                                      .orange,
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              report.status,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed:
                                () async {
                              await ref
                                  .read(
                                    requestRepositoryProvider,
                                  )
                                  .issueStrike(
                                    report
                                        .reportedUserId,
                                  );

                              if (context
                                  .mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(
                                      'Strike issued successfully',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.gavel,
                            ),
                            label: const Text(
                              'Issue Strike',
                            ),
                          ),

                          FilledButton.icon(
                            onPressed:
                                () async {
                              await ref
                                  .read(
                                    requestRepositoryProvider,
                                  )
                                  .unblockUser(
                                    report
                                        .reportedUserId,
                                  );

                              if (context
                                  .mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(
                                      'User unblocked',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.lock_open,
                            ),
                            label: const Text(
                              'Unblock User',
                            ),
                          ),

                          FilledButton.icon(
                            onPressed:
                                isResolved
                                    ? null
                                    : () async {
                                        await ref
                                            .read(
                                              requestRepositoryProvider,
                                            )
                                            .resolveReport(
                                              report.id,
                                            );

                                        if (context
                                            .mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text(
                                                'Report resolved',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                            icon: const Icon(
                              Icons.check,
                            ),
                            label: const Text(
                              'Resolve',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}