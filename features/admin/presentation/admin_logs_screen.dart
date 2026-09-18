import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/admin_log_model.dart';
import '../../../providers/admin_logs_provider.dart';
import 'admin_log_details_screen.dart';
// Phase 2.6D.2
// import 'admin_log_details_screen.dart';

class AdminLogsScreen extends ConsumerStatefulWidget {
  const AdminLogsScreen({
    super.key,
  });

  @override
  ConsumerState<AdminLogsScreen> createState() =>
      _AdminLogsScreenState();
}

class _AdminLogsScreenState
    extends ConsumerState<AdminLogsScreen> {
  String search = '';

  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'KYC',
    'Users',
    'Requests',
    'Reports',
  ];

  List<AdminLogModel> _filterLogs(
    List<AdminLogModel> logs,
  ) {
    Iterable<AdminLogModel> result = logs;

    if (search.isNotEmpty) {
      final query = search.toLowerCase();

      result = result.where(
        (log) =>
            log.action
                .toLowerCase()
                .contains(query) ||
            log.adminName
                .toLowerCase()
                .contains(query) ||
            log.targetName
                .toLowerCase()
                .contains(query) ||
            log.description
                .toLowerCase()
                .contains(query),
      );
    }

    if (selectedFilter != 'All') {
      result = result.where((log) {
        switch (selectedFilter) {
          case 'KYC':
            return log.action.contains(
              'KYC',
            );

          case 'Users':
            return log.action.contains(
                  'Strike',
                ) ||
                log.action.contains(
                  'Unblock',
                );

          case 'Requests':
            return log.action.contains(
              'Request',
            );

          case 'Reports':
            return log.action.contains(
              'Report',
            );

          default:
            return true;
        }
      });
    }

    return result.toList();
  }

  IconData _iconForAction(
    String action,
  ) {
    switch (action) {
      case 'Approve KYC':
        return Icons.verified;

      case 'Reject KYC':
        return Icons.cancel;

      case 'Issue Strike':
        return Icons.gavel;

      case 'Unblock User':
        return Icons.lock_open;

      case 'Delete Request':
        return Icons.delete;

      case 'Hide Request':
        return Icons.visibility_off;

      case 'Complete Request':
        return Icons.check_circle;

      case 'Resolve Report':
        return Icons.report;

      default:
        return Icons.history;
    }
  }

  Color _colorForAction(
    String action,
  ) {
    switch (action) {
      case 'Approve KYC':
        return Colors.green;

      case 'Reject KYC':
        return Colors.red;

      case 'Issue Strike':
        return Colors.orange;

      case 'Unblock User':
        return Colors.blue;

      case 'Delete Request':
        return Colors.red;

      case 'Hide Request':
        return Colors.deepOrange;

      case 'Complete Request':
        return Colors.green;

      case 'Resolve Report':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  String _dateHeader(
    DateTime date,
  ) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final yesterday = today.subtract(
      const Duration(
        days: 1,
      ),
    );

    final logDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (logDate == today) {
      return 'Today';
    }

    if (logDate == yesterday) {
      return 'Yesterday';
    }

    return DateFormat(
      'dd MMM yyyy',
    ).format(date);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final logs = ref.watch(
      adminLogsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Audit Logs',
        ),
      ),
      body: logs.when(
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
              _filterLogs(
            items,
          );

          if (filtered.isEmpty) {
            return const Center(
              child: Text(
                'No logs found.',
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
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Search logs...',
                    prefixIcon:
                        Icon(
                      Icons.search,
                    ),
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
                height: 55,
                child:
                    ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        12,
                  ),
                  scrollDirection:
                      Axis.horizontal,
                  itemCount:
                      filters.length,
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final filter =
                        filters[
                            index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 8,
                      ),
                      child:
                          ChoiceChip(
                        label: Text(
                          filter,
                        ),
                        selected:
                            selectedFilter ==
                                filter,
                        onSelected:
                            (_) {
                          setState(
                            () {
                              selectedFilter =
                                  filter;
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
                    ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        12,
                    vertical: 4,
                  ),
                  itemCount:
                      filtered.length,
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final log =
                        filtered[
                            index];

                    final created =
                        log.createdAt;

                    final date =
                        created
                                ?.toDate() ??
                            DateTime
                                .now();

                    final header =
                        _dateHeader(
                      date,
                    );

                    final showHeader =
                        index ==
                                0 ||
                            _dateHeader(
                                  filtered[
                                          index -
                                              1]
                                      .createdAt
                                      ?.toDate() ??
                                      DateTime
                                          .now(),
                                ) !=
                                header;
                                                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        if (showHeader)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 8,
                              bottom: 12,
                            ),
                            child: Text(
                              header,
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                        Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          elevation: 2,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AdminLogDetailsScreen(
                                    log: log,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [

                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        _colorForAction(
                                      log.action,
                                    ),
                                    child: Icon(
                                      _iconForAction(
                                        log.action,
                                      ),
                                      color:
                                          Colors.white,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 16,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [

                                        Text(
                                          log.action,
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 8,
                                        ),

                                        Text(
                                          log.description,
                                        ),

                                        const SizedBox(
                                          height: 14,
                                        ),

                                        Row(
                                          children: [

                                            const Icon(
                                              Icons.person,
                                              size:
                                                  16,
                                            ),

                                            const SizedBox(
                                              width:
                                                  6,
                                            ),

                                            Expanded(
                                              child:
                                                  Text(
                                                log.adminName,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 6,
                                        ),

                                        Row(
                                          children: [

                                            const Icon(
                                              Icons.ads_click,
                                              size:
                                                  16,
                                            ),

                                            const SizedBox(
                                              width:
                                                  6,
                                            ),

                                            Expanded(
                                              child:
                                                  Text(
                                                log.targetName,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Text(
                                          DateFormat(
                                            'dd MMM yyyy • HH:mm',
                                          ).format(
                                            date,
                                          ),
                                          style:
                                              TextStyle(
                                            color: Colors
                                                .grey
                                                .shade600,
                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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