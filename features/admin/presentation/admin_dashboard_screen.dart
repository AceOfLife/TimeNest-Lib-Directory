import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/admin_dashboard_provider.dart';

class AdminDashboardScreen
extends ConsumerWidget {
const AdminDashboardScreen({
super.key,
});

Widget buildStatCard({
required String title,
required int value,
required IconData icon,
required Color color,
}) {
return Card(
elevation: 3,
child: Padding(
padding:
const EdgeInsets.all(
16,
),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
CircleAvatar(
radius: 24,
backgroundColor:
color.withOpacity(
0.15,
),
child: Icon(
icon,
color: color,
size: 28,
),
),
const SizedBox(
height: 12,
),
Text(
value.toString(),
style:
const TextStyle(
fontSize: 24,
fontWeight:
FontWeight.bold,
),
),
const SizedBox(
height: 6,
),
Text(
title,
textAlign:
TextAlign.center,
),
],
),
),
);
}

@override
Widget build(
BuildContext context,
WidgetRef ref,
) {
final stats =
ref.watch(
adminDashboardProvider,
);
return Scaffold(
  appBar: AppBar(
    title: const Text(
      'Admin Dashboard',
    ),
  ),
  body: stats.when(
    data: (data) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            adminDashboardProvider,
          );
        },
        child: ListView(
          padding:
              const EdgeInsets.all(
            16,
          ),
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding:
                    const EdgeInsets
                        .all(
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'Overview',
                      style:
                          TextStyle(
                        fontSize:
                            22,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Monitor users, KYC requests, reports and platform activity.',
                      style:
                          TextStyle(
                        color: Colors
                            .grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing:
                  12,
              mainAxisSpacing:
                  12,
              childAspectRatio:
                  0.85,
              children: [
                buildStatCard(
                  title:
                      'Total Users',
                  value:
                      data.totalUsers,
                  icon:
                      Icons.people,
                  color:
                      Colors.blue,
                ),
                buildStatCard(
                  title:
                      'Verified Users',
                  value: data
                      .verifiedUsers,
                  icon: Icons
                      .verified,
                  color:
                      Colors.green,
                ),
                buildStatCard(
                  title:
                      'Pending KYC',
                  value:
                      data.pendingKyc,
                  icon: Icons
                      .pending_actions,
                  color:
                      Colors.orange,
                ),
                buildStatCard(
                  title:
                      'Blocked Users',
                  value: data
                      .blockedUsers,
                  icon:
                      Icons.block,
                  color:
                      Colors.red,
                ),
                buildStatCard(
                  title:
                      'Total Requests',
                  value: data
                      .totalRequests,
                  icon: Icons
                      .assignment,
                  color:
                      Colors.indigo,
                ),
                buildStatCard(
                  title:
                      'Completed',
                  value: data
                      .completedRequests,
                  icon: Icons
                      .check_circle,
                  color:
                      Colors.green,
                ),
                buildStatCard(
                  title:
                      'Open Requests',
                  value:
                      data.openRequests,
                  icon: Icons
                      .folder_open,
                  color:
                      Colors.teal,
                ),
                buildStatCard(
                  title:
                      'Reports',
                  value: data
                      .totalReports,
                  icon:
                      Icons.report,
                  color:
                      Colors.deepOrange,
                ),
              ],
            ),
          ],
        ),
      );
    },
    loading: () =>
        const Center(
      child:
          CircularProgressIndicator(),
    ),
    error: (e, _) =>
        Center(
      child: Text(
        e.toString(),
      ),
    ),
  ),
);

}
}
