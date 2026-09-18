import 'package:flutter/material.dart';

class SuccessDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    Color color = Colors.green,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(
        milliseconds: 350,
      ),
      pageBuilder: (_, __, ___) {
        return const SizedBox();
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(28),
              ),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor:
                          color.withOpacity(.12),
                      child: Icon(
                        icon,
                        size: 46,
                        color: color,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    await Future.delayed(
      const Duration(milliseconds: 1400),
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}