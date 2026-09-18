import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});

  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Setup complete',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Success icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: green.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: green,
                  size: 58,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'You’re all set!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkText,
                  fontSize: 30,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your TimeNest parent setup is complete.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // Review status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            color: orange,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Final review pending',
                            style: TextStyle(
                              color: darkText,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Your verification information has been submitted for review by a TimeNest DSL.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _StatusRow(
                      label: 'Identity & face verification',
                      status: 'Complete',
                      completed: true,
                    ),

                    _StatusRow(
                      label: 'Enhanced DBS check',
                      status: 'Submitted',
                      completed: true,
                    ),

                    _StatusRow(
                      label: 'Character references',
                      status: 'Submitted',
                      completed: true,
                    ),

                    _StatusRow(
                      label: 'NSPCC training',
                      status: 'Complete',
                      completed: true,
                    ),

                    _StatusRow(
                      label: 'Child & school details',
                      status: 'Complete',
                      completed: true,
                    ),

                    _StatusRow(
                      label: 'DSL review',
                      status: 'Pending',
                      completed: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // What happens next
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What happens next?',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _NextStep(
                      number: '1',
                      text:
                          'A TimeNest DSL reviews your verification information.',
                    ),

                    const SizedBox(height: 14),

                    _NextStep(
                      number: '2',
                      text:
                          'Your DBS and reference checks are considered alongside your application.',
                    ),

                    const SizedBox(height: 14),

                    _NextStep(
                      number: '3',
                      text:
                          'If your application is approved, your parent account becomes fully verified.',
                    ),

                    const SizedBox(height: 14),

                    _NextStep(
                      number: '4',
                      text:
                          'You can then access the full TimeNest experience.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Notification card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.black45,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'We’ll notify you when your review status changes. You can safely leave the app while your application is being reviewed.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Go to TimeNest →',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your account remains pending until the final DSL approval.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.status,
    required this.completed,
    this.isLast = false,
  });

  final String label;
  final String status;
  final bool completed;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 13,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            completed
                ? Icons.check_circle
                : Icons.schedule_outlined,
            color: completed
                ? VerificationCompleteScreen.green
                : VerificationCompleteScreen.orange,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: VerificationCompleteScreen.darkText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: completed
                  ? VerificationCompleteScreen.green
                  : VerificationCompleteScreen.orange,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep({
    required this.number,
    required this.text,
  });

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: VerificationCompleteScreen.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: VerificationCompleteScreen.darkText,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}