import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String name;
  final int notificationCount;
  final VoidCallback onNotificationTap;

  const GreetingHeader({
    super.key,
    required this.name,
    required this.notificationCount,
    required this.onNotificationTap,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "${getGreeting()} 👋",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  Colors.grey.shade100,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                ),
                onPressed:
                    onNotificationTap,
              ),
            ),

            if (notificationCount > 0)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration:
                      const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment:
                      Alignment.center,
                  child: Text(
                    notificationCount > 9
                        ? "9+"
                        : "$notificationCount",
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}