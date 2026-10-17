
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';

// ============================================================
//  CONFIG
// ============================================================
class ApiConfig {
  static const String base = 'https://qopera.app';

  /// Turn a possibly-relative media path into a full URL.
  static String absolute(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) return '$base$path';
    return '$base/$path';
  }
}

// ============================================================
//  MODEL
// ============================================================
class ProfileQr {
  final String? qrCodeUrl; // always a FULL url
  final String? shareCode;

  ProfileQr({this.qrCodeUrl, this.shareCode});

  factory ProfileQr.fromJson(Map<String, dynamic> j) {
    final raw = j['qr_code_url'] ?? j['qr_code'];
    return ProfileQr(
      qrCodeUrl: raw == null ? null : ApiConfig.absolute(raw.toString()),
      shareCode: j['share_code']?.toString(),
    );
  }

  bool get hasQr => qrCodeUrl != null && qrCodeUrl!.isNotEmpty;
}

// ============================================================
//  SERVICE
// ============================================================
class QrService {
  static const String _base = ApiConfig.base;

  Future<String?> _token() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('token');
  }

  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await _token();
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Token $token',
      'Accept': 'application/json',
      if (json) 'Content-Type': 'application/json',
    };
  }

  /// POST /prof/profile/<id>/qr/generate   (no trailing slash)
  Future<ProfileQr> generate(int profileId) async {
    final uri = Uri.parse('$_base/prof/profile/$profileId/qr/generate');
    debugPrint('QR generate → $uri');

    final res = await http
        .post(uri, headers: await _headers(json: true), body: jsonEncode({}))
        .timeout(const Duration(seconds: 20));

    debugPrint('QR generate ← ${res.statusCode} :: ${res.body}');

    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (_) {
      throw Exception('Server returned non-JSON (${res.statusCode})');
    }

    if (res.statusCode == 200 && body is Map) {
      return ProfileQr.fromJson(Map<String, dynamic>.from(body));
    }
    throw Exception(
      (body is Map ? body['error'] : null) ??
          'Failed to generate QR (${res.statusCode})',
    );
  }

  /// POST /prof/profile/<id>/qr/delete   (no trailing slash)
  Future<void> delete(int profileId) async {
    final uri = Uri.parse('$_base/prof/profile/$profileId/qr/delete');
    debugPrint('QR delete → $uri');

    final res = await http
        .post(uri, headers: await _headers(json: true), body: jsonEncode({}))
        .timeout(const Duration(seconds: 20));

    debugPrint('QR delete ← ${res.statusCode} :: ${res.body}');

    if (res.statusCode >= 400) {
      String msg = 'Failed to delete QR';
      try {
        final b = jsonDecode(res.body);
        if (b is Map && b['error'] != null) msg = b['error'].toString();
      } catch (_) {}
      throw Exception(msg);
    }
  }

  /// GET /prof/api-prof/<id>
  Future<ProfileQr> fetch(int profileId) async {
    final uri = Uri.parse('$_base/prof/api-prof/$profileId');
    debugPrint('Profile fetch → $uri');

    final res = await http
        .get(uri, headers: await _headers())
        .timeout(const Duration(seconds: 20));

    debugPrint('Profile fetch ← ${res.statusCode} :: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Failed to load profile (${res.statusCode})');
    }

    final data = jsonDecode(res.body);

    Map<String, dynamic> map;
    if (data is List && data.isNotEmpty) {
      map = Map<String, dynamic>.from(data.first);
    } else if (data is Map) {
      map = Map<String, dynamic>.from(data);
    } else {
      return ProfileQr();
    }

    final raw = map['qr_code'] ?? map['qr_code_url'];
    return ProfileQr(
      qrCodeUrl: raw == null ? null : ApiConfig.absolute(raw.toString()),
      shareCode: map['share_code']?.toString(),
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
  DateTime _createdAt = DateTime.now();
  final int _sizePx = 512;

  @override
  void initState() {
    super.initState();
    _qr = widget.initial;
    _load();
  }

  Future<void> _load() async {
    try {
      final q = await _service.fetch(widget.profileId);
      if (!mounted) return;
      if (q.hasQr || (_qr?.hasQr ?? false) == false) {
        setState(() => _qr = q);
      }
    } catch (e) {
      debugPrint('Fetch QR error: $e');
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
        title: context.tr.regenerateQrTitle,
        text:  context.tr.regenerateQrConfirm,
        confirmText: context.tr.yesRegenerate,
        confirmColor: const Color(0xFFF59E0B),
      );
      if (!ok) return;
    }

    setState(() => _busy = true);
    try {
      final fresh = await _service.generate(widget.profileId);
      if (!mounted) return;
      setState(() {
        _qr = fresh;
        _createdAt = DateTime.now();
      });
      _snack(
        regenerate
            ?  context.tr.qrRegeneratedSuccess
            :  context.tr.qrGeneratedSuccess,
        color: Colors.green,
      );
    } catch (e, st) {
      debugPrint('QR generation error: $e');
      debugPrint('Stack trace: $st');
      _snack('Error: $e', color: Colors.red);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------------- DELETE ----------------
  Future<void> _delete() async {
    final ok = await _confirm(
      title:  context.tr.deleteQrTitle,
      text: context.tr.deleteQrConfirm,
      confirmText: context.tr.yesDelete,
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
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
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
            child:  Text(context.tr.cancel),
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

  // ============================================================
  //  BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final hasQr = _qr?.hasQr ?? false;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  Text(
           context.tr.qrCode,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _qrCard( hasQr),
                const SizedBox(height: 16),
                _detailsCard(hasQr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- MAIN QR CARD ----------------
  Widget _qrCard(bool hasQr) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF1D6FE8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.qrCode,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // 'Scan this code to access the information'+ 
                      context.tr.scanToViewMenu,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (_busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: hasQr ? _qrPreview() : _emptyState(),
            ),
          ),
          const SizedBox(height: 16),

          if (_qr?.shareCode != null && _qr!.shareCode!.isNotEmpty) ...[
            Center(
              child: Text(
                'Code: ${_qr!.shareCode}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textTheme.bodySmall?.color,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          _actionButtons(hasQr),
        ],
      ),
    );
  }

  Widget _qrPreview() {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('qr-preview'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 171, 171, 172),
          width: 1.4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _qr!.qrCodeUrl!,
          width: 220,
          height: 220,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              width: 220,
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 220,
            height: 220,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('qr-empty'),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 171, 171, 172),
        ),
      ),
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_2_outlined, size: 56, color: Color(0xFFCBD5E1)),
          SizedBox(height: 10),
          Text(
            context.tr.noQrYet,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
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

  // ---------------- ACTION BUTTONS ----------------
  Widget _actionButtons(bool hasQr) {
    if (!hasQr) {
      return SizedBox(
        width: double.infinity,
        child: _bigButton(
          label:  context.tr.generate,
          icon: Icons.qr_code_2_rounded,
          color: const Color(0xFF1D6FE8),
          onTap: _busy ? null : () => _generate(),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _bigButton(
            label: context.tr.download,
            icon: Icons.download_rounded,
            color: const Color(0xFF16A34A),
            onTap: _busy ? null : _download,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _bigButton(
            label:  context.tr.regenerate,
            icon: Icons.refresh_rounded,
            color: const Color(0xFFF59E0B),
            onTap: _busy ? null : () => _generate(regenerate: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _bigButton(
            label:  context.tr.delete,
            icon: Icons.delete_outline_rounded,
            color: const Color(0xFFEF4444),
            onTap: _busy ? null : _delete,
          ),
        ),
      ],
    );
  }

  Widget _bigButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: onTap == null ? color.withOpacity(0.5) : color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- DETAILS CARD ----------------
  Widget _detailsCard(bool hasQr) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF1D6FE8),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text( context.tr.qrCodeDetails,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _detailRow(
            icon: Icons.link_rounded,
            label:context.tr.typeLabel,
            value: hasQr ? 'Short Code' : '—',
          ),
          const Divider(height: 20, color: Color.fromARGB(255, 199, 200, 201)),
          _detailRow(
            icon: Icons.calendar_today_outlined,
            label:  context.tr.create,
            value: hasQr ? _fmt(_createdAt) : '—',
          ),
          const Divider(height: 20, color: Color.fromARGB(255, 199, 200, 201)),
          _detailRow(
            icon: Icons.photo_size_select_large_outlined,
            label:  context.tr.sizeLabel,
            value: '$_sizePx x $_sizePx px',
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------
  String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final min = d.minute.toString().padLeft(2, '0');
    return '${months[d.month - 1]} ${d.day}, ${d.year} • $h:$min $ampm';
  }
}