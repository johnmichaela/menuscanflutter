
// import 'package:ballon/models/event.dart';
// import 'package:flutter/material.dart';

// class MultipleImageWidget extends StatelessWidget {
//   final List<Images> imageUrls;
//   final double height;
//   final double spacing;
//   final double borderRadius;
//   final String? mainTitle;
//   final String? mainSubtitle;
//   final bool showFeatured;

//   const MultipleImageWidget({
//     super.key,
//     required this.imageUrls,
//     this.height = 280,
//     this.spacing = 4,
//     this.borderRadius = 12,
//     this.mainTitle,
//     this.mainSubtitle,
//     this.showFeatured = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (imageUrls.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: SizedBox(
//         height: height,
//         child: _buildLayout(),
//       ),
//     );
//   }

//   Widget _buildLayout() {
//     final int count = imageUrls.length;

//     switch (count) {
//       case 1:
//         return _buildSingleImage();
//       case 2:
//         return _buildTwoImages();
//       case 3:
//         return _buildThreeImages();
//       case 4:
//         return _buildFourImages();
//       default:
//         return _buildMoreImages();
//     }
//   }

//   // 1 Image - Full width with overlay
//   Widget _buildSingleImage() {
//     return _buildImageWithOverlay(
//       imageUrls[0].image ?? '',
//       isMain: true,
//       borderRadius: BorderRadius.circular(borderRadius),
//     );
//   }

//   // 2 Images - Equal split horizontally
//   Widget _buildTwoImages() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildImageWithOverlay(
//             imageUrls[0].image ?? '',
//             isMain: true,
//             borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
//           ),
//         ),
//         SizedBox(width: spacing),
//         Expanded(
//           child: _buildImageWithOverlay(
//             imageUrls[1].image ?? '',
//             borderRadius: BorderRadius.horizontal(right: Radius.circular(borderRadius)),
//           ),
//         ),
//       ],
//     );
//   }

//   // 3 Images - Main + 2 side (vertical)
//   Widget _buildThreeImages() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: _buildImageWithOverlay(
//             imageUrls[0].image ?? '',
//             isMain: true,
//             borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
//           ),
//         ),
//         SizedBox(width: spacing),
//         Expanded(
//           flex: 1,
//           child: Column(
//             children: [
//               Expanded(
//                 child: _buildSideImage(
//                   imageUrls[1].image ?? '',
//                   topRadius: true,
//                 ),
//               ),
//               SizedBox(height: spacing),
//               Expanded(
//                 child: _buildSideImage(
//                   imageUrls[2].image ?? '',
//                   bottomRadius: true,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // 4 Images - Main + 3 side images (like Instagram collage)
//   Widget _buildFourImages() {
//     return Row(
//       children: [
//         // Main Image (left side)
//         Expanded(
//           flex: 2,
//           child: _buildImageWithOverlay(
//             imageUrls[0].image ?? '',
//             isMain: true,
//             borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
//           ),
//         ),
//         SizedBox(width: spacing),
//         // 3 Side Images (right side)
//         Expanded(
//           flex: 1,
//           child: Column(
//             children: [
//               Expanded(
//                 child: _buildSideImage(
//                   imageUrls[1].image ?? '',
//                   topRadius: true,
//                 ),
//               ),
//               SizedBox(height: spacing),
//               Expanded(
//                 child: _buildSideImage(
//                   imageUrls[2].image ?? '',
//                 ),
//               ),
//               SizedBox(height: spacing),
//               Expanded(
//                 child: _buildSideImage(
//                   imageUrls[3].image ?? '',
//                   bottomRadius: true,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }


//   // 5+ Images - Scrollable horizontal with first as main
//   Widget _buildMoreImages() {
//     final firstImage = imageUrls[0].image ?? '';
//     final restImages = imageUrls.skip(1).toList();

//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: _buildImageWithOverlay(
//             firstImage,
//             isMain: true,
//             borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
//           ),
//         ),
//         SizedBox(width: spacing),
//         Expanded(
//           flex: 1,
//           child: SizedBox(
//             height: height,
//             child: ListView.builder(
//               itemCount: restImages.length,
//               itemBuilder: (context, index) {
//                 final isLast = index == restImages.length - 1;
//                 final isFirst = index == 0;

//                 return Column(
//                   children: [
//                     if (!isFirst) SizedBox(height: spacing),
//                     Expanded(
//                       child: _buildSideImage(
//                         restImages[index].image ?? '',
//                         topRadius: isFirst,
//                         bottomRadius: isLast,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Side image helper
//   Widget _buildSideImage(
//     String url, {
//     bool topRadius = false,
//     bool bottomRadius = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: topRadius ? Radius.circular(borderRadius) : Radius.zero,
//           bottom: bottomRadius ? Radius.circular(borderRadius) : Radius.zero,
//         ),
//         image: DecorationImage(
//           image: NetworkImage(url),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   // Main image with overlay
//   Widget _buildImageWithOverlay(
//     String url, {
//     bool isMain = false,
//     required BorderRadius borderRadius,
//     String? title,
//     String? subtitle,
//     bool showFeatured = false,
//   }) {
//     return Stack(
//       children: [
//         // Background Image
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: borderRadius,
//             image: DecorationImage(
//               image: NetworkImage(url),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // Dark gradient overlay
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: borderRadius,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: isMain
//                   ? [Colors.transparent, Colors.black54]
//                   : [Colors.transparent, Colors.black38],
//             ),
//           ),
//         ),
//         // Featured tag
//         if (isMain && (showFeatured || this.showFeatured))
//           Positioned(
//             top: 12,
//             left: 12,
//             child: Row(
//               children: [
//                 const Icon(Icons.star, size: 16, color: Colors.yellow),
//                 const SizedBox(width: 4),
//                 Text(
//                   "Featured",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         // Title overlay for main image
//         if (isMain)
//           Positioned(
//             bottom: 16,
//             left: 12,
//             right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title ?? mainTitle ?? "Event Title 🎉",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle ?? mainSubtitle ?? "Great moments await you!",
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 11,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:ballon/models/event.dart';
import 'package:flutter/material.dart';

class MultipleImageWidget extends StatelessWidget {
  final List<Images> imageUrls;
  final double height;
  final double spacing;
  final double borderRadius;
  final String? mainTitle;
  final String? mainSubtitle;
  final bool showFeatured;
  final Color? overlayColor;
  final int mainImageFlex;
  final int sideImageFlex;

  const MultipleImageWidget({
    super.key,
    required this.imageUrls,
    this.height = 280,
    this.spacing = 4,
    this.borderRadius = 12,
    this.mainTitle,
    this.mainSubtitle,
    this.showFeatured = false,
    this.overlayColor,
    this.mainImageFlex = 2,
    this.sideImageFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: height,
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    final int count = imageUrls.length;

    switch (count) {
      case 1:
        return _buildSingleImage();
      case 2:
        return _buildTwoImages();
      case 3:
        return _buildThreeImages();
      case 4:
        return _buildFourImages();
      default:
        return _buildMoreImages(count);
    }
  }

  // 1 Image - Full width with overlay
  Widget _buildSingleImage() {
    return _buildImageWithOverlay(
      imageUrls[0].image ?? '',
      isMain: true,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  // 2 Images - Equal split horizontally
  Widget _buildTwoImages() {
    return Row(
      children: [
        Expanded(
          child: _buildImageWithOverlay(
            imageUrls[0].image ?? '',
            isMain: true,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: _buildImageWithOverlay(
            imageUrls[1].image ?? '',
            borderRadius: BorderRadius.horizontal(right: Radius.circular(borderRadius)),
          ),
        ),
      ],
    );
  }

  // 3 Images - Main + 2 side (vertical)
  Widget _buildThreeImages() {
    return Row(
      children: [
        Expanded(
          flex: mainImageFlex,
          child: _buildImageWithOverlay(
            imageUrls[0].image ?? '',
            isMain: true,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: sideImageFlex,
          child: Column(
            children: [
              Expanded(
                child: _buildSideImage(
                  imageUrls[1].image ?? '',
                  topRadius: true,
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: _buildSideImage(
                  imageUrls[2].image ?? '',
                  bottomRadius: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4 Images - Main + 3 side images (Instagram style)
  Widget _buildFourImages() {
    return Row(
      children: [
        Expanded(
          flex: mainImageFlex,
          child: _buildImageWithOverlay(
            imageUrls[0].image ?? '',
            isMain: true,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          flex: sideImageFlex,
          child: Column(
            children: [
              Expanded(
                child: _buildSideImage(
                  imageUrls[1].image ?? '',
                  topRadius: true,
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: _buildSideImage(
                  imageUrls[2].image ?? '',
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: _buildSideImage(
                  imageUrls[3].image ?? '',
                  bottomRadius: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 5+ Images - Show first 3 side images with +N overlay on the last one
  Widget _buildMoreImages(int totalCount) {
    final firstImage = imageUrls[0].image ?? '';
    final remainingImages = imageUrls.skip(1).toList();
    final int remainingCount = remainingImages.length;

    // Show only first 3 side images
    final List<Images> displayImages = remainingImages.take(3).toList();
    final int extraCount = remainingCount - 3;

    return Row(
      children: [
        // Main Image
        Expanded(
          flex: mainImageFlex,
          child: _buildImageWithOverlay(
            firstImage,
            isMain: true,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(borderRadius)),
          ),
        ),
        SizedBox(width: spacing),
        // Side Images Column
        Expanded(
          flex: sideImageFlex,
          child: Column(
            children: [
              // First side image
              Expanded(
                child: _buildSideImage(
                  displayImages[0].image ?? '',
                  topRadius: true,
                ),
              ),
              SizedBox(height: spacing),
              // Second side image
              Expanded(
                child: _buildSideImage(
                  displayImages[1].image ?? '',
                ),
              ),
              SizedBox(height: spacing),
              // Third side image with +N overlay if more than 3
              Expanded(
                child: _buildSideImageWithCount(
                  displayImages[2].image ?? '',
                  extraCount: extraCount,
                  bottomRadius: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Side image with +N overlay
  Widget _buildSideImageWithCount(
    String url, {
    required int extraCount,
    bool topRadius = false,
    bool bottomRadius = false,
    bool leftRadius = false,
    bool rightRadius = false,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: topRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
              topRight: topRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
              bottomLeft: bottomRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
              bottomRight: bottomRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
            ),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dark overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: topRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
              topRight: topRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
              bottomLeft: bottomRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
              bottomRight: bottomRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
            ),
            color: extraCount > 0 ? Colors.black.withOpacity(0.5) : Colors.transparent,
          ),
        ),
        // +N overlay
        if (extraCount > 0)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+$extraCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'more',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Side image helper
  Widget _buildSideImage(
    String url, {
    bool topRadius = false,
    bool bottomRadius = false,
    bool leftRadius = false,
    bool rightRadius = false,
  }) {
    if (url.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: topRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
            topRight: topRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
            bottomLeft: bottomRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
            bottomRight: bottomRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
          ),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: topRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
          topRight: topRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
          bottomLeft: bottomRadius && leftRadius ? Radius.circular(borderRadius) : Radius.zero,
          bottomRight: bottomRadius && rightRadius ? Radius.circular(borderRadius) : Radius.zero,
        ),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Main image with overlay
  Widget _buildImageWithOverlay(
    String url, {
    bool isMain = false,
    required BorderRadius borderRadius,
    String? title,
    String? subtitle,
    bool showFeatured = false,
  }) {
    if (url.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 50),
        ),
      );
    }

    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dark gradient overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isMain
                  ? [Colors.transparent, Colors.black54]
                  : [Colors.transparent, Colors.black38],
            ),
          ),
        ),
        // Featured tag
        if (isMain && (showFeatured || this.showFeatured))
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  SizedBox(width: 4),
                  Text(
                    "Featured",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Title overlay for main image
        if (isMain)
          Positioned(
            bottom: 16,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? mainTitle ?? "Event Title 🎉",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle ?? mainSubtitle ?? "Great moments await you!",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }
}