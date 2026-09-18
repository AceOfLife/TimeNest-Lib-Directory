import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:timenest/core/widgets/verified_badge.dart';
import 'package:timenest/features/profile/presentation/kyc_screen.dart';
import 'package:timenest/features/reviews/presentation/my_reviews_screen.dart';
import '../../../providers/current_user_provider.dart';
import '../../../providers/auth_repository_provider.dart';
import 'edit_profile_screen.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../notifications/presentation/notifications_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final user =
        ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
      ),
      body: user.when(
        data: (userData) {
          if (userData == null) {
            return const Center(
              child: Text(
                'User not found',
              ),
            );
          }

          return ListView(
            padding:
                const EdgeInsets.all(20),
            children: [
              Center(
  child: GestureDetector(
    onTap: () async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final url = await ref
    .read(authRepositoryProvider)
    .uploadProfilePhoto(
      File(image.path),
    );

print('Returned URL: $url');

await Future.delayed(
  const Duration(seconds: 1),
);

ref.invalidate(currentUserProvider);
    },
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: userData.photoUrl.isNotEmpty
              ? NetworkImage(userData.photoUrl)
              : null,
          child: userData.photoUrl.isEmpty
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        // Camera / Edit Icon
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.camera_alt,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const EditProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Profile',
                ),
              ),
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(
                          Icons.person,
                        ),
                        title: const Text(
                          'Full Name',
                        ),
                        subtitle: Text(
                          userData.fullName,
                        ),
                      ),

                      ListTile(
                        leading:
                            const Icon(
                          Icons.email,
                        ),
                        title: const Text(
                          'Email',
                        ),
                        subtitle: Text(
                          userData.email,
                        ),
                      ),

                      ListTile(
                        leading:
                            const Icon(
                          Icons.phone,
                        ),
                        title: const Text(
                          'Phone Number',
                        ),
                        subtitle: Text(
                          userData
                              .phoneNumber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Available Credits',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${userData.points}',
                        style:
                            const TextStyle(
                          fontSize: 32,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      const SizedBox(
                          height: 12,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [

                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                            const SizedBox(
                              width: 6,
                            ),

                            Text(
                              userData.averageRating
                                  .toStringAsFixed(1),
                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),


// Rwuse maybe later for rating

// Card(
//   child: Padding(
//     padding:
//         const EdgeInsets.all(
//       20,
//     ),
//     child: Column(
//       children: [
//         const Text(
//           'Reputation',
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         Text(
//           '${userData.averageRating.toStringAsFixed(1)} ⭐',
//           style:
//               const TextStyle(
//             fontSize: 32,
//             fontWeight:
//                 FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

const SizedBox(height: 20),

Card(
  child: Padding(
    padding:
        const EdgeInsets.all(
      20,
    ),
    child: Column(
      children: [
        const Text(
          'Strikes',
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          '${userData.strikeCount}',
          style:
              const TextStyle(
            fontSize: 32,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(
  height: 20,
),

const SizedBox(height: 20),

FilledButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const MyReviewsScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.reviews,
  ),
  label: const Text(
    'View Reviews',
  ),
),

const SizedBox(height: 20),

              FilledButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const KycScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.verified_user,
  ),
  label: const Text(
    'Submit KYC',
  ),
),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: Icon(
                    userData.kycStatus ==
                            'verified'
                        ? Icons
                            .verified
                        : Icons
                            .hourglass_top,
                  ),
                  title: Row(
                        children: [
                          const Text(
                            'KYC Status',
                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          if (userData.kycStatus ==
                              'verified')
                            const VerifiedBadge(),
                        ],
                      ),
                  subtitle: Row(
                    children: [
                      Text(
                        userData.kycStatus,
                      ),

                      if (userData.kycStatus ==
                          'verified')
                        const Padding(
                          padding:
                              EdgeInsets.only(
                            left: 8,
                          ),
                          child: Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),


              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(
                        authRepositoryProvider,
                      )
                      .logout();
                },
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Logout',
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                  ),
                  title: const Text(
                    'Notifications',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
        loading: () =>
           const ShimmerLoading(),
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