import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_repository_provider.dart';
import '../../../providers/current_user_provider.dart';

class EditProfileScreen
    extends ConsumerStatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  ConsumerState<EditProfileScreen>
      createState() =>
          _EditProfileScreenState();
}

class _EditProfileScreenState
    extends ConsumerState<EditProfileScreen> {
  final fullNameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final user =
        ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Profile'),
      ),
      body: user.when(
        data: (userData) {
          if (userData == null) {
            return const SizedBox();
          }

          if (!initialized) {
            fullNameController.text =
                userData.fullName;

            phoneController.text =
                userData.phoneNumber;

            initialized = true;
          }

          return Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller:
                      fullNameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Full Name',
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextField(
                  controller:
                      phoneController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Phone Number',
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                FilledButton(
                  onPressed: () async {
                    await ref
                        .read(
                          authRepositoryProvider,
                        )
                        .updateProfile(
                          fullName:
                              fullNameController
                                  .text
                                  .trim(),
                          phoneNumber:
                              phoneController
                                  .text
                                  .trim(),
                        );

                    ref.invalidate(
                      currentUserProvider,
                    );

                    if (mounted) {
                      Navigator.pop(
                          context);
                    }
                  },
                  child: const Text(
                    'Save Changes',
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),
        error: (e, _) =>
            Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
    );
  }
}