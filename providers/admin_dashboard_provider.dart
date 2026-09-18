import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_dashboard_stats_model.dart';
import 'admin_repository_provider.dart';

final adminDashboardProvider =
StreamProvider<AdminDashboardStatsModel>(
(ref) {
return ref
.read(
adminRepositoryProvider,
)
.getDashboardStats();
},
);
