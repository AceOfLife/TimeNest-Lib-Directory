import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class HelperProfileCard extends StatelessWidget {
  final UserModel user;
  final bool isRequester;

  const HelperProfileCard({
    super.key,
    required this.user,
    required this.isRequester,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundImage: user.photoUrl.isNotEmpty
                  ? NetworkImage(user.photoUrl)
                  : null,
              child: user.photoUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 34,
                    )
                  : null,
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      if (user.kycStatus ==
                          "verified")
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isRequester
                        ? "Your Helper"
                        : "Requester",
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        user.averageRating
                            .toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}