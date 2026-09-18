import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../providers/admin_user_provider.dart';

class AdminUserDetailsScreen extends ConsumerWidget {
  final String userId;

  const AdminUserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(adminUserProvider(userId));

    final requests = ref.watch(adminUserRequestsProvider(userId));

    final completedTasks = ref.watch(adminCompletedTasksProvider(userId));

    final reviews = ref.watch(adminReviewsProvider(userId));

    final reports = ref.watch(adminReportsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (UserModel user) {
          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 45,
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? NetworkImage(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(fontSize: 30),
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(user.email),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Points",
                          value: user.points.toString(),
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _StatCard(
                          title: "Rating",
                          value: user.averageRating.toStringAsFixed(1),
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Strikes",
                          value: user.strikeCount.toString(),
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _StatCard(
                          title: "KYC",
                          value: user.kycStatus,
                          color: user.kycStatus == "verified"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const TabBar(
                  tabs: [
                    Tab(text: "Profile"),

                    Tab(text: "Requests"),

                    Tab(text: "Reviews"),

                    Tab(text: "Reports"),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      //==================================================
                      // PROFILE TAB
                      //==================================================
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text("Phone"),
                            subtitle: Text(user.phoneNumber),
                          ),

                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("Role"),
                            subtitle: Text(user.role),
                          ),

                          ListTile(
                            leading: const Icon(Icons.block),
                            title: const Text("Blocked"),
                            subtitle: Text(user.isBlocked ? "Yes" : "No"),
                          ),

                          completedTasks.when(
                            data: (tasks) {
                              return ListTile(
                                leading: const Icon(Icons.check_circle),
                                title: const Text("Completed Tasks"),
                                trailing: Text(tasks.length.toString()),
                              );
                            },
                            loading: () => const SizedBox(),
                            error: (_, __) => const SizedBox(),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            "Admin Actions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              FilledButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(adminUserRepositoryProvider)
                                      .blockUser(user.uid);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('User blocked'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.block),
                                label: const Text("Block"),
                              ),

                              FilledButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(adminUserRepositoryProvider)
                                      .unblockUser(user.uid);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('User unblocked'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.lock_open),
                                label: const Text("Unblock"),
                              ),

                              FilledButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(adminUserRepositoryProvider)
                                      .resetStrikes(user.uid);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Strikes reset'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text("Reset Strikes"),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //==================================================
                      // REQUESTS TAB
                      //==================================================
                      requests.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return const Center(child: Text("No requests"));
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final request = items[index];

                              return ListTile(
                                leading: const Icon(Icons.assignment),
                                title: Text(request.title),
                                subtitle: Text(request.status),
                                trailing: Text("${request.creditsReward} pts"),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text(e.toString())),
                      ),

                      //==================================================
                      // REVIEWS TAB
                      //==================================================
                      reviews.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return const Center(child: Text("No reviews"));
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final review = items[index];

                              return ListTile(
                                leading: const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                title: Text("${review.rating}/5"),
                                subtitle: Text(review.comment),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text(e.toString())),
                      ),

                      //==================================================
                      // REPORTS TAB
                      //==================================================
                      reports.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return const Center(child: Text("No reports"));
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final report = items[index];

                              return ListTile(
                                leading: const Icon(
                                  Icons.report,
                                  color: Colors.red,
                                ),
                                title: Text(report.reason),
                                subtitle: Text(report.status),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text(e.toString())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
