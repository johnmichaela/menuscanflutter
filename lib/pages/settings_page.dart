import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/payment_methods_page.dart';
import '../pages/notification_settings_page.dart';
import '../pages/help_support_page.dart';
import '../pages/about_us_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ==================== SETTINGS STATE ====================
  
  bool _darkMode = false;
  bool _locationEnabled = true;
  bool _dataSavingMode = false;
  String _language = 'English';
  String _currency = 'TZS';
  String _unitSystem = 'Metric';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _locationEnabled = prefs.getBool('location_enabled') ?? true;
      _dataSavingMode = prefs.getBool('data_saving_mode') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _currency = prefs.getString('currency') ?? 'TZS';
      _unitSystem = prefs.getString('unit_system') ?? 'Metric';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setBool('location_enabled', _locationEnabled);
    await prefs.setBool('data_saving_mode', _dataSavingMode);
    await prefs.setString('language', _language);
    await prefs.setString('currency', _currency);
    await prefs.setString('unit_system', _unitSystem);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', '🇬🇧'),
              _buildLanguageOption('Swahili', '🇹🇿'),
              _buildLanguageOption('French', '🇫🇷'),
              _buildLanguageOption('Spanish', '🇪🇸'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String flag) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(language),
      trailing: _language == language
          ? const Icon(Icons.check, color: Color(0xFFB71C1C))
          : null,
      onTap: () {
        setState(() {
          _language = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Select Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrencyOption('TZS', 'TSh'),
              _buildCurrencyOption('USD', '\$'),
              _buildCurrencyOption('EUR', '€'),
              _buildCurrencyOption('GBP', '£'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyOption(String currency, String symbol) {
    return ListTile(
      leading: Text(symbol, style: const TextStyle(fontSize: 20)),
      title: Text(currency),
      trailing: _currency == currency
          ? const Icon(Icons.check, color: Color(0xFFB71C1C))
          : null,
      onTap: () {
        setState(() {
          _currency = currency;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==================== GENERAL SETTINGS ====================
            _buildSectionCard(
              title: 'General',
              icon: Icons.settings,
              children: [
                // Dark Mode
                _buildSwitchTile(
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme for the app',
                  value: _darkMode,
                  icon: Icons.dark_mode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
                _buildDivider(),
                
                // Language
                _buildSettingsTile(
                  title: 'Language',
                  subtitle: _language,
                  icon: Icons.language,
                  onTap: _showLanguageDialog,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                _buildDivider(),
                
                // Currency
                _buildSettingsTile(
                  title: 'Currency',
                  subtitle: _currency,
                  icon: Icons.attach_money,
                  onTap: _showCurrencyDialog,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // ==================== APP SETTINGS ====================
            _buildSectionCard(
              title: 'App Settings',
              icon: Icons.app_settings_alt,
              children: [
                // Location
                _buildSwitchTile(
                  title: 'Location Services',
                  subtitle: 'Allow app to access your location',
                  value: _locationEnabled,
                  icon: Icons.location_on,
                  onChanged: (value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                ),
                _buildDivider(),
                
                // Data Saving Mode
                _buildSwitchTile(
                  title: 'Data Saving Mode',
                  subtitle: 'Reduce data usage by loading lower quality images',
                  value: _dataSavingMode,
                  icon: Icons.data_saver_off,
                  onChanged: (value) {
                    setState(() {
                      _dataSavingMode = value;
                    });
                  },
                ),
                _buildDivider(),
                
                // Unit System
                _buildSettingsTile(
                  title: 'Unit System',
                  subtitle: _unitSystem,
                  icon: Icons.straighten,
                  onTap: () {
                    setState(() {
                      _unitSystem = _unitSystem == 'Metric' ? 'Imperial' : 'Metric';
                    });
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // ==================== ACCOUNT SETTINGS ====================
            _buildSectionCard(
              title: 'Account',
              icon: Icons.person,
              children: [
                _buildSettingsTile(
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  icon: Icons.edit,
                  onTap: () {
                    // Navigate to edit profile
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                _buildDivider(),
                
                _buildSettingsTile(
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  icon: Icons.lock,
                  onTap: () {
                    // Navigate to change password
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                _buildDivider(),
                
                _buildSettingsTile(
                  title: 'Privacy & Security',
                  subtitle: 'Manage your privacy settings',
                  icon: Icons.security,
                  onTap: () {
                    // Navigate to privacy settings
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // ==================== SUPPORT ====================
            _buildSectionCard(
              title: 'Support',
              icon: Icons.support_agent,
              children: [
                _buildSettingsTile(
                  title: 'Help & Support',
                  subtitle: 'Get help with your account',
                  icon: Icons.help_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportPage(),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                _buildDivider(),
                
                _buildSettingsTile(
                  title: 'About Us',
                  subtitle: 'Learn more about Balloon',
                  icon: Icons.info_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsPage(),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
                _buildDivider(),
                
                _buildSettingsTile(
                  title: 'Rate Us',
                  subtitle: 'Rate Balloon on the app store',
                  icon: Icons.star_outline,
                  onTap: () {
                    // Open app store rating
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // ==================== SAVE BUTTON ====================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save All Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // ==================== LOGOUT BUTTON ====================
            GestureDetector(
              onTap: _showLogoutDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION CARD ====================
  
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFB71C1C), size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  // ==================== SETTINGS TILE ====================
  
  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFB71C1C), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // ==================== SWITCH TILE ====================
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      //  Container(
      //   padding: const EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: Colors.grey.shade100,
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   child: Icon(icon, color: const Color(0xFFB71C1C), size: 20),
      // ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFB71C1C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
    );
  }

  // ==================== DIVIDER ====================
  
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // ==================== LOGOUT DIALOG ====================
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You will need to login again to access your account.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logoutUser(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutUser(BuildContext context) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Logging out...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
      }
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}