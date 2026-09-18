import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/my_requests_provider.dart';
import '../widgets/request_card.dart';
import '../../../core/widgets/shimmer_loading.dart';

class MyRequestsScreen
    extends ConsumerWidget {
  const MyRequestsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final requests =
        ref.watch(myRequestsProvider);

    return requests.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'You have not created any requests yet.',
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (
            context,
            index,
          ) {
            return RequestCard(
              request: items[index],
            );
          },
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
    );
  }
}