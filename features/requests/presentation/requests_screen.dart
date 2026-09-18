import 'package:flutter/material.dart';

import 'community_requests_tab.dart';
import 'my_requests_screen.dart';
import 'my_tasks_screen.dart';

class RequestsScreen
    extends StatelessWidget {
  const RequestsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Requests',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Community',
              ),
              Tab(
                text: 'My Requests',
              ),
              Tab(
                text: 'My Tasks',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CommunityRequestsTab(),
            MyRequestsScreen(),
            MyTasksScreen(),
          ],
        ),
      ),
    );
  }
}