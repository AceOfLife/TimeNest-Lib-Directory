import 'package:go_router/go_router.dart';

import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/verification_intro_screen.dart';
import '../features/auth/presentation/identity_verification_screen.dart';
import '../features/auth/presentation/face_liveness_screen.dart';
import '../features/auth/presentation/dbs_verification_screen.dart';
import '../features/auth/presentation/references_verification_screen.dart';
import '../features/auth/presentation/training_verification_screen.dart';
import '../features/auth/presentation/dsl_review_screen.dart';
import '../features/auth/presentation/add_child_screen.dart';
import '../features/auth/presentation/add_school_screen.dart';
import '../features/auth/presentation/verification_complete_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../features/navigation/presentation/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) =>
          const VerificationIntroScreen(),
    ),
    GoRoute(
      path: '/verification/identity',
      builder: (context, state) =>
          const IdentityVerificationScreen(),
    ),
    GoRoute(
      path: '/verification/identity',
      builder: (context, state) =>
          const FaceLivenessScreen(),
    ),
    GoRoute(
      path: '/verification/dbs',
      builder: (context, state) =>
          const DbsVerificationScreen(),
    ),
    GoRoute(
      path: '/verification/references',
      builder: (context, state) =>
          const ReferencesVerificationScreen(),
    ),
    GoRoute(
      path: '/verification/training',
      builder: (context, state) =>
          const TrainingVerificationScreen(),
    ),
    GoRoute(
      path: '/verification/review',
      builder: (context, state) =>
          const DslReviewScreen(),
    ),
    GoRoute(
      path: '/verification/add-child',
      builder: (context, state) =>
          const AddChildScreen(),
    ),
    GoRoute(
      path: '/verification/add-school',
      builder: (context, state) =>
          const AddSchoolScreen(),
    ),
    GoRoute(
      path: '/verification/complete',
      builder: (context, state) =>
          const VerificationCompleteScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) =>
          const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/auth-gate',
      builder: (context, state) =>
          const AuthGate(),
    ),
  ],
);