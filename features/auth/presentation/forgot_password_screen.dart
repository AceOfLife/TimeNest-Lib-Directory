import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_repository_provider.dart';

class ForgotPasswordScreen
    extends ConsumerStatefulWidget {
  const ForgotPasswordScreen(
      {super.key});

  @override
  ConsumerState<ForgotPasswordScreen>
      createState() =>
          _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<
        ForgotPasswordScreen> {
  final emailController =
      TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            emailController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Reset email sent',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Reset Password'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: isLoading
                  ? null
                  : resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Send Reset Link',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}