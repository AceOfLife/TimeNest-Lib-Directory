import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DslReviewScreen extends StatefulWidget {
  const DslReviewScreen({super.key});

  @override
  State<DslReviewScreen> createState() => _DslReviewScreenState();
}

class _DslReviewScreenState extends State<DslReviewScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  bool isSubmitted = false;
  bool isLoading = false;

  Future<void> _submitForReview() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Demo submission.
    //
    // Later this will:
    // 1. Save the verification state to Firestore.
    // 2. Notify the TimeNest admin/DSL team.
    // 3. Change the user's verification status to
    //    "under_review".
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      isSubmitted = true;
    });
  }

  void _continueToAddChild() {
    context.push('/verification/add-child');
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
                child: isSubmitted
                    ? _buildSubmittedState()
                    : _buildReviewContent(),
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
            const completed = true;

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
                                : Colors.black12,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: darkText,
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

  Widget _buildReviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              size: 48,
              color: orange,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Center(
          child: Text(
            'Final review',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Center(
          child: Text(
            'Your verification information is ready '
            'for review by a TimeNest DSL.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(height: 28),

        _buildReviewNotice(),

        const SizedBox(height: 24),

        const Text(
          'Verification checklist',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        const SizedBox(height: 14),

        _buildStatusCard(
          icon: Icons.badge_outlined,
          title: 'Identity verification',
          status: 'Complete',
          completed: true,
        ),

        const SizedBox(height: 10),

        _buildStatusCard(
          icon: Icons.face_retouching_natural_outlined,
          title: 'Face & liveness',
          status: 'Complete',
          completed: true,
        ),

        const SizedBox(height: 10),

        _buildStatusCard(
          icon: Icons.verified_user_outlined,
          title: 'Enhanced DBS',
          status: 'Submitted',
          completed: true,
        ),

        const SizedBox(height: 10),

        _buildStatusCard(
          icon: Icons.people_outline_rounded,
          title: 'Character references',
          status: 'Submitted',
          completed: true,
        ),

        const SizedBox(height: 10),

        _buildStatusCard(
          icon: Icons.school_outlined,
          title: 'Safeguarding training',
          status: 'Complete',
          completed: true,
        ),

        const SizedBox(height: 10),

        _buildStatusCard(
          icon: Icons.admin_panel_settings_outlined,
          title: 'DSL review',
          status: 'Pending',
          completed: false,
          active: true,
        ),

        const SizedBox(height: 28),

        _buildWhatHappensNext(),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                isLoading ? null : _submitForReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.black12,
              disabledForegroundColor: Colors.black38,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
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
                    'Submit for DSL review →',
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
            'A member of the TimeNest safeguarding team '
            'will review your application.',
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

  Widget _buildReviewNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.schedule_outlined,
              color: orange,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Human review required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your completed checks will be reviewed '
                  'by a TimeNest DSL before your account '
                  'can be approved.',
                  style: TextStyle(
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

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String status,
    required bool completed,
    bool active = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? orange.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: completed
                  ? green.withValues(alpha: 0.12)
                  : orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: completed ? green : orange,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: completed
                  ? green.withValues(alpha: 0.10)
                  : orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: completed ? green : orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatHappensNext() {
    const steps = [
      'TimeNest receives your completed verification information.',
      'A DSL reviews your application and verification results.',
      'If everything is satisfactory, your parent account is approved.',
      'You can then add your child or children and their schools.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What happens next?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),

          const SizedBox(height: 18),

          ...List.generate(
            steps.length,
            (index) {
              final isLast = index == steps.length - 1;

              return Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color:
                              orange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: orange,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 1,
                          height: 35,
                          color: Colors.black12,
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 17),
                      child: Text(
                        steps[index],
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 44),

        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F7F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.hourglass_top_rounded,
            size: 50,
            color: green,
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'Application under review',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Your verification application has been '
          'submitted to the TimeNest safeguarding team '
          'for human review.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 28),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            children: [
              _buildSubmittedRow(
                'Verification checks',
                'Complete',
              ),
              const SizedBox(height: 15),
              _buildSubmittedRow(
                'DSL review',
                'Pending',
              ),
              const SizedBox(height: 15),
              _buildSubmittedRow(
                'Parent approval',
                'Pending',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1ED),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: orange,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'We will let you know when your review '
                  'is complete. You do not need to repeat '
                  'your verification checks.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.black54,
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
            onPressed: _continueToAddChild,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Continue →',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Demo: this button represents the next stage '
          'after manual approval.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittedRow(
    String title,
    String status,
  ) {
    final bool complete = status == 'Complete';

    return Row(
      children: [
        Icon(
          complete
              ? Icons.check_circle_rounded
              : Icons.schedule_rounded,
          color: complete ? green : orange,
          size: 21,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: complete ? green : orange,
          ),
        ),
      ],
    );
  }
}