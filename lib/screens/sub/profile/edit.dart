import 'package:ballon/createprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';

// ==========================================================
//  COUNTRY MODEL (no library)
// ==========================================================
class Country {
  final String name;
  final String iso;
  final String dial;
  final String flag;

  const Country({
    required this.name,
    required this.iso,
    required this.dial,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> j) => Country(
        name: j['name'] as String,
        iso: j['iso'] as String,
        dial: j['dial'] as String,
        flag: j['flag'] as String,
      );

  static List<Country>? _cache;

  static Future<List<Country>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/countries.json');
    final list = (json.decode(raw) as List)
        .map((e) => Country.fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = list;
    return list;
  }
}

// ==========================================================
//  PROFILE MODEL
// ==========================================================
class Profile {
  final int? pk;
  final User? user;
  final String? name;
  final dynamic activity;
  final dynamic place;
  final String? picture;
  final String? phoneNumber;
  final String? countryCode;
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
    this.countryCode,
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
      phoneNumber: json['phone_number']?.toString(),
      countryCode: json['country_code']?.toString(),
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

// ==========================================================
//  SCREEN
// ==========================================================
class EditProfileScreen extends StatefulWidget {
  final int? id;
  const EditProfileScreen({super.key, this.id});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _usernameController;

  // Country state
  List<Country> _countries = [];
  Country? _selectedCountry;
  final TextEditingController _countryCodeController =
      TextEditingController(text: '+255');

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  Profile? _currentProfile;
  int? _profileId;

  late final String apiUrl;
  static const String _baseUrl = 'http://192.168.1.115:8000';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCountries().then((_) => _fetchProfile());
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _usernameController = TextEditingController();
  }

  // ==========================================================
  //  LOAD COUNTRIES (Tanzania default)
  // ==========================================================
  Future<void> _loadCountries() async {
    final list = await Country.load();

    // Default = Tanzania (+255)
    Country defaultCountry = list.firstWhere(
      (c) => c.iso == 'TZ',
      orElse: () => list.first,
    );

    if (!mounted) return;
    setState(() {
      _countries = list;
      _selectedCountry ??= defaultCountry;
      _countryCodeController.text = _selectedCountry!.dial;
    });
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

        // Restore saved country_code, else keep Tanzania
        if (profile.countryCode != null && profile.countryCode!.isNotEmpty) {
          _countryCodeController.text = profile.countryCode!;
          if (_countries.isNotEmpty) {
            try {
              _selectedCountry = _countries.firstWhere(
                (c) => c.dial == profile?.countryCode,
              );
            } catch (_) {}
          }
        } else {
          _countryCodeController.text = '+255';
          if (_countries.isNotEmpty) {
            try {
              _selectedCountry = _countries.firstWhere((c) => c.iso == 'TZ');
            } catch (_) {}
          }
        }

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
  //  IMAGE PICKER
  // ==========================================================
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _pickedImage = File(image.path));
      }
    } catch (e) {
      _showSnack('Failed to pick image: $e');
    }
  }

  // ==========================================================
  //  COUNTRY PICKER
  // ==========================================================
  Future<void> _openCountryPicker() async {
    final picked = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => _CountryPickerSheet(
        countries: _countries,
        selected: _selectedCountry,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedCountry = picked;
        _countryCodeController.text = picked.dial;
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

      // Text fields
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['country_code'] = _countryCodeController.text.trim();
      request.fields['phone_number'] = _phoneController.text.trim();
      request.fields['place'] = _locationController.text;
      request.fields['bio'] = _bioController.text;

      if (_pickedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'picture',
          _pickedImage!.path,
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
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.black87),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  // ==========================================================
  //  BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.editProfile,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _currentProfile == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColor,
                          ),
                          child: const Text('Retry',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          padding:
                              const EdgeInsets.only(bottom: 30, top: 20),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 47,
                                    backgroundColor: Colors.grey[200],
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : (_currentProfile?.picture !=
                                                      null &&
                                                  _currentProfile!
                                                      .picture!.isNotEmpty
                                              ? NetworkImage(
                                                  _currentProfile!.picture!)
                                              : const NetworkImage(
                                                      'https://i.pravatar.cc/300')
                                                  as ImageProvider),
                                      onBackgroundImageError: (_, __) {},
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color:
                                          Theme.of(context).primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                context.tr.tapPhotoToChange,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Form
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                label: context.tr.fullName,
                                controller: _nameController,
                                validator: (val) => val!.isEmpty
                                    ? 'Name cannot be empty'
                                    : null,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label: context.tr.email,
                                controller: _emailController,
                                validator: (val) => !val!.contains('@')
                                    ? 'Enter a valid email'
                                    : null,
                              ),
                              const SizedBox(height: 15),
                              // 🔽 Phone with country code + flag on the LEFT
                              _buildPhoneField(),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label: context.tr.location,
                                controller: _locationController,
                                suffixIcon: Icons.location_on_outlined,
                                iconColor: Colors.grey,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label: context.tr.bio,
                                controller: _bioController,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      _isSaving ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          context.tr.saveChanges,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
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
  //  PHONE FIELD WITH COUNTRY CODE + FLAG (left)
  // ==========================================================
  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.phoneNumber,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              // LEFT: flag + dial code button
              InkWell(
                onTap: _countries.isEmpty ? null : _openCountryPicker,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCountry?.flag ?? '🇹🇿',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _countryCodeController.text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: Colors.grey, size: 22),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 22,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 6),
              ),
              // RIGHT: phone number input
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '712 345 678',
                  ),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  //  GENERIC INPUT FIELD
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
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
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              if (suffixIcon != null)
                Icon(suffixIcon, color: iconColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
//  COUNTRY PICKER SHEET
// ==========================================================
class _CountryPickerSheet extends StatefulWidget {
  final List<Country> countries;
  final Country? selected;

  const _CountryPickerSheet({
    required this.countries,
    this.selected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _search = TextEditingController();
  List<Country> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _search.text.toLowerCase().trim();
    setState(() {
      _filtered = q.isEmpty
          ? widget.countries
          : widget.countries.where((c) {
              return c.name.toLowerCase().contains(q) ||
                  c.iso.toLowerCase().contains(q) ||
                  c.dial.contains(q);
            }).toList();
    });
  }

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Select Country Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _search,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search country or dial code…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _search.clear(),
                      )
                    : null,
                filled: true,
                fillColor:
                    Theme.of(context).inputDecorationTheme.fillColor,
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
                ? const Center(
                    child: Text('No countries found',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: bottomInset + 8),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final c = _filtered[index];
                      final isSel = widget.selected?.iso == c.iso;
                      return ListTile(
                        leading: Text(c.flag,
                            style: const TextStyle(fontSize: 26)),
                        title: Text(
                          c.name,
                          style: TextStyle(
                            fontWeight: isSel
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          c.dial,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSel
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                          ),
                        ),
                        selected: isSel,
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}