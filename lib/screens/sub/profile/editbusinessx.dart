
// import 'package:ballon/createprofile.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ballon/l10n/app_strings.dart';

// // --- Business Type Model ---
// class BusinessType {
//   final int id;
//   final String name;
//   final String color;
//   final String icon;
//   final String textColor;
//   final String description;

//   BusinessType({
//     required this.id,
//     required this.name,
//     required this.color,
//     required this.icon,
//     required this.textColor,
//     required this.description,
//   });

//   factory BusinessType.fromJson(Map<String, dynamic> json) {
//     return BusinessType(
//       id: json['id'] as int,
//       name: json['name'] as String? ?? '',
//       color: json['color'] as String? ?? '#000000',
//       icon: json['icon'] as String? ?? '',
//       textColor: json['text_color'] as String? ?? '#FFFFFF',
//       description: json['description'] as String? ?? '',
//     );
//   }

//   Color get colorValue {
//     try {
//       final hex = color.replaceFirst('#', '');
//       return Color(int.parse('FF$hex', radix: 16));
//     } catch (_) {
//       return Colors.grey;
//     }
//   }
// }

// // --- Profile Model ---
// class Profile {
//   final int? pk;
//   final User? user;
//   final String? name;
//   final dynamic typeBusiness;
//   final dynamic place;
//   final String? picture;
//   final String? banner;
//   final int? phoneNumber;
//   final String? email;
//   final String? bio;
//   final String? birthday;

//   Profile({
//     this.pk,
//     this.user,
//     this.name,
//     this.typeBusiness,
//     this.place,
//     this.picture,
//     this.banner,
//     this.phoneNumber,
//     this.email,
//     this.bio,
//     this.birthday,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       pk: json['pk'] as int?,
//       user: json['user'] != null
//           ? User.fromJson(json['user'] as Map<String, dynamic>)
//           : null,
//       name: json['name']?.toString() ?? '',
//       typeBusiness: json['type_business'],
//       place: json['place'],
//       picture: json['picture'] as String?,
//       banner: json['banner'] as String?,
//       phoneNumber: json['phone_number'] as int?,
//       email: json['email'] as String?,
//       bio: json['bio'] as String?,
//       birthday: json['birthday'] as String?,
//     );
//   }
// }

// class User {
//   final String username;
//   final String email;

//   User({required this.username, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       username: json['username'] as String? ?? '',
//       email: json['email'] as String? ?? '',
//     );
//   }
// }

// class EditProfileBusinessScreen extends StatefulWidget {
//   final int? id;
//   const EditProfileBusinessScreen({super.key, this.id});

//   @override
//   State<EditProfileBusinessScreen> createState() => _EditProfileBusinessScreenState();
// }

// class _EditProfileBusinessScreenState extends State<EditProfileBusinessScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameController;
//   late TextEditingController _typeBusinessController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _locationController;
//   late TextEditingController _bioController;
//   late TextEditingController _usernameController;

//   final ImagePicker _picker = ImagePicker();
//   File? _pickedImage;
//   File? _pickedBanner;

//   List<BusinessType> _businessTypes = [];
//   BusinessType? _selectedBusinessType;
//   bool _isLoadingTypes = false;

//   bool _isLoading = true;
//   bool _isSaving = false;
//   String? _errorMessage;
//   Profile? _currentProfile;
//   int? _profileId;

//   late final String apiUrl;
//   static const String _baseUrl = 'http://192.168.1.115:8000 ';

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _fetchBusinessTypes();
//     _fetchProfile();
//   }

//   void _initializeControllers() {
//     _nameController = TextEditingController();
//     _typeBusinessController = TextEditingController();
//     _emailController = TextEditingController();
//     _phoneController = TextEditingController();
//     _locationController = TextEditingController();
//     _bioController = TextEditingController();
//     _usernameController = TextEditingController();
//   }

//   Future<void> _fetchBusinessTypes() async {
//     setState(() => _isLoadingTypes = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       final response = await http.get(
//         Uri.parse('$_baseUrl/prof/business-types/'),
//         headers: {
//           if (token != null) 'Authorization': 'Token $token',
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         final List<dynamic> list = jsonData['data'] as List<dynamic>? ?? [];
//         setState(() {
//           _businessTypes = list
//               .map((e) => BusinessType.fromJson(e as Map<String, dynamic>))
//               .toList();
//           _isLoadingTypes = false;
//         });
//         print('Fetched ${_businessTypes.length} business types.');
//       } else {
//         setState(() => _isLoadingTypes = false);
//       }
//     } catch (e) {
//       debugPrint('Error fetching business types: $e');
//       setState(() => _isLoadingTypes = false);
//     }
//   }

//   Future<void> _fetchProfile() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       _profileId = widget.id ?? prefs.getInt('profid');

//       if (_profileId == null) {
//         _navigateToCreateProfile();
//         return;
//       }

//       apiUrl = '$_baseUrl/prof/api-prof/$_profileId';

//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Token $token',
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);

//         Profile? profile;
//         if (jsonData is List) {
//           if (jsonData.isEmpty) return;
//           profile = Profile.fromJson(jsonData[0] as Map<String, dynamic>);
//         } else if (jsonData is Map<String, dynamic>) {
//           profile = Profile.fromJson(jsonData);
//         } else {
//           throw Exception('Unexpected data format');
//         }

//         if (profile.name == null || profile.name!.isEmpty) return;

//         _nameController.text = profile.name ?? '';
//         _emailController.text = profile.email ?? profile.user?.email ?? '';
//         _phoneController.text = profile.phoneNumber?.toString() ?? '';
//         _locationController.text = profile.place?.toString() ?? '';
//         _bioController.text = profile.bio ?? '';
//         _usernameController.text = profile.user?.username ?? '';

//         _resolveBusinessType(profile.typeBusiness);

//         setState(() {
//           _currentProfile = profile;
//           _isLoading = false;
//         });
//       } else if (response.statusCode == 404) {
//         _navigateToCreateProfile();
//       } else {
//         throw Exception('Failed to load profile. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching profile: $e');
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   void _resolveBusinessType(dynamic value) {
//     if (value == null) return;
//     if (_businessTypes.isEmpty) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) _resolveBusinessType(value);
//       });
//       return;
//     }

//     BusinessType? match;
//     if (value is int) {
//       match = _businessTypes.firstWhere(
//         (t) => t.id == value,
//         orElse: () => _businessTypes.first,
//       );
//     } else {
//       final strValue = value.toString().toLowerCase();
//       try {
//         match = _businessTypes.firstWhere(
//           (t) => t.name.toLowerCase() == strValue,
//         );
//       } catch (_) {
//         match = null;
//       }
//     }

//     if (match != null) {
//       setState(() {
//         _selectedBusinessType = match;
//         _typeBusinessController.text = match!.name;
//       });
//     } else {
//       _typeBusinessController.text = value.toString();
//     }
//   }

//   void _navigateToCreateProfile() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CreateProfileScreen()),
//         );
//       }
//     });
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) setState(() => _pickedImage = File(image.path));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: $e')),
//       );
//     }
//   }

//   Future<void> _pickBanner() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) setState(() => _pickedBanner = File(image.path));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick banner: $e')),
//       );
//     }
//   }

//   Future<void> _openBusinessTypePicker() async {
//     final selected = await showModalBottomSheet<BusinessType>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _BusinessTypeSearchSheet(
//         types: _businessTypes,
//         selected: _selectedBusinessType,
//       ),
//     );

//     if (selected != null) {
//       setState(() {
//         _selectedBusinessType = selected;
//         _typeBusinessController.text = selected.name;
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isSaving = true;
//       _errorMessage = null;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       if (token == null) throw Exception('Not authenticated');

//       final bool isCreating = _profileId == null;
//       final String url = isCreating
//           ? '$_baseUrl/prof/api-prof/'
//           : '$_baseUrl/prof/api-prof/$_profileId';
//       final String method = isCreating ? 'POST' : 'PUT';

//       var request = http.MultipartRequest(method, Uri.parse(url));
//       request.headers.addAll({
//         'Authorization': 'Token $token',
//         'Accept': 'application/json',
//       });

//       request.fields['name'] = _nameController.text;
//       if (_selectedBusinessType != null) {
//         request.fields['type_business'] = _selectedBusinessType!.id.toString();
//       }
//       request.fields['email'] = _emailController.text;
//       request.fields['phone_number'] = _phoneController.text;
//       request.fields['place'] = _locationController.text;
//       request.fields['bio'] = _bioController.text;

//       if (_pickedImage != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'picture',
//           _pickedImage!.path,
//         ));
//       }

//       if (_pickedBanner != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'banner',
//           _pickedBanner!.path,
//         ));
//       }

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 204) {
//         if (isCreating && response.statusCode == 201) {
//           final data = jsonDecode(response.body);
//           if (data['pk'] != null) {
//             await prefs.setInt('profid', data['pk'] as int);
//           }
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(isCreating
//                 ? 'Profile created successfully!'
//                 : 'Profile updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context, true);
//       } else {
//         throw Exception(
//             'Failed to save. Status: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       setState(() => _errorMessage = 'Failed to save: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _typeBusinessController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _locationController.dispose();
//     _bioController.dispose();
//     _usernameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//     final size = MediaQuery.of(context).size;
//     final coverHeight = size.height * 0.28;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null && _currentProfile == null
//               ? _buildErrorView(primary)
//               : CustomScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   slivers: [
//                     // ---- Cover / Banner AppBar ----
//                     SliverAppBar(
//                       expandedHeight: coverHeight,
//                       pinned: true,
//                       stretch: true,
//                       elevation: 0,
//                       backgroundColor: primary,
//                       leading: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: CircleAvatar(
//                           backgroundColor: Colors.black.withOpacity(0.35),
//                           child: IconButton(
//                             icon: const Icon(Icons.arrow_back,
//                                 color: Colors.white, size: 20),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ),
//                       ),
//                       actions: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             backgroundColor: Colors.black.withOpacity(0.35),
//                             child: IconButton(
//                               icon: const Icon(Icons.check,
//                                   color: Colors.white, size: 20),
//                               onPressed: _isSaving ? null : _saveProfile,
//                             ),
//                           ),
//                         ),
//                       ],
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: _buildCoverImage(primary),
//                         stretchModes: const [
//                           StretchMode.zoomBackground,
//                           StretchMode.blurBackground,
//                         ],
//                       ),
//                     ),

//                     // ---- Avatar overlapping cover ----
//                     SliverToBoxAdapter(
//                       child: Transform.translate(
//                         offset: const Offset(0, -50),
//                         child: Column(
//                           children: [
//                             _buildAvatar(),
//                             const SizedBox(height: 8),
//                             Text(
//                               _currentProfile?.name?.isNotEmpty == true
//                                   ? _currentProfile!.name!
//                                   : 'Business Profile',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1F2937),
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               context.tr.tapPhotoToChange,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black45,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // ---- Form ----
//                     SliverToBoxAdapter(
//                       child: Transform.translate(
//                         offset: const Offset(0, -30),
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 _buildSectionCard(
//                                   title: 'Business Info',
//                                   icon: Icons.storefront_outlined,
//                                   children: [
//                                     _buildInputField(
//                                       label: context.tr.fullName,
//                                       controller: _nameController,
//                                       validator: (val) => val!.isEmpty
//                                           ? 'Name cannot be empty'
//                                           : null,
//                                     ),
//                                     _buildDivider(),
//                                     _buildBusinessTypeField(),
//                                     _buildDivider(),
//                                     _buildInputField(
//                                       label: context.tr.bio,
//                                       controller: _bioController,
//                                       maxLines: 3,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 _buildSectionCard(
//                                   title: 'Contact',
//                                   icon: Icons.contact_mail_outlined,
//                                   children: [
//                                     _buildInputField(
//                                       label: context.tr.email,
//                                       controller: _emailController,
//                                       keyboardType: TextInputType.emailAddress,
//                                       validator: (val) => !val!.contains('@')
//                                           ? 'Enter a valid email'
//                                           : null,
//                                     ),
//                                     _buildDivider(),
//                                     _buildInputField(
//                                       label: context.tr.phoneNumber,
//                                       controller: _phoneController,
//                                       keyboardType: TextInputType.phone,
//                                     ),
//                                     _buildDivider(),
//                                     _buildInputField(
//                                       label: context.tr.location,
//                                       controller: _locationController,
//                                       suffixIcon: Icons.location_on_outlined,
//                                       iconColor: Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 24),
//                                 SizedBox(
//                                   height: 52,
//                                   child: ElevatedButton(
//                                     onPressed: _isSaving ? null : _saveProfile,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: primary,
//                                       elevation: 2,
//                                       shadowColor: primary.withOpacity(0.4),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                     ),
//                                     child: _isSaving
//                                         ? const SizedBox(
//                                             width: 22,
//                                             height: 22,
//                                             child: CircularProgressIndicator(
//                                               color: Colors.white,
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                         : Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               const Icon(Icons.check_circle,
//                                                   color: Colors.white, size: 20),
//                                               const SizedBox(width: 8),
//                                               Text(
//                                                 context.tr.saveChanges,
//                                                 style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   // ---------- Cover image with overlay + edit badge ----------
//   Widget _buildCoverImage(Color primary) {
//     final hasBanner = _pickedBanner != null ||
//         (_currentProfile?.banner != null &&
//             _currentProfile!.banner!.isNotEmpty);

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // Base gradient
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [primary, primary.withOpacity(0.7)],
//             ),
//           ),
//         ),
//         // Banner image
//         if (hasBanner)
//           _pickedBanner != null
//               ? Image.file(_pickedBanner!, fit: BoxFit.cover)
//               : Image.network(
//                   _currentProfile!.banner!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                 ),
//         // Dark gradient overlay for readability
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black.withOpacity(0.35),
//                 Colors.black.withOpacity(0.05),
//                 Colors.black.withOpacity(0.45),
//               ],
//               stops: const [0.0, 0.5, 1.0],
//             ),
//           ),
//         ),
//         // Empty-state hint
//         if (!hasBanner)
//           const Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.add_photo_alternate_outlined,
//                     color: Colors.white70, size: 42),
//                 SizedBox(height: 6),
//                 Text('Add cover picture',
//                     style: TextStyle(color: Colors.white70, fontSize: 13)),
//               ],
//             ),
//           ),
//         // Edit cover button
//         Positioned(
//           right: 16,
//           bottom: 16,
//           child: GestureDetector(
//             onTap: _pickBanner,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.55),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white24),
//               ),
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.camera_alt_outlined,
//                       color: Colors.white, size: 16),
//                   SizedBox(width: 6),
//                   Text('Edit cover',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------- Avatar with overlapping border + camera badge ----------
//   Widget _buildAvatar() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: CircleAvatar(
//               radius: 52,
//               backgroundColor: Colors.grey[200],
//               backgroundImage: _pickedImage != null
//                   ? FileImage(_pickedImage!) as ImageProvider
//                   : (_currentProfile?.picture != null &&
//                           _currentProfile!.picture!.isNotEmpty
//                       ? NetworkImage(_currentProfile!.picture!)
//                       : const NetworkImage('https://i.pravatar.cc/300')),
//               onBackgroundImageError: (_, __) {},
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(right: 4, bottom: 4),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: const Icon(Icons.camera_alt,
//                 color: Colors.white, size: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------- Section card ----------
//   Widget _buildSectionCard({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//             child: Row(
//               children: [
//                 Icon(icon, size: 18, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1F2937),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ...children,
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() => Divider(
//         height: 1,
//         thickness: 1,
//         indent: 16,
//         endIndent: 16,
//         color: Colors.grey[100],
//       );

//   Widget _buildErrorView(Color primary) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 60, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(_errorMessage!,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _fetchBusinessTypes();
//                 _fetchProfile();
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: primary),
//               child: const Text('Retry',
//                   style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------- Business Type field ----------
//   Widget _buildBusinessTypeField() {
//     return InkWell(
//       onTap: _isLoadingTypes ? null : _openBusinessTypePicker,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             if (_selectedBusinessType != null) ...[
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: _selectedBusinessType!.colorValue,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   _iconForName(_selectedBusinessType!.icon),
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 12),
//             ],
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Type Business',
//                     style: TextStyle(fontSize: 12, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     _selectedBusinessType?.name ??
//                         (_typeBusinessController.text.isNotEmpty
//                             ? _typeBusinessController.text
//                             : 'Select a category'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: _selectedBusinessType == null &&
//                               _typeBusinessController.text.isEmpty
//                           ? Colors.grey
//                           : const Color(0xFF1F2937),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_isLoadingTypes)
//               const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             else
//               const Icon(Icons.keyboard_arrow_down_rounded,
//                   color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _iconForName(String name) {
//     const map = {
//       'palette': Icons.palette,
//       'directions_car': Icons.directions_car,
//       'movie': Icons.movie,
//       'checkroom': Icons.checkroom,
//       'account_balance': Icons.account_balance,
//       'yard': Icons.yard,
//       'hotel': Icons.hotel,
//       'pets': Icons.pets,
//       'home_work': Icons.home_work,
//       'fitness_center': Icons.fitness_center,
//       'computer': Icons.computer,
//       'flight': Icons.flight,
//     };
//     return map[name] ?? Icons.category;
//   }

//   Widget _buildInputField({
//     required String label,
//     required TextEditingController controller,
//     IconData? suffixIcon,
//     Color? iconColor,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 12, color: Colors.black54),
//           ),
//           const SizedBox(height: 4),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: controller,
//                   keyboardType: keyboardType,
//                   validator: validator,
//                   maxLines: maxLines,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(vertical: 6),
//                   ),
//                   style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF1F2937)),
//                 ),
//               ),
//               if (suffixIcon != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: Icon(suffixIcon, color: iconColor, size: 20),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ==========================================================
// //  Bottom sheet with search input for business types
// // ==========================================================
// class _BusinessTypeSearchSheet extends StatefulWidget {
//   final List<BusinessType> types;
//   final BusinessType? selected;

//   const _BusinessTypeSearchSheet({
//     required this.types,
//     this.selected,
//   });

//   @override
//   State<_BusinessTypeSearchSheet> createState() =>
//       _BusinessTypeSearchSheetState();
// }

// class _BusinessTypeSearchSheetState extends State<_BusinessTypeSearchSheet> {
//   late TextEditingController _searchController;
//   late List<BusinessType> _filtered;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _filtered = widget.types;
//     _searchController.addListener(_onSearch);
//   }

//   void _onSearch() {
//     final query = _searchController.text.toLowerCase().trim();
//     setState(() {
//       _filtered = query.isEmpty
//           ? widget.types
//           : widget.types
//               .where((t) => t.name.toLowerCase().contains(query))
//               .toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearch);
//     _searchController.dispose();
//     super.dispose();
//   }

//   IconData _iconFor(String name) {
//     const map = {
//       'palette': Icons.palette,
//       'directions_car': Icons.directions_car,
//       'movie': Icons.movie,
//       'checkroom': Icons.checkroom,
//       'account_balance': Icons.account_balance,
//       'yard': Icons.yard,
//       'hotel': Icons.hotel,
//       'pets': Icons.pets,
//       'home_work': Icons.home_work,
//       'fitness_center': Icons.fitness_center,
//       'computer': Icons.computer,
//       'flight': Icons.flight,
//     };
//     return map[name] ?? Icons.category;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.78,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 10, bottom: 6),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 6),
//             child: Text(
//               'Select Business Type',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: TextField(
//               controller: _searchController,
//               autofocus: false,
//               decoration: InputDecoration(
//                 hintText: 'Search category...',
//                 prefixIcon: const Icon(Icons.search, size: 20),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, size: 20),
//                         onPressed: () => _searchController.clear(),
//                       )
//                     : null,
//                 filled: true,
//                 fillColor: const Color(0xFFF3F4F6),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const Divider(height: 1),
//           Expanded(
//             child: _filtered.isEmpty
//                 ? const Center(
//                     child: Text('No categories found',
//                         style: TextStyle(color: Colors.grey)),
//                   )
//                 : ListView.builder(
//                     padding: EdgeInsets.only(bottom: bottomInset + 8),
//                     itemCount: _filtered.length,
//                     itemBuilder: (context, index) {
//                       final type = _filtered[index];
//                       final isSelected = widget.selected?.id == type.id;
//                       return ListTile(
//                         leading: Container(
//                           width: 42,
//                           height: 42,
//                           decoration: BoxDecoration(
//                             color: type.colorValue,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             _iconFor(type.icon),
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                         title: Text(
//                           type.name,
//                           style: TextStyle(
//                             fontWeight: isSelected
//                                 ? FontWeight.bold
//                                 : FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: Text(
//                           type.description,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         trailing: isSelected
//                             ? Icon(Icons.check_circle,
//                                 color: Theme.of(context).primaryColor)
//                             : null,
//                         onTap: () => Navigator.pop(context, type),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:ballon/createprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';

// --- Business Type Model ---
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

// --- Profile Model ---
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

  late final String apiUrl;
  static const String _baseUrl = 'http://192.168.1.115:8000 ';

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

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _pickedImage = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _pickBanner() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _pickedBanner = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick banner: $e')),
      );
    }
  }

  Future<void> _openBusinessTypePicker() async {
    final selected = await showModalBottomSheet<BusinessType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

      request.fields['name'] = _nameController.text;
      if (_selectedBusinessType != null) {
        request.fields['type_business'] = _selectedBusinessType!.id.toString();
      }
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneController.text;
      request.fields['place'] = _locationController.text;
      request.fields['bio'] = _bioController.text;

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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCreating
                ? 'Profile created successfully!'
                : 'Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(
            'Failed to save. Status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSaving = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    // Cover height — fixed, predictable, looks great on all screen sizes
    const double coverHeight = 200;
    // Avatar radius
    const double avatarRadius = 56;
    // How far the avatar overlaps down from the cover
    const double avatarOverlap = 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _currentProfile == null
              ? _buildErrorView(primary)
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ==================================================
                    // COVER (banner) — fixed height SliverAppBar
                    // ==================================================
                    SliverAppBar(
                      expandedHeight: coverHeight,
                      pinned: true,
                      stretch: true,
                      elevation: 0,
                      scrolledUnderElevation: 2,
                      backgroundColor: primary,
                      leadingWidth: 60,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _circleIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 8),
                          child: _isSaving
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : _circleIconButton(
                                  icon: Icons.check_rounded,
                                  onTap: _saveProfile,
                                  size: 20,
                                ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: _buildCoverImage(primary),
                        stretchModes: const [
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                        ],
                      ),
                    ),

                    // ==================================================
                    // Avatar + name + form — one smooth content block
                    // ==================================================
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // ---------- Avatar overlapping the cover ----------
                          SizedBox(
                            height: avatarOverlap,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                // Avatar shifted up by radius so half is on the cover
                                Positioned(
                                  top: -avatarRadius,
                                  child: _buildAvatar(avatarRadius),
                                ),
                              ],
                            ),
                          ),

                          // ---------- Name + hint ----------
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                            child: Column(
                              children: [
                                Text(
                                  _currentProfile?.name?.isNotEmpty == true
                                      ? _currentProfile!.name!
                                      : 'Business Profile',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
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

                          // ---------- Form ----------
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSectionCard(
                                    title: 'Business Info',
                                    icon: Icons.storefront_outlined,
                                    children: [
                                      _buildInputField(
                                        label: context.tr.fullName,
                                        controller: _nameController,
                                        validator: (val) => val!.isEmpty
                                            ? 'Name cannot be empty'
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
                                    title: 'Contact',
                                    icon: Icons.contact_mail_outlined,
                                    children: [
                                      _buildInputField(
                                        label: context.tr.email,
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (val) => !val!.contains('@')
                                            ? 'Enter a valid email'
                                            : null,
                                      ),
                                      _buildDivider(),
                                      _buildInputField(
                                        label: context.tr.phoneNumber,
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                      ),
                                      _buildDivider(),
                                      _buildInputField(
                                        label: context.tr.location,
                                        controller: _locationController,
                                        suffixIcon:
                                            Icons.location_on_outlined,
                                        iconColor: Colors.grey,
                                      ),
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
                                        shadowColor: primary.withOpacity(0.35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: _isSaving
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
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
                                                    fontWeight: FontWeight.bold,
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
                  ],
                ),
    );
  }

  // ==========================================================
  //  COVER IMAGE — clean full-bleed banner with subtle shading
  // ==========================================================
  Widget _buildCoverImage(Color primary) {
    final hasBanner = _pickedBanner != null ||
        (_currentProfile?.banner != null &&
            _currentProfile!.banner!.isNotEmpty);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient (behind the image / when no image)
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

        // Banner image
        if (hasBanner)
          _pickedBanner != null
              ? Image.file(
                  _pickedBanner!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Image.network(
                  _currentProfile!.banner!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),

        // Soft gradient overlay — only at top & bottom for readability.
        // Much lighter than before so the banner stays visible.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.30),
                Colors.transparent,
                Colors.black.withOpacity(0.25),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),

        // Empty-state hint (only when no banner)
        if (!hasBanner)
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.white70, size: 40),
                SizedBox(height: 8),
                Text(
                  'Add cover picture',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // "Edit cover" chip — bottom-left (mirrors avatar on the right)
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 15),
                  SizedBox(width: 6),
                  Text(
                    'Edit cover',
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
  //  AVATAR — clean circle with white ring + shadow + camera badge
  // ==========================================================
  Widget _buildAvatar(double radius) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // White ring + shadow wrapper
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
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

          // Camera badge
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
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  //  Small round translucent button for the app bar
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

  // ---------- Section card ----------
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
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

  Widget _buildErrorView(Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchBusinessTypes();
                _fetchProfile();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Business Type field ----------
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
                  const Text(
                    'Type Business',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _selectedBusinessType?.name ??
                        (_typeBusinessController.text.isNotEmpty
                            ? _typeBusinessController.text
                            : 'Select a category'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _selectedBusinessType == null &&
                              _typeBusinessController.text.isEmpty
                          ? Colors.grey
                          : const Color(0xFF1F2937),
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
            style: const TextStyle(fontSize: 12, color: Colors.black54),
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
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937)),
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
//  Bottom sheet with search input for business types
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
      decoration: const BoxDecoration(
        color: Colors.white,
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Select Business Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search category...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
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
                    child: Text('No categories found',
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