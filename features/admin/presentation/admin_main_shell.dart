import 'package:flutter/material.dart';

import 'admin_dashboard_screen.dart';
import 'admin_kyc_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_requests_screen.dart';
import 'admin_users_screen.dart';

class AdminMainShell extends StatefulWidget {
  const AdminMainShell({
    super.key,
  });

  @override
  State<AdminMainShell> createState() =>
      _AdminMainShellState();
}

class _AdminMainShellState
    extends State<AdminMainShell> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    AdminDashboardScreen(),
    AdminKycScreen(),
    AdminRequestsScreen(),
    AdminReportsScreen(),
    AdminUsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (
          index,
        ) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.verified_user,
            ),
            label: 'KYC',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.assignment,
            ),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.report,
            ),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.people,
            ),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}