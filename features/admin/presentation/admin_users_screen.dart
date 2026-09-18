import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../providers/admin_users_provider.dart';
import '../../../providers/admin_repository_provider.dart';
import 'admin_user_details_screen.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({
    super.key,
  });

  @override
  ConsumerState<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState
    extends ConsumerState<AdminUsersScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  String searchText = "";

  String selectedFilter = "All";

  final List<String> filters = [
    "All",
    "Verified",
    "Pending",
    "Blocked",
    "Helpers",
    "Requesters",
    "Admins",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> filterUsers(
    List<UserModel> users,
  ) {
    var filtered = users;

    // Search
    if (searchText.isNotEmpty) {
      filtered = filtered.where((user) {
        final query =
            searchText.toLowerCase();

        return user.fullName
                .toLowerCase()
                .contains(query) ||
            user.email
                .toLowerCase()
                .contains(query) ||
            user.phoneNumber
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    switch (selectedFilter) {
      case "Verified":
        filtered = filtered
            .where(
              (u) =>
                  u.kycStatus ==
                  "verified",
            )
            .toList();
        break;

      case "Pending":
        filtered = filtered
            .where(
              (u) =>
                  u.kycStatus ==
                  "pending",
            )
            .toList();
        break;

      case "Blocked":
        filtered = filtered
            .where(
              (u) => u.isBlocked,
            )
            .toList();
        break;

      case "Helpers":
        filtered = filtered
            .where(
              (u) =>
                  u.role ==
                  "helper",
            )
            .toList();
        break;

      case "Requesters":
        filtered = filtered
            .where(
              (u) =>
                  u.role ==
                  "requester",
            )
            .toList();
        break;

      case "Admins":
        filtered = filtered
            .where(
              (u) =>
                  u.role ==
                  "admin",
            )
            .toList();
        break;
    }

    return filtered;
  }

  Color kycColor(
    String status,
  ) {
    switch (status) {
      case "verified":
        return Colors.green;

      case "pending":
        return Colors.orange;

      case "rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Color roleColor(
    String role,
  ) {
    switch (role) {
      case "admin":
        return Colors.red;

      case "helper":
        return Colors.blue;

      case "requester":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final users =
        ref.watch(
      adminUsersProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Management",
        ),
      ),
      body: users.when(
        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),
        error: (
          e,
          _,
        ) =>
            Center(
          child: Text(
            e.toString(),
          ),
        ),
        data: (items) {
          final filtered =
              filterUsers(items);

          if (filtered.isEmpty) {
            return const Center(
              child: Text(
                "No users found",
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: TextField(
                  controller:
                      _searchController,
                  decoration:
                      InputDecoration(
                    hintText:
                        "Search users...",
                    prefixIcon:
                        const Icon(
                      Icons.search,
                    ),
                    suffixIcon:
                        searchText
                                .isEmpty
                            ? null
                            : IconButton(
                                icon:
                                    const Icon(
                                  Icons.clear,
                                ),
                                onPressed:
                                    () {
                                  _searchController
                                      .clear();

                                  setState(() {
                                    searchText =
                                        "";
                                  });
                                },
                              ),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  onChanged:
                      (value) {
                    setState(() {
                      searchText =
                          value.trim();
                    });
                  },
                ),
              ),
                            SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final filter =
                        filters[index];

                    final selected =
                        selectedFilter ==
                            filter;

                    return ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter =
                              filter;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  itemCount:
                      filtered.length,
                  itemBuilder:
                      (
                        context,
                        index,
                      ) {
                    final user =
                        filtered[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AdminUserDetailsScreen(
                                userId:
                                    user.uid,
                              ),
                            ),
                          );
                        },
                        leading:
                            CircleAvatar(
                          child: Text(
                            user.fullName
                                    .isEmpty
                                ? "?"
                                : user
                                    .fullName[0]
                                    .toUpperCase(),
                          ),
                        ),
                        title: Text(
                          user.fullName,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              user.email,
                            ),
                            Text(
                              user.phoneNumber,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Chip(
                                  backgroundColor:
                                      kycColor(
                                    user.kycStatus,
                                  ),
                                  label: Text(
                                    user.kycStatus,
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                ),
                                Chip(
                                  backgroundColor:
                                      roleColor(
                                    user.role,
                                  ),
                                  label: Text(
                                    user.role,
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                ),
                                if (user
                                    .isBlocked)
                                  const Chip(
                                    backgroundColor:
                                        Colors.red,
                                    label: Text(
                                      "Blocked",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "⭐ Rating: ${user.averageRating.toStringAsFixed(1)}",
                            ),
                            Text(
                              "🏆 Points: ${user.points}",
                            ),
                            Text(
                              "⚠️ Strikes: ${user.strikeCount}",
                            ),
                          ],
                        ),
                        trailing:
                            PopupMenuButton<
                                String>(
                          onSelected:
                              (
                                value,
                              ) async {
                            switch (
                                value) {
                              case "strike":
                                await ref
                                    .read(
                                      adminRepositoryProvider,
                                    )
                                    .issueStrike(
                                      user.uid,
                                    );
                                break;

                              case "unblock":
                                await ref
                                    .read(
                                      adminRepositoryProvider,
                                    )
                                    .unblockUser(
                                      user.uid,
                                    );
                                break;
                            }
                          },
                          itemBuilder:
                              (_) => [
                            const PopupMenuItem(
                              value:
                                  "strike",
                              child: Text(
                                "Issue Strike",
                              ),
                            ),
                            const PopupMenuItem(
                              value:
                                  "unblock",
                              child: Text(
                                "Unblock User",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}