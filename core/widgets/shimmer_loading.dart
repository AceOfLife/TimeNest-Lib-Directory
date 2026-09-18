import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading
    extends StatelessWidget {
  const ShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          Colors.grey.shade300,
      highlightColor:
          Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (_, __) {
          return Card(
            child: Container(
              height: 90,
              margin:
                  const EdgeInsets.all(8),
            ),
          );
        },
      ),
    );
  }
}