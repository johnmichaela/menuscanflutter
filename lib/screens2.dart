import 'package:ballon/login.dart';
import 'package:ballon/screens/sub/profile/show.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';
import 'models.dart';
import 'widgets.dart';
import 'screens.dart';

/// ==================== CART SCREEN ====================
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: app.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : Column(
              children: [
                if (app.currentRestaurant != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Icon(Icons.storefront, color: const Color(0xFFE71D36)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(app.currentRestaurant!.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        if (app.currentTable != null)
                          Text('Table ${app.currentTable!.name}', style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: app.cartItems.length,
                    itemBuilder: (context, i) => _cartItem(context, app.cartItems[i], app),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Subtotal', app.subtotal),
                      _summaryRow('Tax (18%)', app.tax),
                      _summaryRow('Service Charge (5%)', app.serviceCharge),
                      const Divider(height: 20),
                      _summaryRow('Total', app.total, bold: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE71D36), padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _cartItem(BuildContext context, CartItem item, AppState app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.food.image!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey.shade200),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name!, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (item.variant != null) Text(item.variant!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                if (item.extras.isNotEmpty) Text(item.extras.join(', '), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 4),
                Text('${item.food.currency} ${item.unitPrice.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _qtyBtn(Icons.remove, () => app.updateQuantity(item, -1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  _qtyBtn(Icons.add, () => app.updateQuantity(item, 1)),
                ],
              ),
              const SizedBox(height: 6),
              Text('${item.food.currency} ${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFFE71D36).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16, color: const Color(0xFFE71D36)),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? Colors.black : Colors.grey.shade600,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'TZS ${value.toStringAsFixed(0)}',
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500, fontSize: bold ? 18 : 14),
          ),
        ],
      ),
    );
  }
}

/// ==================== CHECKOUT SCREEN ====================
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _payment = 'cash';
  String _orderType = 'dine_in';

  final List<String> _payments = ['cash', 'M-Pesa', 'Airtel Money', 'Tigo Pesa', 'Stripe', 'PayPal', 'Card'];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black, centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Customer Information', [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(), hintText: 'Your name')),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(), hintText: '+255...'),
              keyboardType: TextInputType.phone,
            ),
          ]),
          const SizedBox(height: 16),
          _section('Order Type', [
            Wrap(spacing: 8, children: [
              _typeChip('dine_in', 'Dine In'),
              _typeChip('pickup', 'Pickup'),
              _typeChip('delivery', 'Delivery'),
            ]),
          ]),
          const SizedBox(height: 16),
          if (_orderType == 'dine_in' && app.currentTable != null)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.table_restaurant, color: Color(0xFFE71D36)),
                  const SizedBox(width: 10),
                  Text('Ordering for Table ${app.currentTable!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          _section('Payment Method', [
            Column(
              children: _payments.map((p) => RadioListTile<String>(
                value: p,
                groupValue: _payment,
                onChanged: (v) => setState(() => _payment = v!),
                title: Text(p, style: const TextStyle(fontSize: 14)),
                dense: true,
                activeColor: const Color(0xFFE71D36),
              )).toList(),
            ),
          ]),
          const SizedBox(height: 16),
          _section('Order Notes', [
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notes for the restaurant', border: OutlineInputBorder(), hintText: 'e.g. No onions, extra spicy...'),
              maxLines: 3,
            ),
          ]),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                _sumRow('Subtotal', app.subtotal),
                _sumRow('Tax (18%)', app.tax),
                _sumRow('Service Charge (5%)', app.serviceCharge),
                const Divider(height: 20),
                _sumRow('Total', app.total, bold: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _placeOrder(context, app),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE71D36), padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _typeChip(String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _orderType == value,
      onSelected: (_) => setState(() => _orderType = value),
      selectedColor: const Color(0xFFE71D36),
      labelStyle: TextStyle(color: _orderType == value ? Colors.white : Colors.black),
    );
  }

  Widget _sumRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(
            'TZS ${value.toStringAsFixed(0)}',
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500, fontSize: bold ? 18 : 14),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, AppState app) {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }
    // Would call ApiService.createOrder here.
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    app.clearCart();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderNumber: orderNumber)));
  }
}

/// ==================== ORDER TRACKING ====================
class OrderTrackingScreen extends StatelessWidget {
  final String orderNumber;
  const OrderTrackingScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    final steps = [
      OrderStatus(status: 'Order Received', time: 'Just now', isCompleted: true),
      OrderStatus(status: 'Preparing', time: 'In progress', isCompleted: true),
      OrderStatus(status: 'Cooking', time: 'Pending', isCompleted: false),
      OrderStatus(status: 'Ready', time: 'Pending', isCompleted: false),
      OrderStatus(status: 'Served', time: 'Pending', isCompleted: false),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2ecc71), size: 70),
                const SizedBox(height: 12),
                Text('Order $orderNumber', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Your order is being prepared', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Estimated: 15-20 min', style: TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                for (int i = 0; i < steps.length; i++) _timelineItem(steps[i], isLast: i == steps.length - 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(OrderStatus step, {required bool isLast}) {
    final Color circleColor = step.isCompleted ? const Color(0xFF2ecc71) : Colors.grey.shade300;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
              child: step.isCompleted ? const Icon(Icons.check, color: Color(0xFFFFFFFF), size: 14) : null,
            ),
            if (!isLast) Container(width: 2, height: 40, color: circleColor),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
padding: EdgeInsets.only(top: 2, bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.status,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: step.isCompleted ? Colors.black : Colors.grey),
                ),
                Text(step.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ==================== ORDERS SCREEN ====================
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleOrders = [
      {'id': 'ORD-1234', 'restaurant': 'ABC Restaurant', 'items': '2 items', 'total': 'TZS 16,000', 'status': 'Preparing', 'time': 'Today'},
      {'id': 'ORD-1233', 'restaurant': 'Balloon Bistro', 'items': '1 item', 'total': 'TZS 8,000', 'status': 'Completed', 'time': 'Yesterday'},
      {'id': 'ORD-1232', 'restaurant': 'Chicken Palace', 'items': '3 items', 'total': 'TZS 24,000', 'status': 'Completed', 'time': '2 days ago'},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('My Orders'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleOrders.length,
        itemBuilder: (context, i) {
          final o = sampleOrders[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(o['id']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(o['time']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(o['restaurant']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${o['items']} · ${o['total']}', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFE71D36).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(o['status']!, style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderNumber: o['id']!))),
                      child: const Text('Track Order', style: TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ==================== FAVORITES SCREEN ====================
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('Favorites'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
body: app.recentScans.isEmpty && app.favoriteFoods.isEmpty && app.favoriteRestaurants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No favorites yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    'Scan a restaurant QR code to see it here as a recent scan',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (app.recentScans.isNotEmpty) ...[
                  const Text('Recently Scanned', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...app.recentScans.map((r) => ListTile(
                    leading: CircleAvatar(backgroundImage: r.banner!.isNotEmpty ? NetworkImage(r.banner!) : null, child: r.banner!.isEmpty ? const Icon(Icons.restaurant) : null),
                    title: Text(r.name!),
                    subtitle: Text(r.place!),
                    trailing: const Icon(Icons.qr_code_scanner, color: Color(0xFFE71D36)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: Colors.white,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r)),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],
                if (app.favoriteRestaurants.isNotEmpty) ...[
                  const Text('Saved Restaurants', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...app.favoriteRestaurants.map((r) => ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(r.banner!)),
                    title: Text(r.name!),
                    subtitle: Text(r.place!),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Color(0xFFE71D36)),
                      onPressed: () => app.toggleRestaurantFavorite(r),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r)),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],
                if (app.favoriteFoods.isNotEmpty) ...[
                  const Text('Saved Dishes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...app.favoriteFoods.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FoodCard(
                        food: f,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(food: f))),
                        onAdd: () => app.toggleFoodFavorite(f),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

/// ==================== PROFILE SCREEN ====================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Position? _position;
  bool _locating = false;
  String? token='';
 @override
  void initState() {
    super.initState();
    getPref();
     _loadAllProfileData();
    _getToken();
    // _loadAllProfileData();
  }
var _loginStatus = 0;
  int? profid;
  String? profileName='';
  String? profileEmail='';
  String? profilePhone='';
  String? profilePlace='';
  String? profileBio='';
  String? profilePicture='';
  String? profileUsername='';
  
  bool isLoading = true;



  // ==================== GET TOKEN ====================
  // Future<String?> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //   });
  //   return token;
  // }

  // ==================== GET PROFILE ID ====================
  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profid = prefs.getInt('profid');
    });
    return profid;
  }

  // ==================== GET PROFILE NAME ====================
  Future<String?> _getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('profile_name');
    });
    print(profileName!);
    return profileName;
  }

  // ==================== GET PROFILE EMAIL ====================
  Future<String?> _getProfileEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileEmail = prefs.getString('profile_email');
    });
    print(profileEmail);
    return profileEmail;
  }

  // ==================== GET PROFILE PHONE ====================
  Future<String?> _getProfilePhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhone = prefs.getString('profile_phone');
    });
    return profilePhone;
  }

  // ==================== GET PROFILE PLACE ====================
  Future<String?> _getProfilePlace() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePlace = prefs.getString('profile_place');
    });
    return profilePlace;
  }

  // ==================== GET PROFILE BIO ====================
  Future<String?> _getProfileBio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileBio = prefs.getString('profile_bio');
    });
    return profileBio;
  }

  // ==================== GET PROFILE PICTURE ====================
  Future<String?> _getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePicture = prefs.getString('profile_picture');
    });
    return profilePicture;
  }

  // ==================== GET PROFILE USERNAME ====================
  Future<String?> _getProfileUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileUsername = prefs.getString('profile_username');
    });
    return profileUsername;
  }

  // ==================== LOAD ALL PROFILE DATA ====================
  Future<void> _loadAllProfileData() async {
    setState(() {
      isLoading = true;
    });

    await _getToken();
    await _getProfileId();
    await _getProfileName();
    await _getProfileEmail();
    await _getProfilePhone();
    await _getProfilePlace();
    await _getProfileBio();
    await _getProfilePicture();
    await _getProfileUsername();

    setState(() {
      isLoading = false;
    });
  }

  // ==================== REFRESH ALL DATA ====================
  Future<void> _refreshAllData() async {
    await _loadAllProfileData();
  }
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("value")!;
    });
    return _loginStatus;
  }

  Future<void> _getLocation() async {
    setState(() => _locating = true);
    try {
bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _toast(context, 'Location services are disabled');
        setState(() => _locating = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _toast(context, 'Location permission denied');
        setState(() => _locating = false);
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _position = position);
    } catch (_) {
      _toast(context, 'Could not get your location');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token');
    });
   
    return token;
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final nearbyOffers = app.offersNearby(_position?.latitude, _position?.longitude);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _profileHeader(context, app),
            const SizedBox(height: 20),
            // Available Offers section
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text('Available Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_run, color: Color(0xFFE71D36), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _position == null ? 'Get offers near your area' : 'Offers near you',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: _locating ? null : _getLocation,
                        child: _locating
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(_position == null ? 'Use My Location' : 'Refresh'),
                      ),
                    ],
                  ),
                  if (nearbyOffers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _position == null
                            ? 'Tap "Use My Location" to see offers available near you.'
                            : 'No offers available near your area right now.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    )
                  else
                    ...nearbyOffers.map((o) => _offerTile(context, o, app)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _menuTile(context, Icons.receipt_long, 'My Orders', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
            _menuTile(context, Icons.location_on_outlined, 'My Addresses', () => _toast(context, 'Addresses')),
            _menuTile(context, Icons.payment, 'Payment Methods', () => _toast(context, 'Payment Methods')),
            _menuTile(
              context,
              Icons.language,
              'Language',
              () => _toast(context, 'Language'),
              trailing: Text('English', style: TextStyle(color: Colors.grey.shade600)),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: app.isDark,
              onChanged: (_) => app.toggleDark(),
            ),
            _menuTile(context, Icons.help_outline, 'Help & Support', () => _toast(context, 'Support')),
            if (app.isLoggedIn)
              _menuTile(context, Icons.logout, 'Logout', () => app.logout(), color: const Color(0xFFE71D36)),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, AppState app) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE71D36), Color(0xFFa3152a)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
         profilePicture == null && profilePicture!.isEmpty?
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.person, color: Color(0xFFE71D36), size: 34),
          ):CircleAvatar(
            radius: 43,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 40,
              foregroundImage: NetworkImage(profilePicture!),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profileName ??app.username, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  app.isLoggedIn ? 'Signed in as ${app.role}' : 'Sign in to sync your orders',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          token!.isEmpty?
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Login', style: TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
            ): TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileShowScreen())),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Show', style: TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold)),
            )
        ],
      ),
    );
  }

  Widget _offerTile(BuildContext context, Offer offer, AppState app) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE71D36).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE71D36), borderRadius: BorderRadius.circular(12)),
            child: Text(
              '${offer.discount.toStringAsFixed(0)}%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(offer.restaurantName, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Text(offer.code, style: const TextStyle(color: Color(0xFFE71D36), fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {Widget? trailing, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.grey.shade700),
        title: Text(title, style: TextStyle(color: color)),
        trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
