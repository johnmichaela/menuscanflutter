
import 'package:ballon/app_state.dart';
import 'package:ballon/models.dart';
import 'package:ballon/models/profilebytype.dart';

import 'package:ballon/typeapp_state.dart';
import 'package:ballon/widgets.dart';
import 'package:ballon/widgettype.dart' hide WidgetExt;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantTypeScreen extends StatelessWidget {
  final Result restaurant;
  const RestaurantTypeScreen({super.key, required this.restaurant});

  Future<void> _openDirections(BuildContext context) async {
    final r = restaurant;
    String query;
    if (r.latitude != null && r.longitude != null) {
      query = '${r.latitude},${r.longitude}';
    } else if (r.place!.isNotEmpty) {
      query = Uri.encodeComponent('${r.place}, ');
    } else {
      query = Uri.encodeComponent(r.name!);
    }
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$query';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open Google Maps')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppStateType>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFFE71D36),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(
                icon: Icon(app.isRestaurantFavorite(restaurant) ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                onPressed: () => app.toggleRestaurantFavorite(restaurant),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Image.network(restaurant.banner!.isNotEmpty ? '${restaurant.banner}' : '${restaurant.banner}', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE71D36))),
                Container(color: Colors.black.withOpacity(0.3)),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: CircleAvatar (backgroundImage: NetworkImage('${restaurant.picture}'))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(restaurant.name!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    Text('${restaurant.place!.isNotEmpty ? ' · ${restaurant.place}' : ''}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ])),
                  _ratingChip(restaurant.rating!),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _statusChip(restaurant.isOpen as bool ? 'Open' : 'Closed', restaurant.isOpen as bool ? const Color(0xFF2ecc71) : const Color(0xFFe74c3c)),
                  const SizedBox(width: 8),
                  // if (restaurant.hasDineIn as bool) _statusChip('Dine In', const Color(0xFF3498db)),
                  // if (restaurant.hasPickup as bool) ...[const SizedBox(width: 8), _statusChip('Pickup', const Color(0xFFf39c12))],
                  // if (restaurant.hasDelivery as bool) ...[const SizedBox(width: 8), _statusChip('Delivery', const Color(0xFF9b59b6))],
                ]),
                const SizedBox(height: 12),
                Text(restaurant.bio!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 16),
                // Directions button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openDirections(context),
                    icon: const Icon(Icons.directions, color: Color(0xFFE71D36)),
                    label: const Text('Get Directions', style: TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE71D36)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                // if (restaurant.table != null) ...[
                //   const SizedBox(height: 12),
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(color: const Color(0xFFE71D36).withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                //     child: Row(children: [
                //       const Icon(Icons.table_restaurant, color: Color(0xFFE71D36)),
                //       const SizedBox(width: 8),
                //       Text('Ordering for Table ${restaurant.table!.name}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE71D36))),
                //     ]),
                //   ),
                // ],
              ]),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     child: TabBar(
          //       labelColor: const Color(0xFFE71D36),
          //       unselectedLabelColor: Colors.grey.shade600,
          //       indicatorColor: const Color(0xFFE71D36),
          //       tabs: const [Tab(text: 'Menu'), Tab(text: 'About'), Tab(text: 'Reviews')],
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _menuSection(context)),
          ),
        ]),
        bottomNavigationBar: app.cartItems.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]),
                child: Row(children: [
                  Expanded(child: Text('${app.cartItems.length} items · TZS ${app.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  // ElevatedButton(

                  //   // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  //   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE71D36), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                  //   child: const Text('View Cart'),
                  // ),
                ]),
              )
            : null,
      ),
    );
  }

  Widget _menuSection(BuildContext context) {
    final restaurant = this.restaurant;
    final List<String> categories = ['All'];
    final List<Food> foods = restaurant.food!;
    return foods.isNotEmpty? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, i) => Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(color: i == 0 ? const Color(0xFFE71D36) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: i == 0 ? Colors.transparent : Colors.grey.shade200)),
            child: Center(child: Text(categories[i], style: TextStyle(color: i == 0 ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 13))),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Column(
        children: foods.map((f) => FoodCardType(
          food: f,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: f))),
          onAdd: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: f))),
        ).padding(b: 12)).toList(),
      ),
    ]):Center(child: Text("No Menu Available",style: TextStyle(fontSize: 16),),);
  }

  // List<FoodItemModel> _fallbackFoods() {
  //   return [
  //     FoodItemModel(id: 1, name: 'Beef Burger', description: 'Juicy beef patty with cheese & veggies', price: 8000, image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop', rating: 4.5, category: 'Burger'),
  //     FoodItemModel(id: 2, name: 'Chicken Pizza', description: 'Grilled chicken, cheese & special sauce', price: 12000, image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop', rating: 4.7, category: 'Pizza'),
  //     FoodItemModel(id: 3, name: 'French Fries', description: 'Crispy golden fries', price: 4000, image: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=400&h=400&fit=crop', rating: 4.0, category: 'Burger'),
  //     FoodItemModel(id: 4, name: 'Grilled Chicken', description: 'Well grilled with spices', price: 10000, image: 'https://images.unsplash.com/photo-1594041680534-e8c8cdebd659?w=400&h=400&fit=crop', rating: 4.3, category: 'Chicken'),
  //     FoodItemModel(id: 5, name: 'Fresh Juice', description: 'Natural & healthy', price: 3000, image: 'https://images.unsplash.com/photo-1622597467836-f3824f29db43?w=400&h=400&fit=crop', rating: 4.1, category: 'Drinks'),
  //   ];
  // }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

Widget _ratingChip(double rating) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(12)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.star, color: Colors.white, size: 12),
      const SizedBox(width: 2),
      Text('${rating.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    ]),
  );
}
/// ==================== FOOD DETAIL ====================
class FoodDetailScreen extends StatefulWidget {
  final Food food;
  const FoodDetailScreen({super.key, required this.food});
  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  String? _selectedVariant;
  final List<String> _selectedExtras = [];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppStateType>(context);
    final food = widget.food;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          backgroundColor: const Color(0xFFE71D36),
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(
              icon: Icon(app.isFoodFavorite(food) ? Icons.favorite : Icons.favorite_border, color: Colors.white),
              onPressed: () => app.toggleFoodFavorite(food),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
            Image.network(food.image!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE71D36))),
          ])),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(food.name!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
                _ratingChip(food.rating!),
              ]),
              const SizedBox(height: 8),
              Text('TZS ${(food.discountPrice ?? food.price)!}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFE71D36))),
              const SizedBox(height: 16),
              Text('Description', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(food.description!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              // if (food.ingredients.isNotEmpty) ...[
              //   const SizedBox(height: 16),
              //   Text('Ingredients', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              //   const SizedBox(height: 6),
              //   Text(food.ingredients!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              // ],
              const SizedBox(height: 16),
              // Row(children: [
              //   const Text('Spice Level: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              //   for (int i = 0; i < 3; i++) Icon(Icons.local_fire_department, color: i < food.spiceLevel ? const Color(0xFFE71D36) : Colors.grey.shade300, size: 20),
              // ]),
              if (food.variants!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Select Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: food.variants!.map((v) => ChoiceChip(
                  label: Text('${v.name} (+${v.priceDelta.toStringAsFixed(0)})'),
                  selected: _selectedVariant == v.name,
                  onSelected: (_) => setState(() => _selectedVariant = v.name),
                  selectedColor: const Color(0xFFE71D36),
                  labelStyle: TextStyle(color: _selectedVariant == v.name ? Colors.white : Colors.black),
                )).toList()),
              ],
              if (food.extras!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Add Extras', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: food.extras!.map((e) => FilterChip(
                  label: Text('${e.name} (+${e.price.toStringAsFixed(0)})'),
                  selected: _selectedExtras.contains(e.name),
                  onSelected: (sel) => setState(() {
                    if (sel) _selectedExtras.add(e.name); else _selectedExtras.remove(e.name);
                  }),
                  selectedColor: const Color(0xFFE71D36),
                  labelStyle: TextStyle(color: _selectedExtras.contains(e.name) ? Colors.white : Colors.black),
                )).toList()),
              ],
              const SizedBox(height: 20),
              Row(children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(children: [
                    IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (_quantity > 1) _quantity--; })),
                    Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _quantity++)),
                  ]),
                ),
                const Spacer(),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // app.addToCart(CartItem(food: food, quantity: _quantity, variant: _selectedVariant, extras: _selectedExtras));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart'), duration: Duration(seconds: 1)));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE71D36), padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}