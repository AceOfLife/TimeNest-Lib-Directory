import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingVerificationScreen extends StatefulWidget {
  const TrainingVerificationScreen({super.key});

  @override
  State<TrainingVerificationScreen> createState() =>
      _TrainingVerificationScreenState();
}

class _TrainingVerificationScreenState
    extends State<TrainingVerificationScreen> {
  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);

  bool trainingStarted = false;
  bool trainingCompleted = false;
  bool isLoading = false;

  Future<void> _startTraining() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Demo behaviour.
    // Replace this later with the real NSPCC training
    // launch/integration.
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      trainingStarted = true;
    });
  }

  Future<void> _completeTraining() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Demo completion.
    // Replace with actual course completion verification.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      trainingCompleted = true;
    });
  }

  void _continueToReview() {
    context.push('/verification/review');
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
                child: trainingCompleted
                    ? _buildCompletedState()
                    : _buildTrainingContent(),
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
            final bool completed = index < 4;
            final bool active = index == 4;

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

  Widget _buildTrainingContent() {
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
              Icons.school_outlined,
              size: 46,
              color: orange,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Center(
          child: Text(
            'NSPCC safeguarding training',
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
            'Complete safeguarding training to help '
            'you understand your responsibilities when '
            'caring for children.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ),

        const SizedBox(height: 28),

        _buildCourseCard(),

        const SizedBox(height: 24),

        _buildTrainingTopics(),

        const SizedBox(height: 28),

        if (!trainingStarted)
          _buildStartButton()
        else
          _buildInProgressState(),

        const SizedBox(height: 14),

        const Center(
          child: Text(
            'Estimated time: about 90 minutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard() {
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: orange,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Child safeguarding',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NSPCC training',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              _CourseMeta(
                icon: Icons.schedule_outlined,
                text: '90 min',
              ),
              SizedBox(width: 20),
              _CourseMeta(
                icon: Icons.verified_outlined,
                text: 'Required',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTopics() {
    const topics = [
      'Understanding child safeguarding',
      'Recognising signs of concern',
      'Responding to safeguarding concerns',
      'Creating a safe environment for children',
      'Knowing when and how to report a concern',
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
            'What you will cover',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),
          const SizedBox(height: 16),
          ...topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(
                bottom: 11,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: green,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: darkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _startTraining,
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
                'Start training →',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildInProgressState() {
    return Column(
      children: [
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
                Icons.play_circle_outline_rounded,
                color: orange,
                size: 25,
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training in progress',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Complete the safeguarding course '
                      'before continuing with verification.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                isLoading ? null : _completeTraining,
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
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : const Text(
                    'Mark training complete →',
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

  Widget _buildCompletedState() {
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
          'Training completed',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: darkText,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Your safeguarding training has been '
          'recorded. Your verification can now move '
          'to the final review stage.',
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
          child: const Column(
            children: [
              _CompletedRow(
                title: 'Identity',
              ),
              SizedBox(height: 12),
              _CompletedRow(
                title: 'Face & liveness',
              ),
              SizedBox(height: 12),
              _CompletedRow(
                title: 'Enhanced DBS',
              ),
              SizedBox(height: 12),
              _CompletedRow(
                title: 'Character references',
              ),
              SizedBox(height: 12),
              _CompletedRow(
                title: 'Safeguarding training',
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _continueToReview,
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
              'Continue to final review →',
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

class _CourseMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CourseMeta({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.black45,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CompletedRow extends StatelessWidget {
  final String title;

  const _CompletedRow({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF55BFA8);
    const darkText = Color(0xFF24211F);

    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: green,
          size: 20,
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
        const Text(
          'Complete',
          style: TextStyle(
            fontSize: 12,
            color: green,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
