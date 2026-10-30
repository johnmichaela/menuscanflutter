import 'package:ballon/widgets/scalloped_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String _selectedPlan = 'vip';
  int _selectedMonths = 1;
  bool _isLoading = false;

  static const String _apiBase = 'http://192.168.1.115:8000';

  // Card input controllers (used for testing; in production, use a secure input form)
  final _cardNumberController = TextEditingController(text: '5531886652142950');
  final _expiryMonthController = TextEditingController(text: '09');
  final _expiryYearController = TextEditingController(text: '32');
  final _cvvController = TextEditingController(text: '564');

String _cardHolderName = 'PAYMENT CARD';

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

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // ========== Initiate Payment ==========
  Future<void> _startCheckout() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _showError('You are not logged in.');
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
          'months': _selectedMonths,
          'card_number': _cardNumberController.text.trim(),
          'expiry_month': _expiryMonthController.text.trim(),
          'expiry_year': _expiryYearController.text.trim(),
          'cvv': _cvvController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);


      if (response.statusCode == 200) {
        final action = data['action'];
        switch (action) {
          case 'redirect':
            _openWebView(data['checkout_url'], data['tx_ref']);
            break;

          case 'requires_pin':
            _showAuthDialog(
              title: 'Enter Card PIN',
              hint: '4-digit PIN',
              chargeId: data['charge_id'],
              endpoint: 'submit-pin/',
              fieldName: 'pin',
            );
            break;

          case 'requires_otp':
            _showAuthDialog(
              title: 'Enter OTP',
              hint: 'OTP sent to your phone',
              chargeId: data['charge_id'],
              endpoint: 'submit-otp/',
              fieldName: 'otp',
            );
            break;

          // ✅ No extra auth needed — payment is already done
          case 'completed':
            _onPaymentSuccess(data['tx_ref']);
            break;

          // ✅ Bank still processing — poll status endpoint
          case 'pending':
            _onPaymentPending(data['tx_ref']);
            break;

          default:
            _showError(data['error'] ?? 'Unexpected response: $action');
        }
      } else {
        _showError(data['error'] ?? 'Failed to start payment.');
      }
      // if (response.statusCode == 200) {
      //   final action = data['action'];
      //   switch (action) {
      //     case 'redirect':
      //       _openWebView(data['checkout_url'], data['tx_ref']);
      //       break;
      //     case 'requires_pin':
      //       _showAuthDialog(
      //         title: 'Enter Card PIN',
      //         hint: '4-digit PIN',
      //         chargeId: data['charge_id'],
      //         endpoint: 'submit-pin/',
      //         fieldName: 'pin',
      //       );
      //       break;
      //     case 'requires_otp':
      //       _showAuthDialog(
      //         title: 'Enter OTP',
      //         hint: 'OTP sent to your phone',
      //         chargeId: data['charge_id'],
      //         endpoint: 'submit-otp/',
      //         fieldName: 'otp',
      //       );
      //       break;
      //     default:
      //       _showError(data['error'] ?? 'Unexpected response: $action');
      //   }
      // } else {
      //   _showError(data['error'] ?? 'Failed to start payment.');
      // }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

void _onPaymentSuccess(String? txRef) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Payment successful! Your plan is now active.'),
      backgroundColor: Colors.green,
    ),
  );
  // Refresh profile / tier info, pop the payment screen, etc.
  Navigator.of(context).pop(true); // `true` = success signal to caller
}

void _onPaymentPending(String? txRef) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Payment is processing…')),
  );
  _pollPaymentStatus(txRef);
}

Future<void> _pollPaymentStatus(String? txRef) async {
  if (txRef == null || txRef.isEmpty) return;

  const maxAttempts = 20; // ~60s at 3s interval
  const interval = Duration(seconds: 3);

  for (var i = 0; i < maxAttempts; i++) {
    await Future.delayed(interval);
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await http.get(
        Uri.parse('http://192.168.1.115:8000/prof/api/payment/status/$txRef/'),
        headers: {
          if (token != null) 'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode != 200) continue;

      final body = json.decode(utf8.decode(res.bodyBytes));
      final status = (body['status'] ?? '').toString().toLowerCase();

      if (status == 'success') {
        _onPaymentSuccess(txRef);
        return;
      }
      if (status == 'failed') {
        _showError('Payment failed. Please try again.');
        return;
      }
      // otherwise keep polling (pending)
    } catch (_) {
      // network hiccup — keep polling
    }
  }

  // Timed out — tell the user to check later
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Still processing. Check your tier again in a few minutes.',
      ),
    ),
  );
}
  // ========== PIN / OTP Input Dialog ==========
  void _showAuthDialog({
    required String title,
    required String hint,
    required String chargeId,
    required String endpoint,
    required String fieldName,
  }) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: fieldName == 'pin',
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _submitAuth(chargeId, endpoint, fieldName, controller.text);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAuth(String chargeId, String endpoint, String fieldName, String value) async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('$_apiBase/prof/api/payment/$endpoint'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'charge_id': chargeId, fieldName: value}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        _showSuccessDialog();
      } else {
        _showError(data['error'] ?? data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ========== WebView (redirect_url scenario) ==========
  void _openWebView(String url, String txRef) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlutterwaveWebView(
          checkoutUrl: url,
          txRef: txRef,
          apiBase: _apiBase,
          onSuccess: () {
            Navigator.pop(context);
            _showSuccessDialog();
          },
          onFailure: (reason) {
            Navigator.pop(context);
            _showError('Payment failed: $reason');
          },
        ),
      ),
    );
  }

  // ========== Dialogs ==========
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
              Navigator.pop(context);
            },
            child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // ========== UI (same as before, with card input fields added) ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios,  size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Payment Method',
          style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan selection
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

            // Duration selection
          const Text(
  'Select Duration',
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
),
const SizedBox(height: 10),
Wrap(
  spacing: 6,        // horizontal gap between chips
  runSpacing: 6,     // vertical gap between rows when wrapped
  children: [1, 3, 6, 12].map((m) {
    return ChoiceChip(
      label: Text('$m Month${m > 1 ? 's' : ''}',),
      selected: _selectedMonths == m,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      
      onSelected: (_) => setState(() => _selectedMonths = m),
      labelStyle: TextStyle(fontSize: 12),
    );
  }).toList(),
),
            const SizedBox(height: 14),

            // // Card input fields (for testing)
             Text('Card Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).cardColor,
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: _cardNumberController,
            //         decoration: const InputDecoration(labelText: 'Card Number'),
            //         keyboardType: TextInputType.number,
            //       ),
            //       const SizedBox(height: 8),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: TextField(
            //               controller: _expiryMonthController,
            //               decoration: const InputDecoration(labelText: 'MM'),
            //               keyboardType: TextInputType.number,
            //             ),
            //           ),
            //           const SizedBox(width: 8),
            //           Expanded(
            //             child: TextField(
            //               controller: _expiryYearController,
            //               decoration: const InputDecoration(labelText: 'YY'),
            //               keyboardType: TextInputType.number,
            //             ),
            //           ),
            //           const SizedBox(width: 8),
            //           Expanded(
            //             child: TextField(
            //               controller: _cvvController,
            //               decoration: const InputDecoration(labelText: 'CVV'),
            //               keyboardType: TextInputType.number,
            //               obscureText: true,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Container(
  // padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(16),
  ),
  child:
  //  Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     const Text(
  //       'Card Details',
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //     ),
  //     const SizedBox(height: 12),

      // ───────────────────────── VIRTUAL CARD ─────────────────────────
      AspectRatio(
        aspectRatio: 1.586, // real credit card ratio
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3A8A), // deep blue
                Color(0xFF2563EB), // brand blue
                Color(0xFF60A5FA), // lighter accent
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles (subtle depth)
              Positioned(
                top: -40,
                right: -40,
                child: _glowCircle(140, Colors.white.withOpacity(0.08)),
              ),
              Positioned(
                bottom: -60,
                left: -30,
                child: _glowCircle(180, Colors.white.withOpacity(0.06)),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── top row: chip + brand ──
                    Row(
                      children: [
                        _chip(),

                        const Spacer(),
                        // Brand logo (swap with Image.asset if you have one)
                        const FaIcon(
                              FontAwesomeIcons.ccVisa,
                              size: 30,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            const FaIcon(
                              FontAwesomeIcons.ccMastercard,
                              size: 30,
                              color: Colors.white,
                            ),

                        // Text(
                        //   'VIRTUAL',
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.85),
                        //     fontWeight: FontWeight.w800,
                        //     letterSpacing: 1.2,
                        //     fontSize: 11,
                        //   ),
                        // ),
                      ],
                    ),

                    const Spacer(),

                    // ── card number ──
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.4,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        hintText: '••••  ••••  ••••  ••••',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 20,
                          letterSpacing: 2.4,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── bottom row: cardholder | expiry | cvv ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Cardholder name (read-only display, can be editable)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CARD HOLDER'),
                              const SizedBox(height: 2),
                              Text(
                                _cardHolderName.isEmpty
                                    ? 'YOUR NAME'
                                    : _cardHolderName.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    _cardHolderName.isEmpty ? 0.4 : 0.95,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Expiry
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('EXPIRES'),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  _whiteField(
                                    controller: _expiryMonthController,
                                    hint: 'MM',
                                    width: 34,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: Text(
                                      '/',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(
                                          0.9,
                                        ),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _whiteField(
                                    controller: _expiryYearController,
                                    hint: 'YY',
                                    width: 34,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // CVV
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CVV'),
                              const SizedBox(height: 2),
                              _whiteField(
                                controller: _cvvController,
                                hint: '•••',
                                width: 44,
                                obscure: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ───────────────────────── END VIRTUAL CARD ─────────────────────────
  //   ],
  // ),
),
            const SizedBox(height: 24),

            // Total and confirm button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Total Payment', style: TextStyle( fontSize: 14)),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)} USD',
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Make pay',
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
Widget _glowCircle(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );

Widget _chip() => Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCD34D), Color(0xFFD97706)],
        ),
      ),
      child: Center(
        child: Container(
          width: 22,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      ),
    );

Widget _label(String text) => Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.65),
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );

Widget _whiteField({
  required TextEditingController controller,
  required String hint,
  required double width,
  bool obscure = false,
}) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: obscure,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 13,
        ),
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
    ),
  );
}
  Widget _buildPlanChip(String id, String label, String price) {
    final isSelected = _selectedPlan == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlan = id),
        child: Column(
          children: [
            ScallopedTierBadges(tierLabel: label),
            SizedBox(height: 8,),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color.fromARGB(31, 224, 224, 224)),
              ),
              child: Column(
                children: [
                  Text(label, style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
                    fontWeight: FontWeight.bold,
                  )),
                  const SizedBox(height: 4),
                  Text(price, style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== WebView (redirect_url scenario only) ==========
class FlutterwaveWebView extends StatefulWidget {
  final String checkoutUrl;
  final String txRef;
  final String apiBase;
  final VoidCallback onSuccess;
  final Function(String) onFailure;

  const FlutterwaveWebView({
    super.key,
    required this.checkoutUrl,
    required this.txRef,
    required this.apiBase,
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
          onNavigationRequest: (NavigationRequest request) async {
            // Intercept custom deep link
            if (request.url.startsWith('qopera://payment-verify/')) {
              setState(() => _isVerifying = true);
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              try {
                final resp = await http.get(
                  Uri.parse('${widget.apiBase}/prof/api/payment/verify/?tx_ref=${widget.txRef}'),
                  headers: {'Authorization': 'Token $token'},
                );
                final data = jsonDecode(resp.body);
                if (data['status'] == 'success') {
                  widget.onSuccess();
                } else {
                  widget.onFailure(data['message'] ?? 'Verification failed');
                }
              } catch (e) {
                widget.onFailure('Verification error: $e');
              }
              return NavigationDecision.prevent;
            }
            if (request.url.contains('payment-failed') || request.url.contains('cancelled')) {
              widget.onFailure('Payment was cancelled.');
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
        title: const Text('Secure Checkout'),
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
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}