import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({Key? key}) : super(key: key);

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  bool _isLoggedIn = false;
  bool _isDeleting = false;
  String _userName = '';
  String _userEmail = '';
  String? _userAvatar;

  // ==================== DELETE ACCOUNT DIALOG ====================
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'This action cannot be undone. Are you sure you want to delete your account permanently?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ==================== DELETE ACCOUNT API ====================
  Future<void> _deleteAccount() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        _showSnackBar('You are not logged in.');
        setState(() => _isDeleting = false);
        return;
      }

      final response = await http.delete(
        Uri.parse('https://qopera.app/prof/api/user/delete/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success — clear everything
        await prefs.remove('auth_token');
        await prefs.remove('user_id');
        await prefs.remove('user_name');
        await prefs.remove('user_email');

        if (!mounted) return;
        setState(() {
          _isLoggedIn = false;
          _userName = '';
          _userEmail = '';
          _userAvatar = null;
          _isDeleting = false;
        });

        _showSnackBar(
          'Your account has been deleted.',
          color: Colors.green,
        );

        // Navigate to home/login
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        // Handle API error
        final body = jsonDecode(response.body);
        final message = body['detail'] ?? 'Failed to delete account.';
        _showSnackBar(message, color: Colors.red);
        setState(() => _isDeleting = false);
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      _showSnackBar(
        'Something went wrong. Please try again.',
        color: Colors.red,
      );
      setState(() => _isDeleting = false);
    }
  }

  // ==================== SNACKBAR HELPER ====================
  void _showSnackBar(String message, {Color color = Colors.black}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: _isDeleting
            ? const CircularProgressIndicator(color: Colors.red)
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: _showDeleteAccountDialog,
                child: const Text(
                  'Delete My Account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
      ),
    );
  }
}