// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   String _selectedPlan = 'vip';
//   int _months = 1;
//   bool _isLoading = false;

//   // Your Django API base
//   static const String _apiBase = 'http://192.168.1.115:8000'; // Use ngrok URL for public access

//   Future<void> _startPayment() async {
//     setState(() => _isLoading = true);
    
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     try {
//       final response = await http.post(
//         Uri.parse('$_apiBase/prof/api/payment/initiate/'),
//         headers: {
//           'Authorization': 'Token $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'plan': _selectedPlan, 'months': _months}),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['checkout_url'] != null) {
//         // Open Flutterwave Checkout in a WebView
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => FlutterwaveWebView(
//               checkoutUrl: data['checkout_url'],
//               onSuccess: () {
//                 Navigator.pop(context); // Close WebView
//                 _showSuccessDialog();
//               },
//               onFailure: () {
//                 Navigator.pop(context);
//                 _showError('Payment failed or cancelled.');
//               },
//             ),
//           ),
//         );
//       } else {
//         _showError(data['error'] ?? 'Failed to start payment');
//       }
//     } catch (e) {
//       _showError('Connection error: $e');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Payment Successful! 🎉'),
//         content: Text('Your $_selectedPlan subscription is now active for $_months month(s).'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               Navigator.pop(context); // Go back to previous screen
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upgrade Plan')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Choose your plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
            
//             // Plan Selector (Radio Buttons)
//             _buildPlanTile('vip', 'VIP Plan', '\$10 / month'),
//             _buildPlanTile('vvp', 'VVP Plan', '\$25 / month'),
//             _buildPlanTile('ads', 'Ads Boost', '\$5 / month'),
            
//             const SizedBox(height: 30),
//             const Text('Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             const SizedBox(height: 10),
//             Row(
//               children: [1, 3, 6].map((m) => Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: ChoiceChip(
//                   label: Text('$m Month${m > 1 ? 's' : ''}'),
//                   selected: _months == m,
//                   onSelected: (_) => setState(() => _months = m),
//                 ),
//               )).toList(),
//             ),
            
//             const Spacer(),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _startPayment,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2563EB),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Pay Now', style: TextStyle(fontSize: 16, color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanTile(String value, String title, String subtitle) {
//     return RadioListTile<String>(
//       title: Text(title),
//       subtitle: Text(subtitle),
//       value: value,
//       groupValue: _selectedPlan,
//       onChanged: (v) => setState(() => _selectedPlan = v!),
//       activeColor: const Color(0xFF2563EB),
//     );
//   }
// }

// // ==========================================
// // WEBVIEW TO HANDLE FLUTTERWAVE CHECKOUT
// // ==========================================
// class FlutterwaveWebView extends StatefulWidget {
//   final String checkoutUrl;
//   final VoidCallback onSuccess;
//   final VoidCallback onFailure;

//   const FlutterwaveWebView({
//     super.key,
//     required this.checkoutUrl,
//     required this.onSuccess,
//     required this.onFailure,
//   });

//   @override
//   State<FlutterwaveWebView> createState() => _FlutterwaveWebViewState();
// }

// class _FlutterwaveWebViewState extends State<FlutterwaveWebView> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (NavigationRequest request) {
//             // Detect when Flutterwave redirects to your verify URL
//             if (request.url.contains('/prof/api/payment/verify/')) {
//               // The WebView is about to load your Django verify URL.
//               // We can close the WebView now. The Django view will handle activation.
//               widget.onSuccess();
//               return NavigationDecision.prevent;
//             }
//             // If Flutterwave redirects to a failure URL
//             if (request.url.contains('payment-failed')) {
//               widget.onFailure();
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.checkoutUrl));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Secure Checkout')),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// ==========================================
// MODEL FOR DEMO ITEMS (Matches Image 1)
// ==========================================
class CartItem {
  final String name;
  final String subtitle;
  final double price;
  int quantity;
  final IconData icon;

  CartItem({
    required this.name,
    required this.subtitle,
    required this.price,
    this.quantity = 1,
    required this.icon,
  });
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // App State
  int _currentStep = 0; // 0: Cart, 1: Payment Method, 2: Processing/WebView
  String _selectedPlan = 'vip';
  int _months = 1;
  bool _isLoading = false;
  
  // Cart State (Demo data matching the image)
  final List<CartItem> _cartItems = [
    CartItem(name: 'VIP Subscription', subtitle: 'Premium features', price: 10.00, icon: Icons.star),
    CartItem(name: 'VVP Subscription', subtitle: 'Exclusive access', price: 25.00, icon: Icons.diamond),
  ];
  
  // Selected Payment Method UI state
  String _selectedMethod = 'flutterwave';

  static const String _apiBase = 'http://192.168.1.115:8000'; // Use ngrok URL

  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get _total => _subtotal;

  // ==========================================
  // API LOGIC
  // ==========================================
  Future<void> _startFlutterwaveCheckout() async {
    setState(() {
      _isLoading = true;
      _currentStep = 2; // Move to "Processing" view
    });
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('$_apiBase/prof/api/payment/initiate/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'plan': _selectedPlan, 'months': _months}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['checkout_url'] != null) {
        if (!mounted) return;
        
        // Open Flutterwave Checkout WebView
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlutterwaveWebView(
              checkoutUrl: data['checkout_url'],
              onSuccess: () {
                Navigator.pop(context); // Close WebView
                _showSuccessDialog();
                setState(() => _currentStep = 1); // Reset step
              },
              onFailure: () {
                Navigator.pop(context);
                _showError('Payment failed or cancelled.');
                setState(() => _currentStep = 1); // Reset step
              },
            ),
          ),
        );
      } else {
        _showError(data['error'] ?? 'Failed to start payment');
        setState(() => _currentStep = 1);
      }
    } catch (e) {
      _showError('Connection error: $e');
      setState(() => _currentStep = 1);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Payment Successful'),
          ],
        ),
        content: Text('Your $_selectedPlan subscription is now active for $_months month(s).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // ==========================================
  // BUILD METHODS
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep == 0 
            ? null 
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => setState(() => _currentStep--),
              ),
        title: Text(
          _currentStep == 0 ? 'Shopping Bag' : 'Payment Method',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentStep == 0 
            ? _buildCartStep() 
            : _currentStep == 1 
                ? _buildPaymentStep() 
                : _buildProcessingStep(),
      ),
    );
  }

  // --- STEP 1: CART SUMMARY ---
  Widget _buildCartStep() {
    return Column(
      key: const ValueKey('cart'),
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(item.subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          const SizedBox(height: 8),
                          Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () => setState(() { if (item.quantity > 1) item.quantity--; }),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () => setState(() => item.quantity++),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomSummary(
          buttonText: 'Proceed To Checkout',
          onPressed: () => setState(() => _currentStep = 1),
        ),
      ],
    );
  }

  // --- STEP 2: PAYMENT METHOD ---
  Widget _buildPaymentStep() {
    return Column(
      key: const ValueKey('payment'),
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Address Section
              const Text('Shipping to', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('1400 Cider Lane, Petaling\nCA 941, Malaysia', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('Change')),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const Text('Add Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              
              // Payment Method Selection
              Row(
                children: [
                  _buildPaymentIcon(Icons.credit_card, 'Card / Mobile Money', 'flutterwave'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Plan Selector (for VIP/VVP/ADS)
              const Text('Select Plan Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [1, 3, 6].map((m) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text('$m Month${m > 1 ? 's' : ''}'),
                    selected: _months == m,
                    onSelected: (_) => setState(() => _months = m),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        _buildBottomSummary(
          buttonText: 'Confirm Order',
          onPressed: _startFlutterwaveCheckout,
        ),
      ],
    );
  }

  // --- STEP 3: PROCESSING / WEBVIEW LOADER ---
  Widget _buildProcessingStep() {
    return const Center(
      key: ValueKey('processing'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF2563EB)),
          SizedBox(height: 20),
          Text('Securely connecting to payment gateway...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildPaymentIcon(IconData icon, String label, String value) {
    final isSelected = _selectedMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
            boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10)] : [],
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(
                fontSize: 12, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary({required String buttonText, required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Payment', style: TextStyle(color: Colors.grey)),
              Text('\$${_total.toStringAsFixed(2)} USD', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E), // Dark button like image
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(buttonText, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// WEBVIEW TO HANDLE FLUTTERWAVE CHECKOUT
// ==========================================
class FlutterwaveWebView extends StatefulWidget {
  final String checkoutUrl;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  const FlutterwaveWebView({
    super.key,
    required this.checkoutUrl,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<FlutterwaveWebView> createState() => _FlutterwaveWebViewState();
}

class _FlutterwaveWebViewState extends State<FlutterwaveWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Detect when Flutterwave redirects to your verify URL
            if (request.url.contains('/prof/api/payment/verify/')) {
              widget.onSuccess();
              return NavigationDecision.prevent;
            }
            // If Flutterwave redirects to a failure URL
            if (request.url.contains('payment-failed') || request.url.contains('cancelled')) {
              widget.onFailure();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}