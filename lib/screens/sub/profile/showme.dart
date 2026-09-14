import 'package:ballon/screens/sub/profile/edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';
// --- Reuse your Profile & User models (import them if in a separate file) ---
class Profile {
  final int? pk;
  final User? user;
  final String? name;
  final dynamic activity;
  final dynamic place;
  final String? picture;
  final int? phoneNumber;
  final String? email;
  final String? bio;
  final String? birthday;

  Profile({
    this.pk,
    this.user,
    this.name,
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
      pk: json['pk'] as int?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString() ?? '',
      activity: json['activity'],
      place: json['place'],
      picture: json['picture'] as String?,
      phoneNumber: json['phone_number'] as int?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] as String?,
    );
  }
}

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class ProfileShowScreen extends StatefulWidget {
  final int? id;
  const ProfileShowScreen({super.key, this.id});

  @override
  State<ProfileShowScreen> createState() => _ProfileShowScreenState();
}

class _ProfileShowScreenState extends State<ProfileShowScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Profile? _profile;

  late final String _baseUrl = 'http://192.168.1.115:8000';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? profileId = widget.id ?? prefs.getInt('profid');

      if (profileId == null) {
        throw Exception('No profile ID found');
      }

      final url = '$_baseUrl/prof/api-prof/$profileId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);

        Profile profile;
        if (jsonData is List) {
          if (jsonData.isEmpty) throw Exception('Profile not found');
          profile = Profile.fromJson(jsonData[0] as Map<String, dynamic>);
        } else if (jsonData is Map<String, dynamic>) {
          profile = Profile.fromJson(jsonData);
        } else {
          throw Exception('Unexpected data format');
        }

        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found');
      } else {
        throw Exception('Failed to load profile (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState(primary)
              : _buildProfileContent(primary),
    );
  }

  // ---------- Error state ----------
  Widget _buildErrorState(Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchProfile,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Main content ----------
  Widget _buildProfileContent(Color primary) {
    final profile = _profile!;
    final displayName = (profile.name?.isNotEmpty ?? false)
        ? profile.name!
        : (profile.user?.username ?? 'User');
    final email = profile.email ?? profile.user?.email ?? '';
    final username = profile.user?.username ?? '';

    return CustomScrollView(
      slivers: [
        // ---------- Header with cover + avatar ----------
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          backgroundColor: primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                // Navigate to EditProfileScreen and refresh on return
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(id: profile.pk),
                  ),
                );
                if (updated == true) _fetchProfile();
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: profile.picture != null
                          ? NetworkImage(profile.picture!)
                          : const NetworkImage('https://i.pravatar.cc/300'),
                      onBackgroundImageError: (_, __) {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (username.isNotEmpty)
                    Text(
                      '@$username',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        ),

        // ---------- Stats row ----------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Profile ID', profile.pk?.toString() ?? '-', primary),
                _buildDivider(),
                _buildStat('Activity', profile.activity?.toString() ?? '-', primary),
                _buildDivider(),
                _buildStat('Birthday', profile.birthday ?? '-', primary),
              ],
            ),
          ),
        ),

        // ---------- Bio ----------
        if ((profile.bio ?? '').isNotEmpty)
          SliverToBoxAdapter(
            child: _buildSection(
              title:  context.tr.about,
              child: Text(
                profile.bio!,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ),

        // ---------- Info cards ----------
        SliverToBoxAdapter(
          child: _buildSection(
            title: context.tr.contactInformation,
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  label:  context.tr.email,
                  value: email.isNotEmpty ? email : 'Not set',
                  primary: primary,
                ),
                _buildInfoTile(
                  icon: Icons.phone_outlined,
                  label:  context.tr.phoneNumber,
                  value: profile.phoneNumber?.toString() ?? 'Not set',
                  primary: primary,
                ),
                _buildInfoTile(
                  icon: Icons.location_on_outlined,
                  label:  context.tr.location,
                  value: profile.place?.toString() ?? 'Not set',
                  primary: primary,
                ),
                _buildInfoTile(
                  icon: Icons.person_outline,
                  label:  context.tr.username,
                  value: username.isNotEmpty ? username : 'Not set',
                  primary: primary,
                ),
              ],
            ),
          ),
        ),

        // ---------- Action buttons ----------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                    label:  Text( context.tr.message,
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text( context.tr.messageComingSoon)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.edit, color: primary),
                    label: Text( context.tr.edit, style: TextStyle(color: primary)),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(id: profile.pk),
                        ),
                      );
                      if (updated == true) _fetchProfile();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Helper widgets ----------
  Widget _buildStat(String label, String value, Color primary) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDivider() => Container(
        width: 1,
        height: 30,
        color: Colors.grey[300],
      );

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color primary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}