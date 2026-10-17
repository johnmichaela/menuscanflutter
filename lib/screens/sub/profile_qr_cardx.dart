import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
//  MODEL
// ============================================================
class ProfileQr {
  final String? qrCodeUrl;

  ProfileQr({this.qrCodeUrl});

  factory ProfileQr.fromJson(Map<String, dynamic> j) => ProfileQr(
        qrCodeUrl: j['qr_code_url']?.toString(),
      );

  bool get hasQr => qrCodeUrl != null && qrCodeUrl!.isNotEmpty;
}

// ============================================================
//  SERVICE
// ============================================================
class QrService {
  static const String _base = 'https://qopera.app';

  Future<String?> _token() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('token');
  }

  Future<ProfileQr> generate(int profileId) async {
    final token = await _token();
    final res = await http.post(
      Uri.parse('$_base/prof/qr/$profileId/generate/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) return ProfileQr.fromJson(body);
    throw Exception(body['error'] ?? 'Failed to generate QR');
  }

  Future<void> delete(int profileId) async {
    final token = await _token();
    final res = await http.post(
      Uri.parse('$_base/prof/qr/$profileId/delete/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode >= 400) {
      throw Exception('Failed to delete QR');
    }
  }

  Future<ProfileQr> fetch(int profileId) async {
    final token = await _token();
    final res = await http.get(
      Uri.parse('$_base/prof/api-prof/$profileId'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load profile');
    }
    final data = jsonDecode(res.body);
    return ProfileQr(
      qrCodeUrl: data['qr_code']?.toString() ?? data['qr_code_url']?.toString(),
    );
  }
}

// ============================================================
//  WIDGET
// ============================================================
class ProfileQrCard extends StatefulWidget {
  final int profileId;
  final ProfileQr? initial;

  const ProfileQrCard({
    super.key,
    required this.profileId,
    this.initial,
  });

  @override
  State<ProfileQrCard> createState() => _ProfileQrCardState();
}

class _ProfileQrCardState extends State<ProfileQrCard> {
  final _service = QrService();

  ProfileQr? _qr;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _qr = widget.initial;
    if (_qr == null) _load();
  }

  Future<void> _load() async {
    try {
      final q = await _service.fetch(widget.profileId);
      if (mounted) setState(() => _qr = q);
    } catch (_) {
      // silently ignore
    }
  }

  void _snack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color ?? Colors.black87,
      ),
    );
  }

  // ---------------- GENERATE ----------------
  Future<void> _generate({bool regenerate = false}) async {
    if (regenerate) {
      final ok = await _confirm(
        title: 'Regenerate QR Code?',
        text: 'This will replace your current QR code.',
        confirmText: 'Yes, regenerate!',
        confirmColor: const Color(0xFFF59E0B),
      );
      if (!ok) return;
    }

    setState(() => _busy = true);
    try {
      final fresh = await _service.generate(widget.profileId);
      if (!mounted) return;
      setState(() => _qr = fresh);
      _snack(
        regenerate
            ? 'QR code regenerated successfully'
            : 'QR code generated successfully',
        color: Colors.green,
      );
    } catch (e) {
      _snack('Error: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------------- DELETE ----------------
  Future<void> _delete() async {
    final ok = await _confirm(
      title: 'Delete QR Code?',
      text: 'Your QR code will be permanently removed.',
      confirmText: 'Yes, delete it!',
      confirmColor: const Color(0xFFDC2626),
    );
    if (!ok) return;

    setState(() => _busy = true);
    try {
      await _service.delete(widget.profileId);
      if (!mounted) return;
      setState(() => _qr = ProfileQr());
      _snack('QR code deleted', color: Colors.orange);
    } catch (e) {
      _snack('Error: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------------- DOWNLOAD ----------------
  Future<void> _download() async {
    final url = _qr?.qrCodeUrl;
    if (url == null || url.isEmpty) return;

    setState(() => _busy = true);
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw 'Failed to download (${res.statusCode})';
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/qopera_qr_${widget.profileId}.png');
      await file.writeAsBytes(res.bodyBytes);

      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();

      await Gal.putImage(file.path, album: 'Qopera');

      _snack('QR code saved to gallery', color: Colors.green);
    } catch (e) {
      _snack('Download failed: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String text,
    required String confirmText,
    required Color confirmColor,
  }) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final hasQr = _qr?.hasQr ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header ----
          Row(
            children: [
              Icon(Icons.qr_code_2_rounded, color: primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'QR Code',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              if (_busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ---- Preview ----
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: hasQr ? _qrPreview() : _emptyState(),
            ),
          ),

          const SizedBox(height: 20),

          // ---- Actions ----
          _actionButtons(primary, hasQr),
        ],
      ),
    );
  }

  Widget _qrPreview() {
    return Container(
      key: const ValueKey('qr-preview'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _qr!.qrCodeUrl!,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              width: 200,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: Icon(Icons.broken_image_outlined,
                  size: 40, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      key: const ValueKey('qr-empty'),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_2_outlined,
              size: 48, color: Color(0xFFCBD5E1)),
          SizedBox(height: 10),
          Text(
            'No QR code yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Generate one to share your profile.',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(Color primary, bool hasQr) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (!hasQr)
          _btn(
            label: 'Generate',
            icon: Icons.auto_awesome,
            color: primary,
            onTap: _busy ? null : () => _generate(),
          )
        else ...[
          _btn(
            label: 'Download',
            icon: Icons.download_rounded,
            color: const Color(0xFF16A34A),
            onTap: _busy ? null : _download,
          ),
          _btn(
            label: 'Regenerate',
            icon: Icons.refresh_rounded,
            color: const Color(0xFFF59E0B),
            onTap: _busy ? null : () => _generate(regenerate: true),
          ),
          _btn(
            label: 'Delete',
            icon: Icons.delete_outline_rounded,
            color: const Color(0xFFDC2626),
            onTap: _busy ? null : _delete,
          ),
        ],
      ],
    );
  }

  Widget _btn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: color.withOpacity(0.4),
        disabledForegroundColor: Colors.white70,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
//  USAGE EXAMPLE
// ============================================================
//
// class ProfileScreen extends StatelessWidget {
//   final int profileId;
//   const ProfileScreen({super.key, required this.profileId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // ... hero card, stats, about ...
//             ProfileQrCard(profileId: profileId),
//           ],
//         ),
//       ),
//     );
//   }
// }