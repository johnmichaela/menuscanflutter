import 'package:ballon/createprofile.dart';
import 'package:ballon/main.dart';
import 'package:ballon/pages/about_us_page.dart';
import 'package:ballon/pages/help_support_page.dart';
import 'package:ballon/pages/notification_settings_page.dart';
import 'package:ballon/pages/payment_methods_page.dart';
import 'package:ballon/screens/sub/profile/edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ballon/l10n/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Paste your Profile model here ---
class Profile {
  final int pk;
  final User user;
  final String name;
  final dynamic activity;
  final dynamic place;
  final String? picture;
  final int? phoneNumber;
  final String? email;
  final String? bio;
  final String? birthday;

  Profile({
    required this.pk,
    required this.user,
    required this.name,
    this.activity,
    this.place,
    this.picture,
    this.phoneNumber,
    this.email,
    this.bio,
    this.birthday,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      pk: json['pk'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      activity: json['activity'],
      place: json['place'],
      picture: json['picture'] as String?,
      phoneNumber: json['phone_number'],
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'user': user.toJson(),
      'name': name,
      'activity': activity,
      'place': place,
      'picture': picture,
      'phone_number': phoneNumber,
      'email': email,
      'bio': bio,
      'birthday': birthday,
    };
  }
}

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email};
  }
}
// --- End of model ---

// --------------------------------------------------------------------------
// Screen 1: Profile (Updated with API)
// --------------------------------------------------------------------------
class ProfileShowScreen extends StatefulWidget {
  const ProfileShowScreen({super.key});

  @override
  State<ProfileShowScreen> createState() => _ProfileShowScreenState();
}

class _ProfileShowScreenState extends State<ProfileShowScreen> {
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
  }

  // Future<Profile> fetchProfile() async {
  //   // Replace with your actual API endpoint
  //   final prefs = await SharedPreferences.getInstance();
  // final String? token = prefs.getString('token');

  //   final url = Uri.parse('http://192.168.1.115:8000/prof/api-prof/');
    
  //   try {
  //     final response = await http.get(url, 
  //      headers: {
  //       'Authorization': 'Token $token', // IMPORTANT: space after Token
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     },);
     

  //     if (response.statusCode == 200) {
  //       // If your API returns a list, use jsonDecode(response.body)[0]
  //       // If it returns a single object, use jsonDecode(response.body)
  //       final jsonData = jsonDecode(response.body);
  //       return Profile.fromJson(jsonData);
  //     } else {
  //       throw Exception('Failed to load profile. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching data: $e');
  //   }
  // }
  Future<Profile> fetchProfile() async {
    // Replace with your actual API endpoint
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse('http://192.168.1.115:8000/prof/api-prof/');
    
    try {
      final response = await http.get(url, 
       headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
     
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // 1. Check if the data is a List (as your error suggests)
        if (jsonData is List) {
          if (jsonData.isEmpty) {
            throw Exception('No profile found for this user');
          }
          // 2. Parse the first element in the list
          // If you have multiple users and need a specific one, 
          // you might need to find the one that matches the user based on the token's ID.
          return Profile.fromJson(jsonData[0] as Map<String, dynamic>);
        } 
        // 3. Fallback if it's a single object
        else if (jsonData is Map<String, dynamic>) {
          return Profile.fromJson(jsonData);
        } 
        else {
          throw Exception('Unexpected data format');
        }
        
      } else {
        throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

// ==================== SIMPLE LOGOUT FUNCTION ====================

Future<void> logoutUser(BuildContext context) async {
  try {
    // 1. Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Get the token
    final String? token = prefs.getString('token');
    
    // 3. Call logout API (optional but recommended)
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.115:8000/prof/api/logout/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        print('Logout API status: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Logout API success: ${response.body}');
        }
      } catch (e) {
        // If API fails, continue with local logout
        print('Logout API error: $e');
      }
    }
    
    // 4. REMOVE TOKEN - Clear all SharedPreferences
    await prefs.clear();
    
    // 5. Navigate to login screen
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>  BalloonApp(), // Make sure BalloonApp is defined
        ),
        (route) => false, // Removes all previous routes
      );
    }
    
  } catch (e) {
    // Handle any errors
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profileFuture = fetchProfile();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final profile = snapshot.data!;
          return _buildProfileUI(profile);
        },
      ),
    );
  }

  Widget _buildProfileUI(Profile profile) {
    // Fallbacks for empty fields
    String displayName = profile.name.isNotEmpty ? profile.name : profile.user.username;
    String displayEmail = profile.email ?? profile.user.email;
    int displayPhone = profile.phoneNumber!;
    
    // Fallback for picture
    String imageUrl = profile.picture ?? 'https://i.pravatar.cc/300';

    return Column(
      children: [
        // Header
        Container(
          height: 275,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/avarbg.png'),
              fit: BoxFit.cover,
            ),
            // color: Color(0xFFB71C1C),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile' ,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CreateProfileScreen(),
                      //       ),
                      //     );
                      //   },
                      //   icon: const Icon(Icons.add, color: Colors.white),
                      // )
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(id: profile.pk),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                     CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 47,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 245, 243, 243),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Color.fromARGB(255, 218, 18, 18), size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  displayEmail,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Stats (Using placeholder values as model doesn't have specific stats)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('23', 'Bookings'),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem('12', 'Reviews'),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem('5', 'Saved'),
              ],
            ),
          ),
        ),

        // Menu List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildMenuTile(Icons.calendar_today_outlined, 'My Bookings', Colors.blue),
              _buildMenuTile(Icons.favorite_border, 'Saved Places', Colors.redAccent),
              _buildMenuTile(Icons.star_border, 'My Reviews', Colors.orange),
              _buildMenuTile(Icons.qr_code_2, 'My QR Code', Colors.purple),
             // ==================== CORRECTED NAVIGATION ====================

// 1. Payment Methods - Navigate to PaymentMethodsPage
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodsPage(),
      ),
    );
  },
  child: _buildMenuTile(Icons.credit_card, 'Payment Methods', Colors.teal),
),

// 2. Notification Settings - Navigate to NotificationSettingsPage
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsPage(),
      ),
    );
  },
  child: _buildMenuTile(Icons.notifications_none, 'Notification Settings', Colors.green),
),

// 3. Help & Support - Navigate to HelpSupportPage
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSupportPage(),
      ),
    );
  },
  child: _buildMenuTile(Icons.help_outline, 'Help & Support', Colors.blueGrey),
),

// 4. About Us - Navigate to AboutUsPage
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUsPage(),
      ),
    );
  },
  child: _buildMenuTile(Icons.info_outline, 'About Us', Colors.red),
),
              // Log Out Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
                    ],
                  ),
                  child:InkWell(
                    onTap: () {
                      print('start');
                      logoutUser(context);
                    },
                    child: Container(
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: Color(0xFFB71C1C)),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Color(0xFFB71C1C)),
                        // onTap: () =>logoutUser(context),?
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        // onTap: () {},
      ),
    );
  }
}