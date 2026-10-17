import 'package:ballon/event.dart';
import 'package:ballon/pages/help_support_page.dart';
import 'package:ballon/pages/settings_page.dart';
import 'package:ballon/profile.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/screens/sub/screens.dart';
// Import your screens
// import 'package:ballon/profile_screen.dart';
// import 'package:ballon/settings_screen.dart';
// import 'package:ballon/login_screen.dart';

class SidebarWidget extends StatefulWidget {
  final VoidCallback? onLogout;
  final Function(String)? onNavigate;
  final int? selectedIndex;

  const SidebarWidget({
    Key? key,
    this.onLogout,
    this.onNavigate,
    this.selectedIndex,
  }) : super(key: key);

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  // ==================== PROFILE VARIABLES ====================
  String? token;
  int? profid;
  String? profileName;
  String? profileEmail;
  String? profilePhone;
  String? profilePlace;
  String? profileBio;
  String? profilePicture;
  String? profileUsername;
  
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _loadAllProfileData();
  }

  // ==================== GET TOKEN ====================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    return token;
  }

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
    return profileName;
  }

  // ==================== GET PROFILE EMAIL ====================
  Future<String?> _getProfileEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileEmail = prefs.getString('profile_email');
    });
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

  // ==================== LOAD ALL PROFILE DATA ====================
  Future<void> _loadAllProfileData() async {
    setState(() {
      isLoading = true;
    });

    await _getToken();
    await _getProfileId();
    await _getProfileName();
    await _getProfileEmail();
    await _getProfilePhone();
    await _getProfilePlace();
    await _getProfileBio();
    await _getProfilePicture();
    await _getProfileUsername();

    setState(() {
      isLoading = false;
    });
  }

  // ==================== REFRESH ALL DATA ====================
  Future<void> _refreshAllData() async {
    await _loadAllProfileData();
  }

  // ==================== NAVIGATION HELPER ====================
  void _navigateTo(String route) {
    Navigator.pop(context);
    if (widget.onNavigate != null) {
      widget.onNavigate!(route);
    }
  }

  // ==================== LOGOUT ====================
  Future<void> _logout() async {
    // Show loading dialog
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
      
      // Call logout API if needed
      final String? token = prefs.getString('token');
      if (token != null) {
        // await http.post(
        //   Uri.parse('https://qopera.app/api/logout/'),
        //   headers: {'Authorization': 'Bearer $token'},
        // );
      }

      // Clear all data
      await prefs.clear();

      // Dismiss loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Call logout callback
      if (widget.onLogout != null) {
        widget.onLogout!();
      }

      // Navigate to login
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      // Dismiss loading dialog
      if (context.mounted) {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==================== SHOW LOGOUT DIALOG ====================
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
                _logout();
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

  // ==================== BUILD SIDEBAR ====================
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ==================== HEADER WITH PROFILE DATA ====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC62828),
                  Color(0xFFE53935),
                ],
              ),
            ),
            child: Column(
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: () {
                    _navigateTo('profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: isLoading
                          ? null
                          : (profilePicture != null && profilePicture!.isNotEmpty
                              ? NetworkImage(profilePicture!)
                              : const NetworkImage(
                                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
                                )),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Profile Name
                GestureDetector(
                  onTap: () {
                    _navigateTo('profile');
                  },
                  child: Text(
                    isLoading ? 'Loading...' : (profileName ?? 'Guest User'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                
                // Profile Email
                GestureDetector(
                  onTap: () {
                    _navigateTo('profile');
                  },
                  child: Text(
                    isLoading ? 'Loading...' : (profileEmail ?? 'No email'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Premium Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Premium Member",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // ==================== DRAWER ITEMS ====================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: "Home",
                  route: 'home',
                  isSelected: _selectedIndex == 0,
                ),
                _buildDrawerItem(
                  icon: Icons.search_outlined,
                  title: "Search",
                  route: 'search',
                  isSelected: _selectedIndex == 1,
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  title: "Favorites",
                  route: 'favorites',
                  isSelected: _selectedIndex == 2,
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  title: "Orders",
                  route: 'orders',
                  isSelected: _selectedIndex == 3,
                ),
                InkWell(
                  onTap:(){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventScreen(),
      ),
    );
                  },
                  child: _buildDrawerItem(
                    icon: Icons.event_outlined,
                    title: "Events",
                    route: 'events',
                    isSelected: _selectedIndex == 4,
                  ),
                ),
                const Divider(height: 1),
             InkWell(
                  onTap:(){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
                  },
                  child: _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: "Profile",
                    route: 'profile',
                    isSelected: _selectedIndex == 5,
                  ),
                ),
                InkWell(
                  onTap:(){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
                  },
                  child: _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    route: 'settings',
                    isSelected: _selectedIndex == 6,
                  ),
                ),
                InkWell(
                  onTap:(){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportPage(),
      ),
    );
                  },
                  child: _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    route: 'help',
                    isSelected: _selectedIndex == 7,
                  ),
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  title: "Logout",
                  onTap: _showLogoutDialog,
                  isLogout: true,
                ),
              ],
            ),
          ),
          
          // ==================== BOTTOM QR CODE SECTION ====================
          InkWell(
                  onTap:(){
                      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerScreen(),
      ),
    );
                  },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Color(0xFFC62828),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scan QR Code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Scan to view menu & order",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC62828),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DRAWER ITEM WIDGET ====================
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
    bool isLogout = false,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC62828).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isLogout 
              ? Colors.red 
              : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade700),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout 
              ? Colors.red 
              : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade800),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFC62828),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          : (isLogout ? const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 14) : null),
      onTap: onTap ?? () {
        if (route != null) {
          _navigateTo(route);
        }
      },
      tileColor: isSelected ? const Color(0xFFC62828).withOpacity(0.05) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}