// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:ballon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  bool isDarkMode = true;
  bool isLoading = false;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final TextEditingController activityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  
  File? image;
  String? imageError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    birthdayController.dispose();
    phoneController.dispose();
    // activityController.dispose();
    emailController.dispose();
    placeController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 80,
      );
      
      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
          imageError = null;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        imageError = 'Failed to pick image: $e';
      });
    }
  }

  File? imagex;
  Future pickImagex() async {
    try {
      final imagex = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 50);
      if (imagex == null) return;
      final imageTemp = File(imagex.path);
      setState(() => this.imagex = imageTemp);
      print(imagex.path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> onUploadImage() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      // _showSnackBar('Please enter your full name');
        nameController.text = 'Anonymous'; // Set default name if empty
      return;
    }
    
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      // _showSnackBar('Please enter a valid email address');
      emailController.text = 'example@email.com';
      return;
    }
    
    if (phoneController.text.trim().isEmpty || phoneController.text.length < 10) {
      // _showSnackBar('Please enter a valid phone number');
      phoneController.text = '0000000000'; // Set default phone number if empty
      return;
    }
    
    if (placeController.text.trim().isEmpty) {
      // _showSnackBar('Please enter your location');
      placeController.text = 'Unknown'; // Set default location if empty
      return;
    }
    
    if (image == null) {
      // _showSnackBar('Please select a profile picture');
      // get image from asset('assets/img/restaurant_bg.png');
      
        setState(() {
          // where this file is located, image = File('assets/img/avatar.png');

          image = File('../assets/img/avatar.png');
        });
    
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        _showSnackBar('Please login first');
        setState(() => isLoading = false);
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.115:8000/prof/api-prof/create"),
      );
      
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        'Authorization': 'Token $token',
      };

      request.fields['name'] = nameController.text.trim();
      request.fields['bio'] = bioController.text.trim();
      request.fields['birthday'] = birthdayController.text.trim();
      request.fields['phone_number'] = phoneController.text.trim();
      request.fields['email'] = emailController.text.trim();
      // request.fields['activity'] = activityController.text.trim();
      request.fields['place'] = placeController.text.trim();
      
      request.files.add(
        http.MultipartFile(
          'picture',
          image!.readAsBytes().asStream(),
          image!.lengthSync(),
          filename: image!.path.split('/').last,
        ),
      );
      
      request.headers.addAll(headers);
      
      var res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar('Profile created successfully!', isError: false);
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  BalloonApp()),
        );
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = 'Failed to create profile';
        if (data['message'] != null) {
          errorMessage = data['message'];
        }
        _showSnackBar(errorMessage);
      }
    } catch (e) {
      _showSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onUploadImageDefault() async {
    // Validation
    // if (nameController.text.trim().isEmpty) {
      // _showSnackBar('Please enter your full name');
        nameController.text = 'Anonymous'; // Set default name if empty
    //   return;
    // }
    
    // if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      // _showSnackBar('Please enter a valid email address');
      emailController.text = 'example@email.com';
    //   return;
    // }
    
    // if (phoneController.text.trim().isEmpty || phoneController.text.length < 10) {
      // _showSnackBar('Please enter a valid phone number');
      phoneController.text = '0000000000'; // Set default phone number if empty
    //   return;
    // }
    
    // if (placeController.text.trim().isEmpty) {
      // _showSnackBar('Please enter your location');
      placeController.text = 'Unknown'; // Set default location if empty
    //   return;
    // }
    
    // if (image == null) {
      // _showSnackBar('Please select a profile picture');
      // get image from asset('assets/img/restaurant_bg.png');
      
    //     setState(() {
    //       // where this file is located, image = File('assets/img/avatar.png');

    //       image = File('../assets/img/avatar.png');
    //     });
    
    //   return;
    // }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        _showSnackBar('Please login first');
        setState(() => isLoading = false);
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.115:8000/prof/api-prof/create"),
      );
      
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        'Authorization': 'Token $token',
      };

      request.fields['name'] = nameController.text.trim();
      request.fields['bio'] = bioController.text.trim();
      request.fields['birthday'] = birthdayController.text.trim();
      request.fields['phone_number'] = phoneController.text.trim();
      request.fields['email'] = emailController.text.trim();
      // request.fields['activity'] = activityController.text.trim();
      request.fields['place'] = placeController.text.trim();
      
      // request.files.add(
      //   http.MultipartFile(
      //     'picture',
      //     image!.readAsBytes().asStream(),
      //     image!.lengthSync(),
      //     filename: image!.path.split('/').last,
      //   ),
      // );
      
      request.headers.addAll(headers);
      
      var res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar('Profile created successfully!', isError: false);
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  BalloonApp()),
        );
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = 'Failed to create profile';
        if (data['message'] != null) {
          errorMessage = data['message'];
        }
        _showSnackBar(errorMessage);
      }
    } catch (e) {
      _showSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF050B18) : const Color(0xFFF8FAFF),
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.asset(
              'assets/img/restaurant_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: dark ? Colors.blueGrey[900] : Colors.blueGrey[100],
                child: const Center(
                  child: Icon(
                    Icons.person_add,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),

          // Background overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 330,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: dark
                      ? [
                          Colors.black.withOpacity(.35),
                          const Color(0xFF050B18).withOpacity(.25),
                          const Color(0xFF050B18),
                        ]
                      : [
                          Colors.white.withOpacity(.15),
                          Colors.white.withOpacity(.55),
                          const Color(0xFFF8FAFF),
                        ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Theme switch
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? Colors.white.withOpacity(.10)
                            : Colors.white.withOpacity(.85),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: dark ? Colors.white24 : Colors.blue.shade100,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isDarkMode = !isDarkMode;
                          });
                        },
                        icon: Icon(
                          dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: dark ? Colors.white : const Color(0xFF0755C9),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Profile Picture
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF087CFF),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF087CFF).withOpacity(.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: dark
                                ? const Color(0xFF101D32)
                                : Colors.white,
                            backgroundImage: image != null
                                ? FileImage(image!)
                                : null,
                            child: image == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: dark
                                        ? Colors.white54
                                        : Colors.grey[400],
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap:(){ pickImage();},
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF087CFF),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF087CFF).withOpacity(.4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        imageError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 25),

                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Profile',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : const Color(0xFF123D91),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Complete your profile to get started\n'
                      'and connect with amazing restaurants.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: dark ? Colors.white70 : const Color(0xFF60799F),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Full Name
                  _buildInputField(
                    controller: nameController,
                    hint: 'Enter your full name',
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    dark: dark,
                  ),

                  const SizedBox(height: 12),

                  // Email
                  _buildInputField(
                    controller: emailController,
                    hint: 'Enter your email address',
                    label: 'Email',
                    icon: Icons.email_outlined,
                    dark: dark,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 12),

                  // Phone
                  _buildInputField(
                    controller: phoneController,
                    hint: 'Enter your phone number',
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    dark: dark,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  // Place/Location
                  _buildInputField(
                    controller: placeController,
                    hint: 'Enter your location',
                    label: 'Location',
                    icon: Icons.location_on_outlined,
                    dark: dark,
                  ),

                  const SizedBox(height: 12),

                  // Birthday
                  _buildInputField(
                    controller: birthdayController,
                    hint: 'Select your birth date',
                    label: 'Birth Date',
                    icon: Icons.calendar_today_outlined,
                    dark: dark,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1990),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF087CFF),
                                surface: Color(0xFF1C1C1E),
                                onSurface: Colors.white,
                              ),
                              dialogBackgroundColor: const Color(0xFF1C1C1E),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          birthdayController.text = formattedDate;
                        });
                      }
                    },
                  ),

                  // const SizedBox(height: 12),

                  // // Activity/Job
                  // _buildInputField(
                  //   controller: activityController,
                  //   hint: 'Enter your job or activity',
                  //   label: 'Job & Activity',
                  //   icon: Icons.work_outline_rounded,
                  //   dark: dark,
                  // ),

                  const SizedBox(height: 12),

                  // Bio
                  _buildInputField(
                    controller: bioController,
                    hint: 'Tell us about yourself',
                    label: 'Bio',
                    icon: Icons.edit_note_outlined,
                    dark: dark,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onUploadImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF087CFF),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: const Color(0xFF087CFF).withOpacity(.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create Profile',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Skip for now
                  TextButton(
                    onPressed: () {
                      onUploadImageDefault();
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color: dark ? Colors.white54 : const Color(0xFF60799F),
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    required bool dark,
    bool obscureText = false,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF101D32).withOpacity(.92)
            : Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark
              ? const Color(0xFF38547A)
              : const Color(0xFFD0DEF1),
        ),
        boxShadow: [
          if (!dark)
            BoxShadow(
              color: Colors.blue.withOpacity(.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onTap: onTap,
        style: TextStyle(
          color: dark ? Colors.white : const Color(0xFF172D4D),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: dark ? Colors.white54 : const Color(0xFF7890B2),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: dark ? Colors.white70 : const Color(0xFF7890B2),
            fontSize: 14,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(
            icon,
            color: dark ? const Color(0xFF73B4FF) : const Color(0xFF0755C9),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}