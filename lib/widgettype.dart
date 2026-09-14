
import 'package:ballon/models/profilebytype.dart';
import 'package:flutter/material.dart';
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
class FoodCardType extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  const FoodCardType({super.key, required this.food, this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              food.image!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
errorBuilder: (_, _, _) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(food.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(10)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, color: Colors.white, size: 10),
                    Text(' ${food.rating as double}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ]),
              const SizedBox(height: 4),
              Text(food.description!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('TZS ${(food.discountPrice ?? food.price)!}', style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold, fontSize: 15)),
                if (food.discountPrice != null)
                  Text('TZS ${food.price as double}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, decoration: TextDecoration.lineThrough)),
              ]),
            ]),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ]),
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
