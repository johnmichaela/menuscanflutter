import 'package:ballon/models/resturants.dart';
import 'package:flutter/material.dart';
import 'package:ballon/l10n/app_strings.dart';
import 'package:intl/intl.dart';
// import 'models.dart';

/// Padding extension for concise layout code.
extension WidgetExt on Widget {
  Widget padding({double? all, double? l, double? t, double? r, double? b, EdgeInsets? edge}) {
    if (edge != null) return Padding(padding: edge, child: this);
    return Padding(
      padding: EdgeInsets.only(
        left: l ?? all ?? 0,
        top: t ?? all ?? 0,
        right: r ?? all ?? 0,
        bottom: b ?? all ?? 0,
      ),
      child: this,
    );
  }
}

/// Reusable food card shown in menu lists.
// class FoodCard extends StatelessWidget {
//   final Food food;
//   final VoidCallback? onTap;
//   final VoidCallback? onAdd;
//   const FoodCard({super.key, required this.food, this.onTap, this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){},
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
// boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
//         ),
//         child: Row(children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.network(
//               food.image!,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
// errorBuilder: (_, _, _) => Container(
//                 width: 80,
//                 height: 80,
//                 color: Colors.grey.shade200,
//                 child: const Icon(Icons.fastfood, color: Colors.grey),
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(children: [
//                 Expanded(child: Text(food.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(10)),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     const Icon(Icons.star, color: Colors.white, size: 10),
//                     Text(' ${food.rating as double}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                   ]),
//                 ),
//               ]),
//               const SizedBox(height: 4),
//               Text(food.description!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
//               const SizedBox(height: 8),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text('${food.currency ?? 'TZS'} ${(food.discountPrice ?? food.price)!}', style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold, fontSize: 15)),
//                 if (food.discountPrice != null)
//                   Text('${food.currency ?? 'TZS'} ${food.price as double}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, decoration: TextDecoration.lineThrough)),
//               ]),
//             ]),
//           ),
//           const SizedBox(width: 8),
//           // GestureDetector(
//           //   onTap: onAdd,
//           //   child: Container(
//           //     padding: const EdgeInsets.all(8),
//           //     decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(12)),
//           //     child: const Icon(Icons.add, color: Colors.white, size: 20),
//           //   ),
//           // ),
//         ]),
//       ),
//     );
//   }
// }
class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const FoodCard({
    super.key,
    required this.food,
    this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Safe values
    final String imageUrl = food.image ?? '';
    final String foodName = food.name ?? 'No Name';
    final String description = food.description ?? 'No Description';

    final double rating = food.rating ?? 0.0;

    final double price = food.price ?? 0.0;
    final double? discountPrice = food.discountPrice;

    final String currency = food.currency ?? 'TZS';

    final double displayPrice = discountPrice ?? price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 122, 122, 122).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color.fromARGB(255, 102, 102, 102).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.04),
          //     blurRadius: 12,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child:  Icon(
                            Icons.fastfood,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child:  Icon(
                        Icons.fastfood,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            // Food information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          foodName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 6),

                     
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(price==0)
                         Text(
                        'Free',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 8, 214, 87),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if(price!=0)
                      Text(
                        '$currency ${NumberFormat.decimalPattern().format(displayPrice)}',
                        // '$currency ${displayPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          // color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                     SizedBox(width: 5,),
                      // Original price when discounted
                      if (discountPrice != null)
                        Text(
                          '$currency ${NumberFormat.decimalPattern().format(price)}',
                          // '$currency ${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 9,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Spacer(),
                        food.isAvailable!?
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 8, 214, 87).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Color.fromARGB(255, 8, 214, 87))

                          ),
                          child: Text(context.tr.available,style: TextStyle(color: Color.fromARGB(255, 8, 214, 87),fontSize: 10,fontWeight: FontWeight.w500),),):
                           Container(
                          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.red)

                          ),
                          child: Text(context.tr.unavailable,style: TextStyle(color: Colors.red,fontSize: 10,fontWeight: FontWeight.w500),),)
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),
Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withOpacity(0.6),
              size: 20,
            ),
           
          ],
        ),
      ),
    );
  }
}

/// Placeholder used for not-yet-built tabs.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.construction, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('$title screen coming soon', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ]),
      ),
    );
  }
}
