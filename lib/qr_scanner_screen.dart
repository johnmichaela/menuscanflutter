import 'dart:async';
import 'package:ballon/models/resturants.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'models.dart';
import 'screens.dart';
import 'services/api_service.dart';

/// Real QR scanner screen.
///
/// When a QR code is detected, it is expected to contain ONLY a short code
/// (e.g. ``A1B2C3D4``) that the restaurant's QR encodes. The app then calls
/// GET /api/menu-by-code/<code>/ to resolve that code to the restaurant menu.
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isHandled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Extract the short menu code from a scanned value.
  ///
  /// The QR code contains only the code (e.g. ``A1B2C3D4``). For robustness we
  /// also handle a full URL deep link (e.g. ``https://host/menu/<slug>``) by
  /// taking the last path segment, so both styles keep working.
  String? _extractCode(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.host.isNotEmpty) {
      final segs = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segs.isNotEmpty && segs.first == 'menu') {
        if (segs.length >= 2) return segs[1];
        return null;
      }
      // Fall back to the last non-empty segment if the URL is not /menu/...
      if (segs.isNotEmpty) return segs.last;
    }

    // Plain code: strip non-alphanumeric characters and return it.
    final code = trimmed.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    return code.isEmpty ? null : code;
  }

  Future<void> _handleBarcode(String rawValue) async {
    if (_isHandled) return;

    final code = _extractCode(rawValue);
    if (code == null) {
      _showMessage('Invalid QR code. Please scan a restaurant menu QR.');
      return;
    }

    _isHandled = true;
    _showLoading();

    try {
      final data = await ApiService.getMenuByCode(code);
      if (!mounted) return;
      final restaurant = Result.fromJson(data);
      // Record this scan so it appears in the Saved tab's "Recently Scanned".
      Provider.of<AppState>(context, listen: false).addRecentScan(restaurant);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: restaurant)),
      );
    } catch (e) {
      _isHandled = false;
      if (!mounted) return;
      Navigator.pop(context); // close loading dialog
      _showMessage('Could not load menu. Please make sure the backend is running.');
      setState(() {});
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading menu...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final raw = barcode.rawValue;
                if (raw != null && raw.isNotEmpty) {
                  _handleBarcode(raw);
                  break;
                }
              }
            },
          ),
          // Scan frame overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Point camera at the QR code on the table',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
const SizedBox(height: 16),
                //   ElevatedButton.icon(
                //     onPressed: () => _handleBarcode(
                //       // For testing without a physical QR: demo short code
                //       // Must match a profile's share_code in the back backend.
                //       'c3fb0619',
                //     ),
                //   icon: const Icon(Icons.qr_code_scanner),
                //   label: const Text('Simulate Scan',),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Theme.of(context).primaryColor,
                   
                //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
