import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaceLivenessScreen extends StatefulWidget {
  const FaceLivenessScreen({super.key});

  @override
  State<FaceLivenessScreen> createState() =>
      _FaceLivenessScreenState();
}

class _FaceLivenessScreenState
    extends State<FaceLivenessScreen> {
  // ============================================================
  // Theme
  // ============================================================

  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF24211F);
  static const Color green = Color(0xFF55BFA8);
  static const Color red = Color(0xFFE66B67);

  // ============================================================
  // State
  // ============================================================

  bool isChecking = false;
  bool faceMatched = false;

  // ============================================================
  // Start face check
  // ============================================================

  Future<void> _startFaceCheck() async {
    if (isChecking) return;

    setState(() {
      isChecking = true;
    });

    // ----------------------------------------------------------
    // DEMO FLOW
    // ----------------------------------------------------------
    // This is where the real face/liveness provider will later
    // be connected.
    //
    // For the MVP/demo flow, simulate a successful check.
    // ----------------------------------------------------------

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isChecking = false;
      faceMatched = true;
    });
  }

  // ============================================================
  // Continue to DBS
  // ============================================================

  void _continueToDbs() {
    context.push('/verification/dbs');
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: const Text(
          'Identity verification',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // Verification progress
              // ==================================================

              _buildProgressIndicator(),

              const SizedBox(height: 30),

              // ==================================================
              // Heading
              // ==================================================

              const Center(
                child: Text(
                  'Quick selfie check',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'We match your face to your ID document.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // Face verification area
              // ==================================================

              _buildFaceScanner(),

              const SizedBox(height: 20),

              // ==================================================
              // Instructions
              // ==================================================

              _buildInstructionCard(),

              const SizedBox(height: 22),

              // ==================================================
              // Action
              // ==================================================

              if (!faceMatched)
                _buildStartButton()
              else
                _buildContinueButton(),

              const SizedBox(height: 18),

              // ==================================================
              // Provider / privacy note
              // ==================================================

              Center(
                child: Text(
                  'Powered by Yoti · Data deleted after verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Progress indicator
  // ============================================================

  Widget _buildProgressIndicator() {
    const labels = [
      'ID',
      'Face',
      'DBS',
      'Refs',
      'Train',
    ];

    return Column(
      children: [
        Row(
          children: List.generate(
            labels.length,
            (index) {
              final bool completed = index == 0;
              final bool active = index == 1;

              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: completed || active
                            ? orange
                            : Colors.white,
                        border: Border.all(
                          color: completed || active
                              ? orange
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: completed
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: active
                                      ? Colors.white
                                      : Colors.grey.shade500,
                                ),
                              ),
                      ),
                    ),

                    if (index < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 1.5,
                          color: index == 0
                              ? orange
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 7),

        Row(
          children: labels.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final label = entry.value;

              return Expanded(
                child: Text(
                  label,
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == labels.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        index <= 1
                            ? FontWeight.w700
                            : FontWeight.w500,
                    color: index <= 1
                        ? orange
                        : Colors.grey.shade500,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // Face scanner
  // ============================================================

  Widget _buildFaceScanner() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF211C19),
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ----------------------------------------------------
          // Face circle
          // ----------------------------------------------------

          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: faceMatched
                    ? green
                    : orange,
                width: 3,
              ),
            ),
            child: Center(
              child: Icon(
                faceMatched
                    ? Icons.check_rounded
                    : Icons.face_rounded,
                size: 82,
                color: faceMatched
                    ? green
                    : orange,
              ),
            ),
          ),

          // ----------------------------------------------------
          // Top instruction
          // ----------------------------------------------------

          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.55,
                ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Text(
                faceMatched
                    ? 'Face matched'
                    : isChecking
                        ? 'Checking your face...'
                        : 'Keep your face inside the circle',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // Bottom instruction
          // ----------------------------------------------------

          Positioned(
            bottom: 18,
            left: 20,
            right: 20,
            child: Text(
              faceMatched
                  ? 'Identity confirmed'
                  : isChecking
                      ? 'Please slowly turn your head'
                      : 'Slowly turn your head left and right',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // ----------------------------------------------------
          // Checking indicator
          // ----------------------------------------------------

          if (isChecking)
            const SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                color: orange,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Instruction card
  // ============================================================

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _InstructionRow(
            icon: Icons.check_circle_rounded,
            iconColor: green,
            text:
                'Good lighting · face clearly visible',
          ),

          const SizedBox(height: 13),

          _InstructionRow(
            icon: Icons.cancel_rounded,
            iconColor: red,
            text:
                'No sunglasses or face coverings',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Start button
  // ============================================================

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
        onPressed: isChecking
            ? null
            : _startFaceCheck,
        child: Text(
          isChecking
              ? 'Checking...'
              : 'Start face check →',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Continue button
  // ============================================================

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
        onPressed: _continueToDbs,
        child: const Text(
          'Face matched → continue →',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Instruction row
// ============================================================

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InstructionRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
