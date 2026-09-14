import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  static const String _apiBase = 'https://192.168.1.115';

  Future<void> _submit() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      _showSnack('New passwords do not match', isError: true);
      return;
    }
    if (_newCtrl.text.length < 8) {
      _showSnack('Password must be at least 8 characters', isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _showSnack('Not authenticated', isError: true);
        return;
      }

      final response = await http.post(
        Uri.parse('$_apiBase/prof/api/user/change-password/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': _oldCtrl.text,
          'new_password': _newCtrl.text,
          'confirm_password': _confirmCtrl.text,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // If your API returns a new token, update it
        if (body['token'] != null) {
          await prefs.setString('token', body['token']);
        }
        _showSnack('Password changed successfully', isError: false);
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        final detail = body['detail'];
        final message = detail is List ? detail.join('\n') : detail.toString();
        _showSnack(message, isError: true);
      }
    } catch (e) {
      debugPrint('Change password error: $e');
      _showSnack('Connection error. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(context.tr.changePassword)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildField(
                label:  context.tr.currentPassword,
                controller: _oldCtrl,
                obscure: !_showOld,
                onToggle: () => setState(() => _showOld = !_showOld),
              ),
              const SizedBox(height: 16),
              _buildField(
                label:  context.tr.newPassword,
                controller: _newCtrl,
                obscure: !_showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
              ),
              const SizedBox(height: 16),
              _buildField(
                label: context.tr.confirmNewPassword,
                controller: _confirmCtrl,
                obscure: !_showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                   style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF087CFF),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: const Color(0xFF087CFF).withOpacity(.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(context.tr.updatePassword, style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
}