import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';

// Adjust this import to point to the file containing your local `Shimmer` class.
// e.g. import 'package:your_app/widgets/shimmer.dart';


/// A shimmer placeholder grid that mirrors the layout of `_buildBusinessCard`.
/// Shown while category data is loading.
///
/// Usage:
/// ```dart
/// if (loadRepresentShimmer) {
///   return const BusinessCardShimmerGrid();
/// }
/// ```
class BusinessCardShimmerGrid extends StatelessWidget {
  const BusinessCardShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 0.85,
    this.borderRadius = 12,
  });

  /// Number of shimmer tiles to render.
  final int itemCount;

  /// Columns in the grid. Should match your real grid.
  final int crossAxisCount;

  /// Horizontal spacing between tiles.
  final double crossAxisSpacing;

  /// Vertical spacing between tiles.
  final double mainAxisSpacing;

  /// Width / height ratio of each tile. Should match your real grid.
  final double childAspectRatio;

  /// Corner radius of each card.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Theme.of(context).cardColor : Colors.grey[300]!;
    final highlightColor = isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.grey[100]!;

    // One Shimmer wraps the whole grid for better performance
    // (as recommended in the shimmer docs).
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => _BusinessCardShimmerTile(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class _BusinessCardShimmerTile extends StatelessWidget {
  const _BusinessCardShimmerTile({required this.borderRadius});

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
              child: Container(color: Colors.white),
            ),
          ),
          // Details placeholder
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon circle
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Two text lines
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 8,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Chevron placeholder
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}