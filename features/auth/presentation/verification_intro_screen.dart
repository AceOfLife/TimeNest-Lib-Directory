import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerificationIntroScreen extends StatelessWidget {
  const VerificationIntroScreen({super.key});

  static const Color orange = Color(0xFFFF765F);
  static const Color cream = Color(0xFFFFFBF5);

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
          'Verification',
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
            children: [
              const SizedBox(height: 8),

              // ------------------------------------------------
              // Verification icon
              // ------------------------------------------------

              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: orange.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 38,
                  color: orange,
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // Title
              // ------------------------------------------------

              const Text(
                'Get verified to join',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '5 steps. Keeps every child on TimeNest safe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // Verification checklist
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.035,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _VerificationStep(
                      icon: Icons.face_retouching_natural,
                      title: 'Identity check',
                      subtitle:
                          'Face ID + liveness',
                      badge: '~3 min',
                      badgeColor: orange,
                      isLast: false,
                    ),

                    _VerificationStep(
                      icon: Icons.badge_outlined,
                      title: 'Enhanced DBS check',
                      subtitle:
                          'Criminal record screening',
                      badge: '2–5 days',
                      badgeColor:
                          const Color(0xFFE8B94A),
                      isLast: false,
                    ),

                    _VerificationStep(
                      icon: Icons.people_alt_outlined,
                      title: '2 character references',
                      subtitle:
                          'Non-family, 2+ years known',
                      badge: '~5 min',
                      badgeColor:
                          const Color(0xFF55BFA8),
                      isLast: false,
                    ),

                    _VerificationStep(
                      icon: Icons.school_outlined,
                      title: 'NSPCC training',
                      subtitle:
                          'Free online safeguarding module',
                      badge: '90 min',
                      badgeColor:
                          const Color(0xFF55BFA8),
                      isLast: false,
                    ),

                    _VerificationStep(
                      icon: Icons.description_outlined,
                      title: 'DSL review',
                      subtitle:
                          'Human review, 1–2 days',
                      badge: '1–2 days',
                      badgeColor:
                          const Color(0xFFE8B94A),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ------------------------------------------------
              // Start verification
              // ------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 56,
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
                  onPressed: () {
                    context.push('/verification/identity');
                  },
                  child: const Text(
                    'Start verification →',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'You can exit and resume anytime.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Verification Step
// ============================================================

class _VerificationStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final bool isLast;

  const _VerificationStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        bottom: isLast ? 12 : 0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: badgeColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: badgeColor,
                ),
              ),

              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Time badge
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),

          if (!isLast) ...[
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
          ],
        ],
      ),
    );
  }
}