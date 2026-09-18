import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/current_user_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/requests_provider.dart';

import '../../notifications/presentation/notifications_screen.dart';
import '../../requests/presentation/create_request_screen.dart';
import '../../requests/presentation/request_details_screen.dart';
import '../../requests/presentation/requests_screen.dart';

import '../widgets/credits_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_request_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final user = ref.watch(currentUserProvider);

    final requests =
        ref.watch(requestsProvider);

    final notifications =
        ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F9FC),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              currentUserProvider,
            );

            ref.invalidate(
              requestsProvider,
            );

            ref.invalidate(
              notificationProvider,
            );
          },

          child: ListView(
            padding:
                const EdgeInsets.all(20),

            children: [

              //--------------------------------------------------
              // Greeting
              //--------------------------------------------------

              user.when(
                data: (userData) {

                  final unread =
                      notifications.value
                          ?.where(
                            (e) => !e.isRead,
                          )
                          .length ??
                          0;

                  return GreetingHeader(
                    name:
                        userData?.fullName ??
                            "Parent",

                    notificationCount:
                        unread,

                    onNotificationTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const NotificationsScreen(),
                        ),
                      );
                    },
                  );
                },

                loading: () =>
                    const SizedBox(),

                error: (_, __) =>
                    const SizedBox(),
              ),

              const SizedBox(height: 30),

              //--------------------------------------------------
              // Credits
              //--------------------------------------------------

              user.when(
                data: (userData) {
                  return CreditsCard(
                    credits:
                        userData?.points ?? 2,

                    onNeedHelp: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreateRequestScreen(),
                        ),
                      );
                    },

                    onOfferHelp: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RequestsScreen(),
                        ),
                      );
                    },
                  );
                },

                loading: () =>
                    const SizedBox(),

                error: (_, __) =>
                    const SizedBox(),
              ),

              const SizedBox(height: 30),

              //--------------------------------------------------
              // Quick Actions
              //--------------------------------------------------

              const Text(
                "Quick Tasks",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              QuickActionCard(
                title: "Drop-off",

                subtitle:
                    "School or destination",

                icon:
                    Icons.drive_eta_rounded,

                color: Colors.blue,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateRequestScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              QuickActionCard(
                title: "Pick-up",

                subtitle:
                    "Collect someone safely",

                icon:
                    Icons.location_on,

                color: Colors.green,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateRequestScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              QuickActionCard(
                title: "After School",

                subtitle:
                    "Maximum 2 hours",

                icon:
                    Icons.school,

                color: Colors.orange,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateRequestScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 35),

              //--------------------------------------------------
              // Recent Requests
              //--------------------------------------------------

              const Text(
                "Recent Requests",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              requests.when(

                data: (items) {

                  if (items.isEmpty) {

                    return Container(
                      padding:
                          const EdgeInsets.all(
                        30,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: const Column(
                        children: [

                          Icon(
                            Icons.inbox,
                            size: 70,
                            color: Colors.grey,
                          ),

                          SizedBox(height: 16),

                          Text(
                            "No requests nearby",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Be the first parent to request help.",
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: items
                        .take(5)
                        .map(
                          (request) =>
                              Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 16,
                            ),
                            child:
                                RecentRequestCard(
                              request:
                                  request,

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
                            ),
                          ),
                        )
                        .toList(),
                  );
                },

                loading: () =>
                    const Center(
                  child:
                      CircularProgressIndicator(),
                ),

                error: (e, _) =>
                    Text(e.toString()),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}