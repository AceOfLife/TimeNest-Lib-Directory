import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/pending_kyc_provider.dart';
import '../../../providers/admin_repository_provider.dart';

class AdminKycScreen extends ConsumerWidget {
  const AdminKycScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final pendingUsers =
        ref.watch(
      pendingKycProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KYC Approvals',
        ),
      ),
      body: pendingUsers.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No pending KYC submissions',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              12,
            ),
            itemCount:
                users.length,
            itemBuilder:
                (
                  context,
                  index,
                ) {
              final user =
                  users[index];

              return Card(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Text(
                              user.fullName
                                      .isNotEmpty
                                  ? user
                                      .fullName[0]
                                      .toUpperCase()
                                  : '?',
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  user.fullName,
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                Text(
                                  user.email,
                                ),

                                Text(
                                  user.phoneNumber,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets.all(
                          12,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.orange
                                  .withOpacity(
                            0.1,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                        child: const Text(
                          'This user has submitted KYC and is awaiting approval.',
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child:
                                FilledButton.icon(
                              onPressed:
                                  () async {
                                await ref
                                    .read(
                                      adminRepositoryProvider,
                                    )
                                    .approveKyc(
                                      user.uid,
                                    );

                                if (context
                                    .mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(
                                        '${user.fullName} approved',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon:
                                  const Icon(
                                Icons
                                    .check_circle,
                              ),
                              label:
                                  const Text(
                                'Approve',
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                OutlinedButton.icon(
                              onPressed:
                                  () async {
                                await ref
                                    .read(
                                      adminRepositoryProvider,
                                    )
                                    .rejectKyc(
                                      user.uid,
                                    );

                                if (context
                                    .mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(
                                        '${user.fullName} rejected',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon:
                                  const Icon(
                                Icons.cancel,
                              ),
                              label:
                                  const Text(
                                'Reject',
                              ),
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
        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),
        error: (
          e,
          _,
        ) =>
            Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}