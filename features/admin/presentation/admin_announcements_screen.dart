import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/announcement_model.dart';
import '../../../providers/announcement_repository_provider.dart';
import '../../../providers/announcements_provider.dart';
import 'create_announcement_screen.dart';

class AdminAnnouncementsScreen
    extends ConsumerStatefulWidget {
  const AdminAnnouncementsScreen({
    super.key,
  });

  @override
  ConsumerState<AdminAnnouncementsScreen>
      createState() =>
          _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState
    extends ConsumerState<AdminAnnouncementsScreen> {
  String search = '';

  String filter = 'All';

  final filters = const [
    'All',
    'Draft',
    'Scheduled',
    'Sent',
    'Expired',
    'Archived',
  ];

  List<AnnouncementModel>
      _filterAnnouncements(
    List<AnnouncementModel> items,
  ) {
    var filtered = items;

    if (filter != 'All') {
      if (filter == 'Archived') {
        filtered = filtered
            .where(
              (e) => e.isArchived,
            )
            .toList();
      } else {
        filtered = filtered
            .where(
              (e) =>
                  e.status == filter &&
                  !e.isArchived,
            )
            .toList();
      }
    }

    if (search.isEmpty) {
      return filtered;
    }

    final query =
        search.toLowerCase();

    return filtered.where((item) {
      return item.title
              .toLowerCase()
              .contains(query) ||
          item.message
              .toLowerCase()
              .contains(query) ||
          item.audience
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  Color priorityColor(
    String priority,
  ) {
    switch (priority) {
      case 'Critical':
        return Colors.red;

      case 'High':
        return Colors.orange;

      case 'Normal':
        return Colors.blue;

      case 'Low':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  Color statusColor(
    String status,
  ) {
    switch (status) {
      case 'Draft':
        return Colors.grey;

      case 'Scheduled':
        return Colors.orange;

      case 'Sent':
        return Colors.green;

      case 'Expired':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final announcements =
        ref.watch(
      announcementsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateAnnouncementScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.campaign,
        ),
        label: const Text(
          'Create',
        ),
      ),
      body: announcements.when(
        loading: () =>
            const Center(
          child:
              CircularProgressIndicator(),
        ),
        error: (
          error,
          stack,
        ) =>
            Center(
          child: Text(
            error.toString(),
          ),
        ),
        data: (items) {
          final filtered =
              _filterAnnouncements(
            items,
          );

          return Column(
            children: [

              Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: TextField(
                  decoration:
                      const InputDecoration(
                    prefixIcon:
                        Icon(
                      Icons.search,
                    ),
                    hintText:
                        'Search announcements...',
                    border:
                        OutlineInputBorder(),
                  ),
                  onChanged:
                      (value) {
                    setState(() {
                      search =
                          value;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  itemCount:
                      filters.length,
                  itemBuilder:
                      (
                        context,
                        index,
                      ) {
                    final item =
                        filters[index];

                    final selected =
                        filter ==
                            item;

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 8,
                      ),
                      child:
                          ChoiceChip(
                        selected:
                            selected,
                        label:
                            Text(
                          item,
                        ),
                        onSelected:
                            (_) {
                          setState(
                            () {
                              filter =
                                  item;
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Expanded(
                child:
                    filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No announcements found.',
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              bottom: 20,
                            ),
                            itemCount:
                                filtered.length,
                            itemBuilder:
                                (
                                  context,
                                  index,
                                ) {
                              final announcement =
                                  filtered[index];
                                                                return Card(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        priorityColor(
                                      announcement.priority,
                                    ),
                                    child: Icon(
                                      announcement.isPinned
                                          ? Icons.push_pin
                                          : Icons.campaign,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          announcement.title,
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (announcement.isPinned)
                                        const Icon(
                                          Icons.push_pin,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          announcement.message,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            Chip(
                                              label: Text(
                                                announcement
                                                    .audience,
                                              ),
                                            ),
                                            Chip(
                                              backgroundColor:
                                                  priorityColor(
                                                announcement
                                                    .priority,
                                              ),
                                              label: Text(
                                                announcement
                                                    .priority,
                                                style:
                                                    const TextStyle(
                                                  color: Colors
                                                      .white,
                                                ),
                                              ),
                                            ),
                                            Chip(
                                              backgroundColor:
                                                  statusColor(
                                                announcement
                                                    .status,
                                              ),
                                              label: Text(
                                                announcement
                                                    .status,
                                                style:
                                                    const TextStyle(
                                                  color: Colors
                                                      .white,
                                                ),
                                              ),
                                            ),
                                            if (announcement
                                                .isArchived)
                                              const Chip(
                                                label: Text(
                                                  'Archived',
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing:
                                      PopupMenuButton<
                                          String>(
                                    onSelected:
                                        (
                                          value,
                                        ) async {
                                      final repo =
                                          ref.read(
                                        announcementRepositoryProvider,
                                      );

                                      switch (
                                          value) {
                                        case 'pin':
                                          if (announcement
                                              .isPinned) {
                                            await repo
                                                .unpinAnnouncement(
                                              announcement
                                                  .id,
                                            );
                                          } else {
                                            await repo
                                                .pinAnnouncement(
                                              announcement
                                                  .id,
                                            );
                                          }
                                          break;

                                        case 'archive':
                                          if (announcement
                                              .isArchived) {
                                            await repo
                                                .unarchiveAnnouncement(
                                              announcement
                                                  .id,
                                            );
                                          } else {
                                            await repo
                                                .archiveAnnouncement(
                                              announcement
                                                  .id,
                                            );
                                          }
                                          break;

                                        case 'delete':
                                          final confirm =
                                              await showDialog<
                                                  bool>(
                                            context:
                                                context,
                                            builder:
                                                (
                                                  context,
                                                ) {
                                              return AlertDialog(
                                                title:
                                                    const Text(
                                                  'Delete Announcement',
                                                ),
                                                content:
                                                    const Text(
                                                  'Are you sure you want to delete this announcement?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () {
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      );
                                                    },
                                                    child:
                                                        const Text(
                                                      'Cancel',
                                                    ),
                                                  ),
                                                  FilledButton(
                                                    onPressed:
                                                        () {
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      );
                                                    },
                                                    child:
                                                        const Text(
                                                      'Delete',
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm ==
                                              true) {
                                            await repo
                                                .deleteAnnouncement(
                                              announcement
                                                  .id,
                                            );
                                          }

                                          break;
                                      }
                                    },
                                    itemBuilder:
                                        (
                                          context,
                                        ) =>
                                            [
                                      PopupMenuItem(
                                        value:
                                            'pin',
                                        child: Text(
                                          announcement
                                                  .isPinned
                                              ? 'Unpin'
                                              : 'Pin',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value:
                                            'archive',
                                        child: Text(
                                          announcement
                                                  .isArchived
                                              ? 'Unarchive'
                                              : 'Archive',
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value:
                                            'delete',
                                        child: Text(
                                          'Delete',
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