import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/my_tasks_provider.dart';
import '../widgets/request_card.dart';
import '../../../core/widgets/shimmer_loading.dart';

class MyTasksScreen
    extends ConsumerWidget {
  const MyTasksScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final tasks =
        ref.watch(myTasksProvider);

    return tasks.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No accepted tasks yet.',
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