import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/review_repository_provider.dart';

class RateHelperScreen
    extends ConsumerStatefulWidget {
  final String requestId;
  final String helperId;

  const RateHelperScreen({
    super.key,
    required this.requestId,
    required this.helperId,
  });

  @override
  ConsumerState<RateHelperScreen>
      createState() =>
          _RateHelperScreenState();
}

class _RateHelperScreenState
    extends ConsumerState<
        RateHelperScreen> {
  int rating = 5;

  final commentController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Rate Helper'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<int>(
              value: rating,
              isExpanded: true,
              items: List.generate(
                5,
                (index) =>
                    DropdownMenuItem(
                  value: index + 1,
                  child: Text(
                    '${index + 1} Star',
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  rating = value!;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  commentController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                hintText:
                    'Leave a review',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await ref
                      .read(
                        reviewRepositoryProvider,
                      )
                      .submitReview(
                        requestId:
                            widget.requestId,
                        revieweeId:
                            widget.helperId,
                        rating: rating,
                        comment:
                            commentController
                                .text
                                .trim(),
                      );

                  if (context.mounted) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
                child: const Text(
                  'Submit Review',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}