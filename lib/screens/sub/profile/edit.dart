// import 'package:ballon/createprofile.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io'; // Required for File
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // --- Paste your Profile model here (if not already in the file) ---
// class Profile {
//   final int? pk;
//   final User? user;
//   final String? name;
//   final dynamic activity;
//   final dynamic place;
//   final String? picture;
//   final int? phoneNumber;
//   final String? email;
//   final String? bio;
//   final String? birthday;

//   Profile({
//     required this.pk,
//     required this.user,
//     required this.name,
//     this.activity,
//     this.place,
//     this.picture,
//     this.phoneNumber,
//     this.email,
//     this.bio,
//     this.birthday,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       pk: json['pk'] as int,
//       user: User.fromJson(json['user'] as Map<String, dynamic>),
//       name: json['name'] as String? ?? '',
//       activity: json['activity'],
//       place: json['place'],
//       picture: json['picture'] as String?,
//       phoneNumber: json['phone_number'],
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
//       username: json['username'] as String,
//       email: json['email'] as String? ?? '',
//     );
//   }
// }
// // --- End of model ---

// class EditProfileScreen extends StatefulWidget {
//   final int? id;
//    const EditProfileScreen({super.key, required this.id});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//     late ScaffoldMessengerState scaffoldMessenger;
//   // Controllers
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _locationController;
//   late TextEditingController _bioController;
//   late TextEditingController _usernameController;

//   // Image Picker
//   final ImagePicker _picker = ImagePicker();
//   File? _pickedImage;

//   bool _isLoading = true;
//   bool _isSaving = false;
//   String? _errorMessage;
//   Profile? _currentProfile;

//   // API URL for the specific profile (ID 9)
//   late final String apiUrl = 'https://qopera.app/prof/api-prof/${widget.id}';

//   @override
//   void initState() {
//     super.initState();
//     getJsonData();
//     _fetchProfile();
//   }

//   // Future<void> _fetchProfile() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //     _errorMessage = null;
//   //   });
//   // final prefs = await SharedPreferences.getInstance();
//   // final String? token = prefs.getString('token');
//   //   try {
//   //     final response = await http.get(Uri.parse(apiUrl),
//   //       headers: {
//   //         'Authorization': 'Token $token',
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //     );

//   //     if (response.statusCode == 200) {
//   //       final jsonData = jsonDecode(response.body);
//   //       final profile = Profile.fromJson(jsonData);

//   //       _nameController = TextEditingController(text: profile.name);
//   //       _emailController = TextEditingController(text: profile.email ?? profile.user.email);
//   //       _phoneController = TextEditingController(text: profile.phoneNumber ?? '');
//   //       _locationController = TextEditingController(text: profile.place?.toString() ?? '');
//   //       _bioController = TextEditingController(text: profile.bio ?? '');
//   //       _usernameController = TextEditingController(text: profile.user.username);

//   //       setState(() {
//   //         _currentProfile = profile;
//   //         _isLoading = false;
//   //       });
//   //     } else {
//   //       throw Exception('Failed to load profile. Status: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       _errorMessage = 'Error: $e';
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }
//   Future<void> _fetchProfile() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
    
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
    
//     try {
//       final response = await http.get(Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Token $token',
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
        
//         Profile profile;
        
//         // Handle if API returns a List
//         if (jsonData is List) {
//           print('Received a list of profiles: $jsonData');
//           if (jsonData.isEmpty) {
//             // No profile data found, go to Create
//             _navigateToCreateProfile();
//             return;
//           }
//           profile = Profile.fromJson(jsonData[0] as Map<String, dynamic>);
//         } 
//         // Handle if API returns a Map
//         else if (jsonData is Map<String, dynamic>) {
//           profile = Profile.fromJson(jsonData);
//         } 
//         else {
//           throw Exception('Unexpected data format');
//         }

//         // CHECK IF PK IS NULL OR 0 HERE
//         if (profile.name == null || profile.name == '') {
//           _navigateToCreateProfile();
//           return;
//         }

//         _nameController = TextEditingController(text: profile.name);
//         _emailController = TextEditingController(text: profile.email ?? profile.user!.email);
//         _phoneController = TextEditingController(text: profile.phoneNumber?.toString() ??'');
//         _locationController = TextEditingController(text: profile.place?.toString() ?? '');
//         _bioController = TextEditingController(text: profile.bio ?? '');
//         _usernameController = TextEditingController(text: profile.user!.username);

//         setState(() {
//           _currentProfile = profile;
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load profile. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   // Helper method to navigate to CreateProfileScreen
//   void _navigateToCreateProfile() {
//     // Use addPostFrameCallback to ensure Navigator is ready before rebuilding
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>  CreateProfileScreen(), // Ensure you import your CreateProfileScreen
//           ),
//         );
//       }
//     });
//   }

//  final List<Profile> _list = [];
//   var loading = true;
//   bool view = false;
//   int valId = 0;
//   Future<List<Profile?>> getJsonData() async {
//     final prefs = await SharedPreferences.getInstance();

//     // valId = prefs.getInt("profid")!.toInt();

//     // setState(() {
//     //   valId = prefs.getInt("profid")!.toInt();
//     // });
//     // print(';.................test val ' + valId.toString());
//     final response = await http.get(
//       Uri.parse("https://qopera.app/prof/api-prof/"),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Token ${prefs.getString('token')}',
//         'Content-Type': 'application/json;charset=UTF-8',
//         'Accept': '*/*',
//         'Allow': 'GET, OPTIONS',
//         'Accept-Encoding': 'gzip, deflate, br',
//         // 'Content-Type': 'application/json',
//         // 'Accept': 'application/json',
//         // 'Authorization': 'Token ${tokein()}',
//       },
//     );
//     // valId = prefs.getInt("profid")!.toInt();
//     if (response.statusCode == 200) {
//       // If the call to the server was successful, parse the JSON
//       List<dynamic> values = [];
//       values = json.decode(response.body);
//       print(response.body);
//       if (values.isNotEmpty) {
//         setState(() {
//           for (int i = 0; i < values.length; i++) {
//             if (values[i] != null) {
//               Map<String, dynamic> map = values[i];
//               _list.add(Profile.fromJson(map));
//               debugPrint('Id-------${map['pk']} $_list');
//               saveProfId(map['pk'], map['picture'], map['name']);
//               // log('data: $_list');
//             }
//           }
//           setState(() {
//             loading = false;
//             view = true;
//           });
//         });
//         valId = prefs.getInt("profid")!.toInt();
//       } else {
//         print('shift to edit widget');
//         // ignore: use_build_context_synchronously
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CreateProfileScreen(),
//           ),
//         );
//         // Navigator.push( EditProfileScreen());
//       }
//       return _list;
//     } else {
//       print(response.body);
//       print('change');
//       setState(() {
//         loading = false;
//         view = false;
//       });

//       // If that call was not successful, throw an error.
//       scaffoldMessenger.showSnackBar(SnackBar(content: Text("Try again")));
//       throw Exception('Failed to load post ${response.body}');
//     }
//     // valId = prefs.getInt("profid")!.toInt();
//   }

//   saveProfId(int profid, String pic, name) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     preferences.setInt("profid", profid);
//     preferences.setString("picture", pic);
//     preferences.setString("name", name);
//     // preferences.setString("middlename", middlen);
//     // preferences.setString("surname", surn);
//     // preferences.setString("id", id.toString());
//     // ignore: deprecated_member_use
//     preferences.commit();
//     scaffoldMessenger.showSnackBar(SnackBar(content: Text("Comfirmed")));
//     setState(() {
//       valId = profid;
//     });
//   }

//   // NEW: Function to pick an image
//   Future<void> _pickImage() async {

//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _pickedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: $e')),
//       );
//     }
//   }

//   // UPDATED: Multipart Request to handle file upload
//   Future<void> _saveProfile() async {
//      final prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('token');
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isSaving = true;
//       _errorMessage = null;
//     });

//     try {
//       var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
//        request.headers.addAll({
//     'Authorization': 'Token $token',
//     'Accept': 'application/json',
//     // 'Content-Type': 'application/json', // ❌ REMOVE THIS LINE
//   });

  
//       // Add text fields
//       request.fields['name'] = _nameController.text;
//       request.fields['email'] = _emailController.text;
//       request.fields['phone_number'] = _phoneController.text;
//       request.fields['place'] = _locationController.text;
//       request.fields['bio'] = _bioController.text;
      
//       // Add nested user object (backend dependent)
//       request.fields['user'] = jsonEncode({
//         "username": _usernameController.text,
//         "email": _emailController.text
//       });

//       // Add image file if picked
//       if (_pickedImage != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'picture', // This must match the field name your backend expects (e.g., 'picture', 'profile_pic')
//           _pickedImage!.path,
//         ));
//       }

//       // Send request
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully!')),
//         );
//         Navigator.pop(context, true);
//       } else {
//         throw Exception('Failed to update. Status: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to save: $e';
//       });
//     } finally {
//       setState(() {
//         _isSaving = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _locationController.dispose();
//     _bioController.dispose();
//     _usernameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _isSaving ? null : _saveProfile,
//             child: _isSaving
//                 ? const SizedBox(
//                     width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                 : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null && _currentProfile == null
//               ? Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(_errorMessage!, textAlign: TextAlign.center),
//                         const SizedBox(height: 20),
//                         ElevatedButton(onPressed: _fetchProfile, child: const Text('Retry')),
//                       ],
//                     ),
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // Edit Avatar Section
//                       GestureDetector(
//                         onTap: _pickImage, // Make the avatar clickable
//                         child: Container(
//                           width: double.infinity,
//                           color: const Color(0xFFB71C1C),
//                           padding: const EdgeInsets.only(bottom: 30),
//                           child: Column(
//                             children: [
//                               Stack(
//                                 alignment: Alignment.bottomRight,
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 45,
//                                     // Display picked image or fetched image or fallback
//                                     backgroundImage: _pickedImage != null
//                                         ? FileImage(_pickedImage!)
//                                         : NetworkImage(_currentProfile?.picture ?? 'https://i.pravatar.cc/300'),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFB71C1C), size: 16),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 'Tap on the photo to change',
//                                 style: TextStyle(color: Colors.white70, fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // Form Fields
//                       Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               _buildInputField(
//                                 label: 'Full Name',
//                                 controller: _nameController,
//                                 validator: (val) => val!.isEmpty ? 'Name cannot be empty' : null,
//                               ),
//                               const SizedBox(height: 15),
//                               _buildInputField(
//                                 label: 'Email',
//                                 controller: _emailController,
//                                 validator: (val) => !val!.contains('@') ? 'Enter a valid email' : null,
//                               ),
//                               const SizedBox(height: 15),
//                               _buildInputField(
//                                 label: 'Phone Number',
//                                 controller: _phoneController,
//                                 keyboardType: TextInputType.phone,
//                               ),
//                               const SizedBox(height: 15),
//                               _buildInputField(
//                                 label: 'Location',
//                                 controller: _locationController,
//                                 suffixIcon: Icons.location_on_outlined,
//                                 iconColor: Colors.grey,
//                               ),
//                               const SizedBox(height: 15),
                              
//                               _buildInputField(
//                                 label: 'Bio',
//                                 controller: _bioController,
//                                 maxLines: 3,
//                               ),

//                               const SizedBox(height: 15),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey[300]!),
//                                 ),
//                                 child: ListTile(
//                                   title: const Text('Change Password', style: TextStyle(fontSize: 15)),
//                                   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//                                   onTap: () {},
//                                 ),
//                               ),

//                               if (_errorMessage != null) ...[
//                                 const SizedBox(height: 20),
//                                 Text(
//                                   _errorMessage!,
//                                   style: const TextStyle(color: Colors.red),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],

//                               const SizedBox(height: 30),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: _isSaving ? null : _saveProfile,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFFB71C1C),
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                   ),
//                                   child: _isSaving
//                                       ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
//                                       : const Text(
//                                           'Save Changes',
//                                           style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                                         ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
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
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           const SizedBox(height: 5),
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
//                     contentPadding: EdgeInsets.zero,
//                   ),
//                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               if (suffixIcon != null) Icon(suffixIcon, color: iconColor, size: 20),
//             ],
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

// --- Profile Model with proper null handling ---
class Profile {
  final int? pk; // Changed to nullable
  final User? user; // Changed to nullable
  final String? name; // Changed to nullable
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
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
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

class EditProfileScreen extends StatefulWidget {
  final int? id; // Made nullable
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

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  Profile? _currentProfile;
  int? _profileId;

  // API URL
  late final String apiUrl;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchProfile();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _usernameController = TextEditingController();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      
      // Get profile ID from SharedPreferences if not provided
      _profileId = widget.id ?? prefs.getInt('profid');
      
      if (_profileId == null) {
        // No profile ID found, navigate to create
        _navigateToCreateProfile();
        return;
      }

      apiUrl = 'https://qopera.app/prof/api-prof/$_profileId';
      
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
        print(apiUrl);
        // Handle different response formats
        if (jsonData is List) {
          if (jsonData.isEmpty) {
            // _navigateToCreateProfile();
            return;
          }
          profile = Profile.fromJson(jsonData[0] as Map<String, dynamic>);
        } else if (jsonData is Map<String, dynamic>) {
          profile = Profile.fromJson(jsonData);
        } else {
          throw Exception('Unexpected data format');
        }

        // Check if profile exists
        if (profile.name == null || profile.name!.isEmpty) {
          // _navigateToCreateProfile();
          return;
        }

        // Update controllers with profile data
        _nameController.text = profile.name ?? '';
        _emailController.text = profile.email ?? profile.user?.email ?? '';
        _phoneController.text = profile.phoneNumber?.toString() ?? '';
        _locationController.text = profile.place?.toString() ?? '';
        _bioController.text = profile.bio ?? '';
        _usernameController.text = profile.user?.username ?? '';

        setState(() {
          _currentProfile = profile;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Profile not found, navigate to create
        _navigateToCreateProfile();
      } else {
        throw Exception('Failed to load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
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
          MaterialPageRoute(
            builder: (context) => CreateProfileScreen(),
          ),
        );
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
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
      
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Determine if we're creating or updating
      final bool isCreating = _profileId == null;
      final String url = isCreating 
          ? 'https://qopera.app/prof/api-prof/' 
          : 'https://qopera.app/prof/api-prof/$_profileId';
      
      final String method = isCreating ? 'POST' : 'PUT';
      print(url+method);
      var request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneController.text;
      request.fields['place'] = _locationController.text;
      request.fields['bio'] = _bioController.text;

      // Add nested user object if needed
      // if (_usernameController.text.isNotEmpty) {
      //   request.fields['user'] = jsonEncode({
      //     "username": _usernameController.text,
      //     "email": _emailController.text
      //   });
      // }

      // Add image file if picked
      if (_pickedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'picture',
          _pickedImage!.path,
        ));
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        // Save profile ID if created
        if (isCreating && response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['pk'] != null) {
            await prefs.setInt('profid', data['pk'] as int);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCreating ? 'Profile created successfully!' : 'Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to save. Status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
        title:  Text(
           context.tr.editProfile,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // TextButton(
          //   onPressed: _isSaving ? null : _saveProfile,
          //   child: _isSaving
          //       ? const SizedBox(
          //           width: 20,
          //           height: 20,
          //           child: CircularProgressIndicator(
          //             color: Colors.white,
          //             strokeWidth: 2,
          //           ),
          //         )
          //       : const Text(
          //           '',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          // ),
        ],
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
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
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
                            backgroundColor: const Color(0xFFB71C1C),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      // Edit Avatar Section
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.only(bottom: 30, top: 20),
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
                                          : (_currentProfile?.picture != null
                                              ? NetworkImage(_currentProfile!.picture!)
                                              : const NetworkImage('https://i.pravatar.cc/300')),
                                      onBackgroundImageError: (_, __) {},
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child:  Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text( context.tr.tapPhotoToChange
                              ,
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Form Fields
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                label:  context.tr.fullName,
                                controller: _nameController,
                                validator: (val) => val!.isEmpty ? 'Name cannot be empty' : null,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label:  context.tr.email,
                                controller: _emailController,
                                validator: (val) => !val!.contains('@') ? 'Enter a valid email' : null,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label:  context.tr.phoneNumber,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label:  context.tr.location,
                                controller: _locationController,
                                suffixIcon: Icons.location_on_outlined,
                                iconColor: Colors.grey,
                              ),
                              const SizedBox(height: 15),
                              _buildInputField(
                                label:  context.tr.bio,
                                controller: _bioController,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 15),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(12),
                              //     border: Border.all(color: Colors.grey[300]!),
                              //   ),
                              //   child: ListTile(
                              //     title: const Text(
                              //       'Change Password',
                              //       style: TextStyle(fontSize: 15),
                              //     ),
                              //     trailing: const Icon(
                              //       Icons.chevron_right,
                              //       color: Colors.grey,
                              //     ),
                              //     onTap: () {},
                              //   ),
                              // ),
                              // if (_errorMessage != null) ...[
                              //   const SizedBox(height: 20),
                              //   Text(
                              //     _errorMessage!,
                              //     style: const TextStyle(color: Colors.red),
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ],
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                      :Text(
                                           context.tr.saveChanges,
                                          style: TextStyle(
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
        // border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle( fontSize: 12),
          ),
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
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              if (suffixIcon != null) Icon(suffixIcon, color: iconColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}