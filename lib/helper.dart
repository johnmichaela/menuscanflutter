// import 'package:flutter/material.dart';

// extension IconString on String {
//   IconData toIconData() {
//     switch (this) {
//       case 'ramen_dining': return Icons.ramen_dining;
//       case 'bakery_dining': return Icons.bakery_dining;
//       case 'local_bar': return Icons.local_bar;
//       case 'breakfast_dining': return Icons.breakfast_dining;
//       case 'brunch_dining': return Icons.brunch_dining;
//       case 'local_cafe': return Icons.local_cafe;
//       case 'fastfood': return Icons.fastfood;
//       case 'restaurant': return Icons.restaurant;
//       default: return Icons.restaurant;
//     }
//   }
// }

import 'package:flutter/material.dart';

extension IconString on String {
  IconData toIconData() {
    final iconMap = {
      'ramen_dining': Icons.ramen_dining,
      'bakery_dining': Icons.bakery_dining,
      'local_bar': Icons.local_bar,
      'breakfast_dining': Icons.breakfast_dining,
      'brunch_dining': Icons.brunch_dining,
      'local_cafe': Icons.local_cafe,
      'fastfood': Icons.fastfood,
      'restaurant': Icons.restaurant,
      'rice_bowl': Icons.rice_bowl,
      'bed': Icons.bed,
      'icecream': Icons.icecream,
      'coffee': Icons.coffee,
      'liquor': Icons.liquor,
      'local_pizza_rounded': Icons.local_pizza_rounded,
      'emoji_food_beverage': Icons.emoji_food_beverage,
      'takeout_dining': Icons.takeout_dining,
      'dinner_dining': Icons.dinner_dining,
      'sports_bar': Icons.sports_bar,
      'nightlife': Icons.nightlife,
      'music_note': Icons.music_note,
      'local_dining': Icons.local_dining,
      'cake': Icons.cake,
      'pizza': Icons.local_pizza,
      'restaurant_menu': Icons.restaurant_menu,
      'food_bank': Icons.food_bank,
      'lunch_dining': Icons.lunch_dining,
      'dining': Icons.dining,
      'kebab_dining': Icons.kebab_dining,
      'tapas': Icons.tapas,
      'soup_kitchen': Icons.soup_kitchen,
    };
    
    return iconMap[this] ?? Icons.restaurant; // Default fallback
  }
}