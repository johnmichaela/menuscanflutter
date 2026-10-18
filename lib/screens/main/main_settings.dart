import 'dart:convert';
// import 'package:ballon/auth_screens.dart';
import 'package:ballon/screens/sub/ThemeSettingsPage.dart';
import 'package:ballon/screens/sub/about.dart';
import 'package:ballon/screens/sub/event/show_event.dart';
import 'package:ballon/screens/sub/event/venue_list_screen.dart';
import 'package:ballon/screens/sub/language_settings_page.dart';
import 'package:ballon/screens/sub/menu/add_menu.dart';
import 'package:ballon/screens/sub/post/add_post.dart';
import 'package:ballon/screens/sub/profile/changepassword.dart';
import 'package:ballon/screens/sub/profile/editbusiness.dart';
import 'package:ballon/screens/sub/profile/edit.dart';
import 'package:ballon/screens/sub/profile/showme.dart';
import 'package:ballon/screens/sub/profile_qr_card.dart';
import 'package:ballon/screens/sub/subscription_screen.dart';
import 'package:ballon/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/screens/auth/login_screen.dart';
import 'package:ballon/screens/auth/signup_screen.dart';
import 'package:ballon/l10n/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

// --- MAIN SETTINGS PAGE ---
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String? _userAvatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadAllProfileData();
  }

  int? profid;
  String? profileName = '';
  String? profileEmail = '';
  String? profilePhone = '';
  String? profilePlace = '';
  String? profileBio = '';
  String? profilePicture = '';
  String? profileUsername = '';
  bool? profileIsVisible = false;

  bool isLoading = true;

  // ==================== GET TOKEN ====================
  // Future<String?> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = prefs.getString('token');
  //   });
  //   return token;
  // }

  // ==================== GET PROFILE ID ====================
  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profid = prefs.getInt('profid');
    });
    return profid;
  }

  // ==================== GET PROFILE NAME ====================
  Future<String?> _getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('profile_name');
    });
    print(profileName!);
    return profileName;
  }

  // ==================== GET PROFILE EMAIL ====================
  Future<String?> _getProfileEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileEmail = prefs.getString('profile_email');
    });
    print(profileEmail);
    return profileEmail;
  }

  // ==================== GET PROFILE PHONE ====================
  Future<String?> _getProfilePhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhone = prefs.getString('profile_phone');
    });
    return profilePhone;
  }

  // ==================== GET PROFILE PLACE ====================
  Future<String?> _getProfilePlace() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePlace = prefs.getString('profile_place');
    });
    return profilePlace;
  }

  // ==================== GET PROFILE BIO ====================
  Future<String?> _getProfileBio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileBio = prefs.getString('profile_bio');
    });
    return profileBio;
  }

  // ==================== GET PROFILE PICTURE ====================
  Future<String?> _getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePicture = prefs.getString('profile_picture');
    });
    return profilePicture;
  }

  // ==================== GET PROFILE USERNAME ====================
  Future<String?> _getProfileUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileUsername = prefs.getString('profile_username');
    });
    return profileUsername;
  }
   Future<bool?> _getProfileIsVisible() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileIsVisible = prefs.getBool('profile_is_visible');
      print('   - is_visible: $profileIsVisible');
    });
    return profileIsVisible;
  }

  // ==================== LOAD ALL PROFILE DATA ====================
  Future<void> _loadAllProfileData() async {
    setState(() {
      isLoading = true;
    });

    await _getProfileId();
    await _getProfileName();
    await _getProfileEmail();
    await _getProfilePhone();
    await _getProfilePlace();
    await _getProfileBio();
    await _getProfilePicture();
    await _getProfileUsername();
    await _getProfileIsVisible();

    setState(() {
      isLoading = false;
    });
  }

  // ==================== REFRESH ALL DATA ====================
  Future<void> _refreshAllData() async {
    await _loadAllProfileData();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
      print('Login status: $_isLoggedIn');
      _isLoading = false;
    });

    if (_isLoggedIn) {
      await _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('https://qopera.app/prof/api-prof/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['name'] ?? data['username'] ?? 'User';
          _userEmail = data['email'] ?? '';
          _userAvatar = data['avatar'] ?? data['profile_picture'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    setState(() {
      _isLoggedIn = false;
      _userName = '';
      _userEmail = '';
      _userAvatar = null;

    });

    // Show logout success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login or home
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = context.watch<ThemeController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   title: Text(
      //     context.tr.settings,
      //     style: TextStyle(
      //       color: Theme.of(context).textTheme.titleMedium?.color,
      //     ),
      //   ),
      //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //   elevation: 0,
      //   iconTheme: Theme.of(context).iconTheme,
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // --- PROFILE SECTION ---
                if (_isLoggedIn) ...[
                  _buildProfileHeader(),
                  const Divider(color: Colors.grey, height: 1),
                ],

                // --- ACCOUNT SECTION ---
                _buildSectionTitle(context.tr.account),
                if (_isLoggedIn) ...[
                  _buildSettingTile(
                    icon: Icons.person,
                    title: context.tr.editProfile,
                    subtitle: context.tr.updatePersonalInfo,
                    onTap: () => _navigateToEditProfile(context),
                  ),
                  _buildSettingTile(
                    icon: Icons.lock,
                    title: context.tr.changePassword,
                    subtitle: context.tr.updateYourPassword,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    ),
                  ),
                 if (profileIsVisible==true)...[
                  _buildSettingTile(
                    icon: Icons.storefront_outlined,
                    title: context.tr.editProfileBusiness,
                    subtitle: context.tr.editProfileBusinessSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileBusinessScreen(),
                      ),
                    ),
                  ),
                    _buildSettingTile(
                    icon: Icons.location_on_outlined,
                    title:  context.tr.addVenue,
                    subtitle: context.tr.addVenueSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>VenueListScreen()),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.event_outlined,
                    title: context.tr.addEvents,
                    subtitle: context.tr.addEventsSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventListScreen()),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.shopping_bag_outlined,
                    title: context.tr.addProductsServices,
                    subtitle: context.tr.addProductsServicesSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MenuPage()),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.article_outlined,
                    title: context.tr.addPosts,
                    subtitle: context.tr.addPostsSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddPostScreen()),
                    ),
                  ),
                   _buildSettingTile(
                    icon: Icons.qr_code,
                    title: context.tr.qrCode,
                    subtitle: context.tr.qrCodeSub,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileQrCard(profileId: profid!,)),
                    ),
                  ),
                //   const Divider(color: Colors.grey, height: 1),
                //    // --- Payment SECTION ---
                // _buildSectionTitle('Payment'),
                // _buildSettingTile(
                //   icon: Icons.payment,
                //   title: 'Payment Settings',
                //   subtitle: 'Manage your subscription and payment methods',
                //   onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => SubscriptionScreen()),
                //   ),
                 
                // ),
                ]
                ] else ...[
                  _buildSettingTile(
                    icon: Icons.login,
                    title: context.tr.login,
                    subtitle: context.tr.signInToYourAccount,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.person_add,
                    title: context.tr.register,
                    subtitle: context.tr.createNewAccount,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    ),
                  ),
                ],

                const Divider(color: Colors.grey, height: 1),

                // --- PREFERENCES SECTION ---
                _buildSectionTitle(context.tr.preferences),
                _buildSettingTile(
                  icon: Icons.language,
                  title: context.tr.language,
                  subtitle: context.tr.english,
                  onTap: () => _navigateToLanguageSettings(context),
                  trailing: Text(
                    Localizations.localeOf(context).languageCode.toUpperCase(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // _buildSettingTile(
                //   icon: Icons.notifications,
                //   title: context.tr.notifications,
                //   subtitle: context.tr.pushNotifications,
                //   onTap: () => _navigateToNotificationSettings(context),
                // ),
                _buildSettingTile(
                  icon: themeCtrl.mode.isDark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  title: context.tr.theme,
                  subtitle: context.tr.darkMode,
                  onTap: () => _navigateToThemeSettings(context),
                ),

                const Divider(color: Colors.grey, height: 1),

                // --- SUPPORT SECTION ---
                _buildSectionTitle(context.tr.support),
                _buildSettingTile(
                  icon: Icons.help,
                  title: context.tr.helpSupport,
                  subtitle: context.tr.getHelpWithMenuScan,
                  onTap: () => _navigateToHelp(context),
                ),
                _buildSettingTile(
                  icon: Icons.feedback,
                  title: context.tr.sendFeedback,
                  subtitle: context.tr.helpUsImprove,
                  onTap: () => _navigateToFeedback(context),
                ),
                _buildSettingTile(
                  icon: Icons.info,
                  title: context.tr.about,
                  subtitle: 'Version 1.0.0',
                  onTap: () => _navigateToAbout(context),
                ),

                const Divider(color: Colors.grey, height: 1),

                // --- DANGER ZONE ---
                if (_isLoggedIn) ...[
                  _buildSectionTitle(context.tr.accountManagement),
                  _buildSettingTile(
                    icon: Icons.logout,
                    title: context.tr.logout,
                    subtitle: context.tr.signOutOfYourAccount,
                    onTap: _showLogoutDialog,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                  ),
                  _buildSettingTile(
                    icon: Icons.delete_forever,
                    title: context.tr.deleteAccount,
                    subtitle: context.tr.permanentlyDeleteYourAccount,
                    onTap: _showDeleteAccountDialog,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
    );
  }

  // --- PROFILE HEADER WIDGET ---
  Widget _buildProfileHeader() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileShowScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 38,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage:
                    profilePicture != null && profilePicture!.isNotEmpty
                    ? NetworkImage(profilePicture!)
                    : null,
                child: profilePicture == null && profilePicture!.isEmpty
                    ? Text(
                        profileName!.isNotEmpty
                            ? profileName![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileName ?? "User",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileEmail ?? "Email",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _navigateToEditProfile(context),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECTION TITLE WIDGET ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- SETTING TILE WIDGET ---
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: 12,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 16,
          ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // --- NAVIGATION METHODS ---
  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    ).then((_) => _fetchUserProfile()); // Refresh when returning
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  void _navigateToEmailSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailSettingsPage()),
    );
  }

  void _navigateToLanguageSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LanguageSettingsPage()),
    );
  }

  void _navigateToNotificationSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
    );
  }

  void _navigateToThemeSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThemeSettingsPage()),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpPage()),
    );
  }

  void _navigateToFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  // --- DIALOGS ---
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(context.tr.logout, style: TextStyle(color: Colors.white)),
        content: Text(
          context.tr.areYouSureYouWantToLogout,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text(context.tr.logout, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(
          context.tr.deleteAccount,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          context.tr.thisActionCannotBeUndone,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: Text(context.tr.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return;

      final response = await http.post(
        Uri.parse('https://qopera.app/prof/api/user/delete'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );
      print("response status ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        await prefs.remove('auth_token');
        setState(() {
          _isLoggedIn = false;
          _userName = '';
          _userEmail = '';
          _userAvatar = null;
        });
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}

// --- EDIT PROFILE PAGE ---
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse('https://qopera.app/prof/api/user/profile/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nameController.text = data['name'] ?? data['username'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() => _isSaving = false);
        return;
      }

      final response = await http.put(
        Uri.parse('https://qopera.app/prof/api/profile/update/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          context.tr.editProfile,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: Text(
              _isSaving ? context.tr.saving : context.tr.save,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: const Color(0xFF1C1C1E),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: context.tr.fullName,
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1C1C1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr.pleaseEnterYourName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: context.tr.email,
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1C1C1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr.pleaseEnterYourEmail;
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: context.tr.phoneNumber,
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1C1C1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

// --- CHANGE PASSWORD PAGE ---
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.post(
        Uri.parse('https://qopera.app/prof/api/user/change-password/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'current_password': _currentPasswordController.text,
          'new_password': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Password',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// --- OTHER SETTINGS PAGES (Placeholders) ---
class EmailSettingsPage extends StatelessWidget {
  const EmailSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Email Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'Email Settings Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class LanguageSettingsPagex extends StatelessWidget {
  const LanguageSettingsPagex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Language', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('English', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.check, color: Colors.blue),
          ),
          ListTile(
            title: Text('Spanish', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('French', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Arabic', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text(
                'Push Notifications',
                style: TextStyle(color: Colors.white),
              ),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text(
                'Email Notifications',
                style: TextStyle(color: Colors.white),
              ),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text(
                'Order Updates',
                style: TextStyle(color: Colors.white),
              ),
              value: false,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingsPagex extends StatelessWidget {
  const ThemeSettingsPagex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Theme', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.check, color: Colors.blue),
          ),
          ListTile(
            title: const Text('Light', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: const Text(
              'System Default',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.tr.helpSupport),
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.titleMedium?.color),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ---------- Intro Card ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.primaryColor.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr.howCanWeHelpYou,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr.findQuickAnswers,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ---------- Section: FAQ ----------
          _SectionHeader(title: context.tr.frequentlyAskedQuestions),
          const SizedBox(height: 8),

          _FaqItem(
            question: context.tr.faqHowDoIScanAMenu,
            answer: context.tr.faqHowDoIScanAMenuAnswer,
          ),
          _FaqItem(
            question: context.tr.faqDoINeedAccount,
            answer: context.tr.faqDoINeedAccountAnswer,
          ),
          _FaqItem(
            question: context.tr.faqWhyNoMenuLoading,
            answer: context.tr.faqWhyNoMenuLoadingAnswer,
          ),
          _FaqItem(
            question: context.tr.faqSaveFavorite,
            answer: context.tr.faqSaveFavoriteAnswer,
          ),
          _FaqItem(
            question: context.tr.faqIsDataSafe,
            answer: context.tr.faqIsDataSafeAnswer,
          ),

          const SizedBox(height: 24),

          // ---------- Section: Contact ----------
          _SectionHeader(title: context.tr.contactSupport),
          const SizedBox(height: 8),

          _HelpTile(
            icon: Icons.mail_outline,
            title: context.tr.emailSupport,
            subtitle: context.tr.emailSupportSubtitle,
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'support@example.com',
              );

              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                // Fallback: show a snackbar or copy to clipboard
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email app')),
                  );
                }
              }
            },
          ),
          _HelpTile(
            icon: Icons.bug_report_outlined,
            title: context.tr.reportProblem,
            subtitle: context.tr.reportProblemSubtitle,
            onTap: () {
              // TODO: navigate to feedback page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          _HelpTile(
            icon: Icons.lightbulb_outline,
            title: context.tr.suggestFeature,
            subtitle: context.tr.suggestFeatureSubtitle,
            onTap: () {
              // TODO: navigate to feedback page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          _HelpTile(
            icon: Icons.star_outline,
            title: context.tr.rateApp,
            subtitle: context.tr.rateAppSubtitle,
            onTap: () async {
              final Uri storeUri = Uri.parse(
                'https://play.google.com/store/apps/details?id=com.example.yourapp',
              );

              if (await canLaunchUrl(storeUri)) {
                await launchUrl(storeUri, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open store')),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 24),

          // ---------- Footer ----------
          Center(
            child: Text(
              'MenuScan v1.0.0  •  Made with MenuScan',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Reusable widgets ----------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        // remove default divider lines
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: theme.primaryColor,
          collapsedIconColor: theme.colorScheme.onSurfaceVariant,
          title: Text(
            question,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.15),
          child: Icon(icon, color: theme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  // post https://qopera.app/prof/api/send-feedback
  void sendFeedback(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // if (token == null) return;
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
    final response = await http.post(
      Uri.parse('https://qopera.app/prof/api/send-feedback'),

      headers: headers,
      body: jsonEncode({'message': message}),
    );
    print('Feedback response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr.feedbackSentThanks),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr.failedToSendFeedback),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token;
      // You can use the token here if needed
    });
    print('Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.tr.sendFeedback),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.tr.helpUsImprove,

                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr.yourFeedbackShapes,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr.greatReportIncludes,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _TipLine(text: context.tr.tipWhatYouWereDoing),
                    _TipLine(text: context.tr.tipWhatYouExpected),
                    _TipLine(text: context.tr.tipWhatActuallyHappened),
                    _TipLine(text: context.tr.tipIdeasForImproving),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _feedbackController,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: context.tr.shareYourFeedback,
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _token != null && _token!.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          final message = _feedbackController.text.trim();
                          if (message.isNotEmpty) {
                            sendFeedback(message);
                            _feedbackController.clear();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr.pleaseEnterFeedback),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          context.tr.submitFeedback,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          context.tr.loginToSendFeedback,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}

// Small bullet helper
class _TipLine extends StatelessWidget {
  final String text;
  const _TipLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: color, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class AboutPagex extends StatelessWidget {
  const AboutPagex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Ballon',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Food Delivery App',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Made with ❤️ for food lovers',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
