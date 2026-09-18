import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_analytics_model.dart';
import 'admin_repository_provider.dart';

final adminAnalyticsProvider =
    StreamProvider<AdminAnalyticsModel>((ref) {
  return ref
      .read(adminRepositoryProvider)
      .getAnalytics();
});