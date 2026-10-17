
import 'package:ballon/createprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ballon/l10n/app_strings.dart';

// ==========================================================
//  BUSINESS TYPE MODEL
// ==========================================================
class BusinessType {
  final int id;
  final String name;
  final String color;
  final String icon;
  final String textColor;
  final String description;

  BusinessType({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.textColor,
    required this.description,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '#000000',
      icon: json['icon'] as String? ?? '',
      textColor: json['text_color'] as String? ?? '#FFFFFF',
      description: json['description'] as String? ?? '',
    );
  }

  Color get colorValue {
    try {
      final hex = color.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}

// ==========================================================
//  PROFILE MODEL
// ==========================================================
class Profile {
  final int? pk;
  final User? user;
  final String? name;
  final dynamic typeBusiness;
  final dynamic place;
  final String? picture;
  final String? banner;
  final int? phoneNumber;
  final String? email;
  final String? bio;
  final String? birthday;
  final double? latitude;
  final double? longitude;

  Profile({
    this.pk,
    this.user,
    this.name,
    this.typeBusiness,
    this.place,
    this.picture,
    this.banner,
    this.phoneNumber,
    this.email,
    this.bio,
    this.birthday,
    this.latitude,
    this.longitude,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      pk: json['pk'] as int?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString() ?? '',
      typeBusiness: json['type_business'],
      place: json['place'],
      picture: json['picture'] as String?,
      banner: json['banner'] as String?,
      phoneNumber: json['phone_number'] as int?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] as String?,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
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

// ==========================================================
//  SCREEN
// ==========================================================
class EditProfileBusinessScreen extends StatefulWidget {
  final int? id;
  const EditProfileBusinessScreen({super.key, this.id});

  @override
  State<EditProfileBusinessScreen> createState() =>
      _EditProfileBusinessScreenState();
}

class _EditProfileBusinessScreenState extends State<EditProfileBusinessScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _typeBusinessController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _usernameController;

  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  File? _pickedBanner;

  List<BusinessType> _businessTypes = [];
  BusinessType? _selectedBusinessType;
  bool _isLoadingTypes = false;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  Profile? _currentProfile;
  int? _profileId;

  // Location state
  double? _latitude;
  double? _longitude;
  bool _isGettingLocation = false;

  late final String apiUrl;
  static const String _baseUrl = 'https://qopera.app';

  // Cover & avatar sizing
  static const double _coverHeight = 220;
  static const double _avatarRadius = 55;
  static const double _avatarRing = 4;
  static const double _avatarTotal = (_avatarRadius + _avatarRing) * 2;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchBusinessTypes();
    _fetchProfile();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _typeBusinessController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _usernameController = TextEditingController();
  }

  // ==========================================================
  //  FETCH BUSINESS TYPES
  // ==========================================================
  Future<void> _fetchBusinessTypes() async {
    setState(() => _isLoadingTypes = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$_baseUrl/prof/business-types/'),
        headers: {
          if (token != null) 'Authorization': 'Token $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> list = jsonData['data'] as List<dynamic>? ?? [];
        setState(() {
          _businessTypes = list
              .map((e) => BusinessType.fromJson(e as Map<String, dynamic>))
              .toList();
          _isLoadingTypes = false;
        });
      } else {
        setState(() => _isLoadingTypes = false);
      }
    } catch (e) {
      debugPrint('Error fetching business types: $e');
      setState(() => _isLoadingTypes = false);
    }
  }

  // ==========================================================
  //  FETCH PROFILE
  // ==========================================================
  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      _profileId = widget.id ?? prefs.getInt('profid');

      if (_profileId == null) {
        _navigateToCreateProfile();
        return;
      }

      apiUrl = '$_baseUrl/prof/api-prof/$_profileId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        Profile? profile;
        if (jsonData is List) {
          if (jsonData.isEmpty) return;
          profile = Profile.fromJson(jsonData[0] as Map<String, dynamic>);
        } else if (jsonData is Map<String, dynamic>) {
          profile = Profile.fromJson(jsonData);
        } else {
          throw Exception('Unexpected data format');
        }

        if (profile.name == null || profile.name!.isEmpty) return;

        _nameController.text = profile.name ?? '';
        _emailController.text = profile.email ?? profile.user?.email ?? '';
        _phoneController.text = profile.phoneNumber?.toString() ?? '';
        _locationController.text = profile.place?.toString() ?? '';
        _bioController.text = profile.bio ?? '';
        _usernameController.text = profile.user?.username ?? '';

        // Load existing coordinates
        _latitude = profile.latitude;
        _longitude = profile.longitude;

        _resolveBusinessType(profile.typeBusiness);

        setState(() {
          _currentProfile = profile;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        _navigateToCreateProfile();
      } else {
        throw Exception('Failed to load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _resolveBusinessType(dynamic value) {
    if (value == null) return;
    if (_businessTypes.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _resolveBusinessType(value);
      });
      return;
    }

    BusinessType? match;
    if (value is int) {
      match = _businessTypes.firstWhere(
        (t) => t.id == value,
        orElse: () => _businessTypes.first,
      );
    } else {
      final strValue = value.toString().toLowerCase();
      try {
        match = _businessTypes.firstWhere(
          (t) => t.name.toLowerCase() == strValue,
        );
      } catch (_) {
        match = null;
      }
    }

    if (match != null) {
      setState(() {
        _selectedBusinessType = match;
        _typeBusinessController.text = match!.name;
      });
    } else {
      _typeBusinessController.text = value.toString();
    }
  }

  void _navigateToCreateProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateProfileScreen()),
        );
      }
    });
  }

  // ==========================================================
  //  IMAGE PICKERS
  // ==========================================================
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _pickedImage = File(image.path));
    } catch (e) {
      _showSnack('Failed to pick image: $e');
    }
  }

  Future<void> _pickBanner() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _pickedBanner = File(image.path));
    } catch (e) {
      _showSnack('Failed to pick banner: $e');
    }
  }

  // ==========================================================
  //  GET CURRENT LOCATION (auto-fill place + lat + lng)
  // ==========================================================
  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;
    setState(() => _isGettingLocation = true);

    try {
      // 1. Is location service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled. Please enable GPS.');
        return;
      }

      // 2. Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnack(
            'Location permissions are permanently denied. Enable them in settings.');
        return;
      }

      // 3. Position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Reverse-geocode
      String placeName = '';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          placeName = [
            p.name,
            p.street,
            p.locality,
            p.administrativeArea,
            p.country,
          ]
              .where((e) => e != null && e.toString().trim().isNotEmpty)
              .toSet() // remove duplicates like "Dar es Salaam, Dar es Salaam"
              .join(', ');
        }
      } catch (e) {
        debugPrint('Reverse geocoding failed: $e');
      }

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationController.text = placeName.isNotEmpty
            ? placeName
            : '${position.latitude.toStringAsFixed(6)}, '
                '${position.longitude.toStringAsFixed(6)}';
      });

      _showSnack('Location detected ✅', color: Colors.green);
    } catch (e) {
      debugPrint('Error getting location: $e');
      _showSnack('Failed to get location: $e');
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  // ==========================================================
  //  BUSINESS TYPE PICKER
  // ==========================================================
  Future<void> _openBusinessTypePicker() async {
    final selected = await showModalBottomSheet<BusinessType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => _BusinessTypeSearchSheet(
        types: _businessTypes,
        selected: _selectedBusinessType,
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedBusinessType = selected;
        _typeBusinessController.text = selected.name;
      });
    }
  }

  // ==========================================================
  //  SAVE PROFILE
  // ==========================================================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) throw Exception('Not authenticated');

      final bool isCreating = _profileId == null;
      final String url = isCreating
          ? '$_baseUrl/prof/api-prof/'
          : '$_baseUrl/prof/api-prof/$_profileId';
      final String method = isCreating ? 'POST' : 'PUT';

      var request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      });

      // ---- Text fields ----
      request.fields['name'] = _nameController.text;
      if (_selectedBusinessType != null) {
        request.fields['type_business'] = _selectedBusinessType!.id.toString();
      }
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneController.text;
      request.fields['place'] = _locationController.text;
      request.fields['bio'] = _bioController.text;

      // ---- Coordinates (only if we have them) ----
      if (_latitude != null) {
        request.fields['latitude'] = _latitude!.toString();
      }
      if (_longitude != null) {
        request.fields['longitude'] = _longitude!.toString();
      }

      // ---- Files ----
      if (_pickedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'picture',
          _pickedImage!.path,
        ));
      }
      if (_pickedBanner != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'banner',
          _pickedBanner!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        if (isCreating && response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['pk'] != null) {
            await prefs.setInt('profid', data['pk'] as int);
          }
        }

        _showSnack(
          isCreating
              ? 'Profile created successfully!'
              : 'Profile updated successfully!',
          color: Colors.green,
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(
            'Failed to save. Status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save: $e');
      _showSnack('Error: $e', color: Colors.red);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color ?? Colors.black87,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeBusinessController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // ==========================================================
  //  BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _currentProfile == null
              ? _buildErrorView(primary)
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ================= COVER + AVATAR =================
                      SizedBox(
                        height: _coverHeight + (_avatarTotal / 2) + 8,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: _coverHeight,
                              child: _buildCoverImage(primary),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _circleIconButton(
                                        icon:
                                            Icons.arrow_back_ios_new_rounded,
                                        onTap: () =>
                                            Navigator.pop(context),
                                        size: 18,
                                      ),
                                      if (_isSaving)
                                        Container(
                                          padding:
                                              const EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withOpacity(0.35),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child:
                                                CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      else
                                        _circleIconButton(
                                          icon: Icons.check_rounded,
                                          onTap: _saveProfile,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _coverHeight - _avatarTotal / 2,
                              left: 0,
                              right: 0,
                              child: Center(child: _buildAvatar()),
                            ),
                          ],
                        ),
                      ),

                      // ================= NAME + HINT =================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: Column(
                          children: [
                            Text(
                              _currentProfile?.name?.isNotEmpty == true
                                  ? _currentProfile!.name!
                                  : 'Business Profile',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 13,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.tr.tapPhotoToChange,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================= FORM =================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSectionCard(
                                title:  context.tr.businessInfo,
                                icon: Icons.storefront_outlined,
                                children: [
                                  _buildInputField(
                                    label: context.tr.fullName,
                                    controller: _nameController,
                                    validator: (val) => val!.isEmpty
                                        ?  context.tr.nameCannotBeEmpty
                                        : null,
                                  ),
                                  _buildDivider(),
                                  _buildBusinessTypeField(),
                                  _buildDivider(),
                                  _buildInputField(
                                    label: context.tr.bio,
                                    controller: _bioController,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildSectionCard(
                                title:context.tr.contact,
                                icon: Icons.contact_mail_outlined,
                                children: [
                                  _buildInputField(
                                    label: context.tr.email,
                                    controller: _emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    validator: (val) => !val!.contains('@')
                                        ? context.tr.enterValidEmail
                                        : null,
                                  ),
                                  _buildDivider(),
                                  _buildInputField(
                                    label: context.tr.phoneNumber,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  _buildDivider(),
                                  // ---- Location with GPS button ----
                                  _buildLocationField(),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed:
                                      _isSaving ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    elevation: 4,
                                    shadowColor:
                                        primary.withOpacity(0.35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.check_circle,
                                                color: Colors.white,
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              context.tr.saveChanges,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // ==========================================================
  //  COVER IMAGE
  // ==========================================================
  Widget _buildCoverImage(Color primary) {
    final hasBanner = _pickedBanner != null ||
        (_currentProfile?.banner != null &&
            _currentProfile!.banner!.isNotEmpty);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary,
                Color.lerp(primary, Colors.black, 0.35) ?? primary,
              ],
            ),
          ),
        ),
        if (hasBanner)
          _pickedBanner != null
              ? Image.file(_pickedBanner!,
                  fit: BoxFit.cover, width: double.infinity)
              : Image.network(
                  _currentProfile!.banner!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.30),
                Colors.transparent,
                Colors.black.withOpacity(0.20),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
        if (!hasBanner)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.white70, size: 40),
                SizedBox(height: 8),
                Text( context.tr.addCoverPicture,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Positioned(
          left: 16,
          bottom: 14,
          child: GestureDetector(
            onTap: _pickBanner,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 15),
                  SizedBox(width: 6),
                  Text(
                    context.tr.editCover,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  //  AVATAR
  // ==========================================================
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(_avatarRing),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: _avatarRadius,
              backgroundColor: const Color(0xFFE5E7EB),
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!) as ImageProvider
                  : (_currentProfile?.picture != null &&
                          _currentProfile!.picture!.isNotEmpty
                      ? NetworkImage(_currentProfile!.picture!)
                      : const NetworkImage('https://i.pravatar.cc/300')),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 2, bottom: 2),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt_rounded,
                color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  //  CIRCLE ICON BUTTON
  // ==========================================================
  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 20,
  }) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }

  // ==========================================================
  //  SECTION CARD
  // ==========================================================
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: Colors.grey[100],
      );

  // ==========================================================
  //  ERROR VIEW
  // ==========================================================
  Widget _buildErrorView(Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(context.tr.networkError,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchBusinessTypes();
                _fetchProfile();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child:  Text(context.tr.retry,
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  //  BUSINESS TYPE FIELD
  // ==========================================================
  Widget _buildBusinessTypeField() {
    return InkWell(
      onTap: _isLoadingTypes ? null : _openBusinessTypePicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (_selectedBusinessType != null) ...[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _selectedBusinessType!.colorValue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconForName(_selectedBusinessType!.icon),
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.typeBusiness,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _selectedBusinessType?.name ??
                        (_typeBusinessController.text.isNotEmpty
                            ? _typeBusinessController.text
                            :  context.tr.selectCategory),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _selectedBusinessType == null &&
                              _typeBusinessController.text.isEmpty
                          ? Colors.grey
                          :Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoadingTypes)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  //  LOCATION FIELD (with "auto current location" button)
  // ==========================================================
  Widget _buildLocationField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            context.tr.location,
            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color,),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _locationController,
                  maxLines: 2,
                  minLines: 1,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    hintText:  context.tr.enterLocation,
                  ),
                  style:  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              // GPS button
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: _isGettingLocation ? null : _getCurrentLocation,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(_isGettingLocation ? 0.35 : 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isGettingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.my_location_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
          // Show coordinates when present
          if (_latitude != null && _longitude != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 13, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${_latitude!.toStringAsFixed(6)}, '
                  '${_longitude!.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() {
                    _latitude = null;
                    _longitude = null;
                  }),
                  child: Text(
                    context.tr.clear,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconForName(String name) {
    const map = {
      'palette': Icons.palette,
      'directions_car': Icons.directions_car,
      'movie': Icons.movie,
      'checkroom': Icons.checkroom,
      'account_balance': Icons.account_balance,
      'yard': Icons.yard,
      'hotel': Icons.hotel,
      'pets': Icons.pets,
      'home_work': Icons.home_work,
      'fitness_center': Icons.fitness_center,
      'computer': Icons.computer,
      'flight': Icons.flight,
    };
    return map[name] ?? Icons.category;
  }

  // ==========================================================
  //  INPUT FIELD
  // ==========================================================
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    IconData? suffixIcon,
    Color? iconColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:  TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color,),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
                  maxLines: maxLines,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                  style:  TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,)
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(suffixIcon, color: iconColor, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
//  BUSINESS TYPE SEARCH BOTTOM SHEET
// ==========================================================
class _BusinessTypeSearchSheet extends StatefulWidget {
  final List<BusinessType> types;
  final BusinessType? selected;

  const _BusinessTypeSearchSheet({
    required this.types,
    this.selected,
  });

  @override
  State<_BusinessTypeSearchSheet> createState() =>
      _BusinessTypeSearchSheetState();
}

class _BusinessTypeSearchSheetState extends State<_BusinessTypeSearchSheet> {
  late TextEditingController _searchController;
  late List<BusinessType> _filtered;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtered = widget.types;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filtered = query.isEmpty
          ? widget.types
          : widget.types
              .where((t) => t.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    super.dispose();
  }

  IconData _iconFor(String name) {
    const map = {
      'palette': Icons.palette,
      'directions_car': Icons.directions_car,
      'movie': Icons.movie,
      'checkroom': Icons.checkroom,
      'account_balance': Icons.account_balance,
      'yard': Icons.yard,
      'hotel': Icons.hotel,
      'pets': Icons.pets,
      'home_work': Icons.home_work,
      'fitness_center': Icons.fitness_center,
      'computer': Icons.computer,
      'flight': Icons.flight,
    };
    return map[name] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration:  BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
           Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              context.tr.selectBusinessType,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: context.tr.searchCategoriesHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _filtered.isEmpty
                ?  Center(
                    child: Text( context.tr.noCategoriesFound,
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: bottomInset + 8),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final type = _filtered[index];
                      final isSelected = widget.selected?.id == type.id;
                      return ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: type.colorValue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _iconFor(type.icon),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          type.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          type.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).primaryColor)
                            : null,
                        onTap: () => Navigator.pop(context, type),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}