import 'package:ballon/screens/main/main_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ballon/theme_controller.dart';
import 'package:ballon/screens/auth/login_screen.dart';
import 'package:ballon/screens/auth/signup_screen.dart';
import 'package:ballon/screens/sub/ThemeSettingsPage.dart';
import 'package:ballon/screens/sub/about.dart';
import 'package:ballon/screens/sub/language_settings_page.dart';
import 'package:ballon/screens/sub/profile/changepassword.dart';
import 'package:ballon/screens/sub/profile/edit.dart';
import 'package:ballon/screens/sub/profile/showme.dart';
import 'package:ballon/l10n/app_strings.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback? onLogout;
  const AppDrawer({super.key, this.onLogout});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _userName = 'Guest';
  String _userEmail = 'Tap to login';
  String? _userAvatar;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ================= LOAD USER FROM PREF =================
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final loggedIn = token != null && token.isNotEmpty;

    setState(() {
      _isLoggedIn = loggedIn;
      _userName = prefs.getString('profile_name') ?? 'Guest';
      _userEmail = prefs.getString('profile_email') ?? 'Tap to login';
      _userAvatar = prefs.getString('profile_picture');
      _isLoading = false;
    });

    if (loggedIn) _refreshFromApi(token!);
  }

  Future<void> _refreshFromApi(String token) async {
    try {
      final res = await http.get(
        Uri.parse('http://192.168.1.115:8000 /prof/api-prof/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (!mounted) return;
        setState(() {
          _userName = data['name'] ?? data['username'] ?? _userName;
          _userEmail = data['email'] ?? _userEmail;
          _userAvatar = data['avatar'] ?? data['profile_picture'] ?? _userAvatar;
        });
      }
    } catch (_) {/* silent */}
  }

  // ================= LOGOUT =================
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(context.tr.logout),
        content: Text(context.tr.signOutOfYourAccount),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.tr.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.tr.logout,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('profid');
    await prefs.remove('profile_name');
    await prefs.remove('profile_email');
    await prefs.remove('profile_picture');

    if (!mounted) return;
    Navigator.pop(context); // close drawer
    widget.onLogout?.call();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // ================= NAVIGATION HELPERS =================
  void _go(Widget page) {
    Navigator.pop(context); // close drawer first
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = context.watch<ThemeController>();
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final primary = theme.primaryColor;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= HEADER (USER CARD) =================
            _buildHeader(textColor, primary),

            Divider(color: Colors.grey.shade300, height: 1),

            // ================= MAIN MENU =================
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                 
                  // ================= ACCOUNT (if logged in) =================
                  if (_isLoggedIn) ...[
                    _drawerItem(
                      context,
                      Icons.person_outline,
                      context.tr.profile ?? 'Profile',
                      () => _go(const ProfileShowScreen()),
                    ),
                    _drawerItem(
                      context,
                      Icons.edit_outlined,
                      context.tr.editProfile ?? 'Edit Profile',
                      () => _go(const EditProfileScreen()),
                    ),
                    _drawerItem(
                      context,
                      Icons.lock_outline,
                      context.tr.changePassword ?? 'Change Password',
                      () => _go(const ChangePasswordScreen()),
                    ),
                  ] else ...[
                    _drawerItem(
                      context,
                      Icons.login,
                      context.tr.login ?? 'Login',
                      () => _go(const LoginScreen()),
                    ),
                    _drawerItem(
                      context,
                      Icons.person_add,
                      context.tr.register ?? 'Register',
                      () => _go(const SignupScreen()),
                    ),
                  ],

                  Divider(color: Colors.grey.shade300, height: 1),

                  // ================= PREFERENCES =================
                  _drawerItem(
                    context,
                    Icons.settings_outlined,
                    context.tr.settings ?? 'Settings',
                    ()=>_go(SettingsPage()),
                  ),
                  _drawerItem(
                    context,
                    Icons.language,
                    context.tr.language ?? 'Language',
                    () => _go(const LanguageSettingsPage()),
                    trailing: Text(
                      Localizations.localeOf(context)
                          .languageCode
                          .toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  _drawerItem(
                    context,
                    themeCtrl.mode.isDark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    context.tr.theme ?? 'Theme',
                    () => _go(const ThemeSettingsPage()),
                    trailing: Text(
                      themeCtrl.mode.isDark ? 'Dark' : 'Light',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  _drawerItem(
                    context,
                    Icons.info_outline,
                    context.tr.about ?? 'About',
                    () => _go(const AboutPage()),
                  ),
                ],
              ),
            ),

            // ================= LOGOUT (bottom) =================
            if (_isLoggedIn) ...[
              Divider(color: Colors.grey.shade300, height: 1),
              _drawerItem(
                context,
                Icons.logout,
                context.tr.logout ?? 'Logout',
                _handleLogout,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
            ] else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ================= HEADER WIDGET =================
  Widget _buildHeader(Color textColor, Color primary) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (_isLoggedIn) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfileShowScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Row(
          children: [
            // ---- Avatar ----
            CircleAvatar(
              radius: 28,
              backgroundColor: primary.withOpacity(0.15),
              backgroundImage: (_userAvatar != null && _userAvatar!.isNotEmpty)
                  ? NetworkImage(_userAvatar!)
                  : null,
              child: (_userAvatar == null || _userAvatar!.isEmpty)
                  ? Text(
                      _userName.isNotEmpty
                          ? _userName[0].toUpperCase()
                          : 'G',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // ---- Name + Email ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _userEmail,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ---- Edit icon (only if logged in) ----
            if (_isLoggedIn)
              Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ================= DRAWER ITEM =================
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final textColor = color ??
        theme.textTheme.bodyMedium?.color ??
        Colors.black;

    return ListTile(
      leading: Icon(icon, color: textColor, size: 22),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 14.5),
      ),
      trailing: trailing ??
          Icon(Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      dense: true,
    );
  }
}