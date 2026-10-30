import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // --- State for Selection ---
  String _selectedPlan = 'vip'; // 'vip', 'vvp', or 'ads'
  int _selectedMonths = 1;
  String _selectedMethod = 'card'; 
  bool _isLoading = false;

  // Replace with your actual Django API URL (use ngrok for testing on physical devices)
  static const String _apiBase = 'http://192.168.1.115:8000'; 

  // --- Dynamic Pricing Logic ---
  double get _basePrice {
    switch (_selectedPlan) {
      case 'vip': return 10.00;
      case 'vvp': return 25.00;
      case 'ads': return 5.00;
      default: return 0.00;
    }
  }

  double get _totalPrice => _basePrice * _selectedMonths;

  String get _planLabel {
    switch (_selectedPlan) {
      case 'vip': return 'VIP Subscription';
      case 'vvp': return 'VVP Subscription';
      case 'ads': return 'Ads Boost';
      default: return '';
    }
  }

  // ==========================================
  // API LOGIC (Connects to Django)
  // ==========================================
  Future<void> _startFlutterwaveCheckout() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ensure your app saves the auth token as 'token'

    if (token == null) {
      _showError('You are not logged in. Please log in again.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiBase/prof/api/payment/initiate/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'plan': _selectedPlan, 
          'months': _selectedMonths
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['checkout_url'] != null) {
        if (!mounted) return;
        
        // Open Flutterwave Secure Checkout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlutterwaveWebView(
              checkoutUrl: data['checkout_url'],
              onSuccess: () {
                Navigator.pop(context); // Close WebView
                _showSuccessDialog();
              },
              onFailure: (String reason) {
                Navigator.pop(context);
                _showError('Payment failed: $reason');
              },
            ),
          ),
        );
      } else {
        _showError(data['error'] ?? 'Failed to start payment. Try again.');
      }
    } catch (e) {
      _showError('Network error: Please check your connection.');
      debugPrint('Payment Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ==========================================
  // UI DIALOGS
  // ==========================================
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
        content: Text('Your $_planLabel is now active for $_selectedMonths month(s).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Return to previous screen
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
  // MAIN UI BUILD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Plan Selection ---
            const Text('Select Plan Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlanChip('vip', 'VIP', '\$10/mo'),
                _buildPlanChip('vvp', 'VVP', '\$25/mo'),
                _buildPlanChip('ads', 'Ads Boost', '\$5/mo'),
              ],
            ),
            
            const SizedBox(height: 20),

            // --- 2. Duration Selection ---
            const Text('Select Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              children: [1, 3, 6, 12].map((m) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('$m Month${m > 1 ? 's' : ''}'),
                  selected: _selectedMonths == m,
                  selectedColor: const Color(0xFF2563EB).withOpacity(0.2),
                  onSelected: (_) => setState(() => _selectedMonths = m),
                ),
              )).toList(),
            ),

            const SizedBox(height: 24),

            // --- 3. Shipping To (Matched to Image) ---
            const Text('Shipping to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text(
                        '1470 Cider Lane, Petaling\nCA 948, Australia',
                        style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 4. Payment Method Icons ---
            const Text('Add Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentIcon('card', Icons.credit_card, Colors.orange),
                _buildPaymentIcon('paypal', Icons.paypal, Colors.blue),
                _buildPaymentIcon('apple', Icons.apple, Colors.black),
                _buildPaymentIcon('google', Icons.g_mobiledata, Colors.red),
              ],
            ),

            const SizedBox(height: 24),

            // --- 5. Credit Card Graphic ---
            _buildCreditCardWidget(),

            const SizedBox(height: 24),

            // --- 6. Total & Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Payment', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)} USD',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startFlutterwaveCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E1E), // Dark button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24, 
                        height: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Confirm Order',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildPlanChip(String id, String label, String price) {
    final isSelected = _selectedPlan == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlan = id),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300),
            boxShadow: isSelected 
                ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            children: [
              Text(
                label, 
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black, 
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 4),
              Text(
                price, 
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey, 
                  fontSize: 12
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String id, IconData icon, Color color) {
    final isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        width: 60,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 8)]
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Center(child: Icon(icon, color: color, size: 28)),
      ),
    );
  }

  Widget _buildCreditCardWidget() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF121212), 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Credit Card', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('VISA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, fontStyle: FontStyle.italic)),
            ],
          ),
          // Chip Graphic
          Container(
            width: 40, height: 30,
            decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(6)),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              padding: const EdgeInsets.all(4),
              itemCount: 6,
              itemBuilder: (context, index) => Container(color: Colors.grey.shade400),
            ),
          ),
          // Numbers
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('4315', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text('0245448', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text('00345', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
          // Name & Mastercard logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MAHMUDUR RAHMAN', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              Row(
                children: [
                  Container(width: 20, height: 20, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.8))),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

// ==========================================
// SECURE FLUTTERWAVE WEBVIEW
// ==========================================
class FlutterwaveWebView extends StatefulWidget {
  final String checkoutUrl;
  final VoidCallback onSuccess;
  final Function(String) onFailure;

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
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // 1. Check for Django Success Redirect (Custom Deep Link)
            if (request.url.startsWith('qopera://payment-verify/')) {
              // Extract tx_ref from URL if you want to call a verification endpoint here
              // final uri = Uri.parse(request.url);
              // final txRef = uri.queryParameters['tx_ref'];
              
              widget.onSuccess();
              return NavigationDecision.prevent;
            }
            
            // 2. Check for Failure/Cancel
            if (request.url.contains('payment-failed') || request.url.contains('cancelled')) {
              widget.onFailure('Payment was cancelled.');
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
             // Optional: show loading indicator if needed
          },
          onPageFinished: (url) {
             // Optional: hide loading indicator
          }
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isVerifying)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}