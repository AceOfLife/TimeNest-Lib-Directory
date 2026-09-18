import 'package:flutter/material.dart';

class PermissionDeniedScreen
    extends StatelessWidget {
  const PermissionDeniedScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.lock_outline,
                size: 90,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                "Access Denied",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "You don't have permission to access this page.",
                textAlign:
                    TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}