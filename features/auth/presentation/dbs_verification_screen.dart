import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DbsVerificationScreen extends StatefulWidget {
  const DbsVerificationScreen({super.key});

  @override
  State<DbsVerificationScreen> createState() =>
      _DbsVerificationScreenState();
}

class _DbsVerificationScreenState extends State<DbsVerificationScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  bool consentGiven = false;
  bool isSubmitting = false;
  bool submitted = false;

  Future<void> _submitDbsCheck() async {
    if (!consentGiven || isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    // Demo flow.
    // Replace this with the real DBS provider/API integration later.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
      submitted = true;
    });
  }

  void _continueToReferences() {
    context.push('/verification/references');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Verification',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  32,
                ),
                child: submitted
                    ? _buildSubmittedState()
                    : _buildDbsContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    const labels = [
      'ID',
      'Face',
      'DBS',
      'Refs',
      'Train',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        8,
        24,
        0,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final bool completed = index < 2;
            final bool active = index == 2;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: completed
                                ? green
                                : active
                                    ? orange
                                    : Colors.black12,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                active || completed
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                            color: active || completed
                                ? darkText
                                : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != labels.length - 1)
                    const SizedBox(width: 5),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDbsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 46,
              color: orange,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Center(
          child: Text(
            'Enhanced DBS check',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Center(
          child: Text(
            'We need to complete a criminal record '
            'check before you can care for children '
            'through TimeNest.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(height: 28),

        _InfoCard(
          icon: Icons.security_outlined,
          title: 'Why we need this',
          text:
              'The Enhanced DBS check helps us confirm '
              'your eligibility to provide childcare.',
        ),

        const SizedBox(height: 12),

        _InfoCard(
          icon: Icons.lock_outline_rounded,
          title: 'Your information is protected',
          text:
              'Your verification information is handled '
              'securely and only used for the verification '
              'process.',
        ),

        const SizedBox(height: 12),

        _InfoCard(
          icon: Icons.schedule_outlined,
          title: 'How long does it take?',
          text:
              'DBS checks can take several days. You can '
              'continue with the remaining verification '
              'steps while the check is being processed.',
        ),

        const SizedBox(height: 28),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: consentGiven,
                activeColor: orange,
                onChanged: (value) {
                  setState(() {
                    consentGiven = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 11),
                  child: Text(
                    'I consent to TimeNest arranging an '
                    'Enhanced DBS check as part of my '
                    'verification.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: darkText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                consentGiven && !isSubmitting
                    ? _submitDbsCheck
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  Colors.black12,
              disabledForegroundColor:
                  Colors.black38,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : const Text(
                    'Consent & start DBS check →',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 14),

        const Center(
          child: Text(
            'You can continue with the next steps while '
            'your DBS check is being processed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),

        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F7F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 52,
            color: green,
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'DBS check started',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Your Enhanced DBS check has been submitted. '
          'It may take several days to complete.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 32),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.hourglass_top_rounded,
                color: orange,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  'DBS status: Processing',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _continueToReferences,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Continue to references →',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const darkText = Color(0xFF24211F);
    const orange = Color(0xFFFF765F);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}