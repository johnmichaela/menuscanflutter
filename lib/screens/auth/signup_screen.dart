import 'dart:ui';
import 'package:ballon/main.dart';
import 'package:ballon/screens/auth/login_screen.dart';
import 'package:ballon/screens/sub/profile/createprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isDarkMode = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeToTerms = false;
  bool isLoading = false;
 
  // late ScaffoldMessengerState scaffoldMessenger;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? _token='';
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
    if (_token!.isNotEmpty && _token!=null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QoperaApp(),
          ),
        );

    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
Future<void> register(String username, email, password, password1) async {
    print(username + email + password + password1);
    final http.Response response = await http.post(
      Uri.parse("https://qopera.app/api/register/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // ignore: prefer_interpolation_to_compose_strings
        // 'authorization': 'Token ' + tokein().toString(),
      },
      body: jsonEncode(<dynamic, String>{
        // "pk": pk,
        // "user": user,
        'email': email,
        'password': password,
        'username': username,
        'password1': password1
      }),
    );
    Map<String, dynamic> resposne = jsonDecode(response.body);
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      // Map<String, dynamic> resposne = jsonDecode(response.body);
      // if (!resposne['error']) {
      // Map<String, dynamic> user = resposne['data'];
      // print(" User name ${user['data']}");
      // scaffoldMessenger.showSnackBar(
      //     const SnackBar(content: Text("Successful Account created")));
      // savePref(1, user['username'], user['email'], user['id']);
      // ignore: use_build_context_synchronously
      loginTest();
      // Navigator.pushReplacementNamed(context, "/signin");
      
      // } else {
      //   print(" ${resposne['message']}");
      //   scaffoldMessenger
      //       .showSnackBar(SnackBar(content: Text("${resposne['message']}")));
      // }
      // return Profile.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print('errrrrorr');
      print(" ${resposne['message']}");
      print(response.body);
      // scaffoldMessenger.showSnackBar(SnackBar(content: Text(response.body)));
      // scaffoldMessenger
      //     .showSnackBar(const SnackBar(content: Text("TRy again")));
      // print('data is:' + views.toString());
      throw Exception('Failed to send views');
    }
  }

  void loginTest() async {
    try {
      http.Response response = await http.post(
          Uri.parse('https://qopera.app/prof/api/login/'),
          body: {
            'username': nameController.text,
            'password': passwordController.text
            // 'email' : 'eve.holt@reqres.in',
            // 'password' : 'cityslicka'
          });
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', data['token']);
        localStorage.setString('username', nameController.text);
        // localStorage.setString('usernameget', usernameController.text);
        localStorage.setInt('value', 1);
        print(data['token']);
        print(data);
        print('Login successfully');
        // getJsonData();
        // ignore: deprecated_member_use
        // // localStorage.commit();
        // savePref(1, data['user'], data['email'], data['id']);
        // print('${localStorage.getInt('value')} Values of login');
        // Navigator.pushReplacementNamed(context, "/home");
        // getJsonMe();
        // ignore: use_build_context_synchronously
        // scaffoldMessenger.showSnackBar(SnackBar(
        //     content: Text(
        //         "Login Successfully ")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfileScreen(),
          ),
        );
      } else {
        print('failed');
        // scaffoldMessenger.showSnackBar(SnackBar(
        //     content: Text(
        //         "Check Internet Connection Or incorrect username & password ")));
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    // final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (name.isEmpty) {
      _showSnackBar('Please enter your full name');
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    // if (phone.isEmpty || phone.length < 10) {
    //   _showSnackBar('Please enter a valid phone number');
    //   return;
    // }

    if (password.isEmpty || password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (!agreeToTerms) {
      _showSnackBar('Please agree to the Terms & Conditions');
      return;
    }

    setState(() => isLoading = true);

    try {
      // Update this URL to match your backend API
      final response = await http.post(
        Uri.parse('https://qopera.app/prof/api/register/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          // 'phone': phone,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Save token if returned
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
        }

        _showSnackBar('Account created successfully!', isError: false);
        
        // Navigate to login or home
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = 'Registration failed';
        
        if (data['errors'] != null) {
          // Handle validation errors
          final errors = data['errors'] as Map<String, dynamic>;
          final errorList = errors.values.map((e) => e.toString()).toList();
          errorMessage = errorList.join('\n');
        } else if (data['message'] != null) {
          errorMessage = data['message'];
        }
        
        _showSnackBar(errorMessage);
      }
    } catch (e) {
      print('Error: $e');
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    // final dark = isDarkMode;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF050B18) : const Color(0xFFF8FAFF),
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Image.asset(
              'assets/img/restaurant_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: dark ? Colors.blueGrey[900] : Colors.blueGrey[100],
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
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
            height: 380,
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
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: dark
                  //           ? Colors.white.withOpacity(.10)
                  //           : Colors.white.withOpacity(.85),
                  //       borderRadius: BorderRadius.circular(30),
                  //       border: Border.all(
                  //         color: dark ? Colors.white24 : Colors.blue.shade100,
                  //       ),
                  //     ),
                  //     child: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           isDarkMode = !isDarkMode;
                  //         });
                  //       },
                  //       icon: Icon(
                  //         dark
                  //             ? Icons.light_mode_rounded
                  //             : Icons.dark_mode_rounded,
                  //         color: dark ? Colors.white : Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 5),

                  // Logo
                  Image.asset(
                    'assets/img/menuscan_logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 120,
                      height: 120,
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Welcome
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                       context.tr.createAccount,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : const Color(0xFF123D91),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text( context.tr.signupSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: dark ? Colors.white70 : const Color(0xFF60799F),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Full Name
                  _inputField(
                    controller: nameController,
                    hint: context.tr.fullName,
                    icon: Icons.person_outline_rounded,
                    dark: dark,
                  ),

                  const SizedBox(height: 12),

                  // Email
                  _inputField(
                    controller: emailController,
                    hint:  context.tr.emailAddress,
                    icon: Icons.email_outlined,
                    dark: dark,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 12),

                  // Phone
                  // _inputField(
                  //   controller: phoneController,
                  //   hint: 'Phone Number',
                  //   icon: Icons.phone_outlined,
                  //   dark: dark,
                  //   keyboardType: TextInputType.phone,
                  // ),

                  // const SizedBox(height: 12),

                  // Password
                  _inputField(
                    controller: passwordController,
                    hint: context.tr.password,
                    icon: Icons.lock_outline_rounded,
                    dark: dark,
                    obscureText: obscurePassword,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: dark ? Colors.white60 : const Color(0xFF52709F),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Confirm Password
                  _inputField(
                    controller: confirmPasswordController,
                    hint:  context.tr.confirmPassword,
                    icon: Icons.lock_outline_rounded,
                    dark: dark,
                    obscureText: obscureConfirmPassword,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: dark ? Colors.white60 : const Color(0xFF52709F),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Terms and Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        activeColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) {
                          setState(() {
                            agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: dark ? Colors.white70 : const Color(0xFF31547D),
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(text: context.tr.agreeToTerms),
                              TextSpan(
                                text: 'Terms & Conditions' ,
                                style:  TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text:  context.tr.privacyPolicy,
                                style:  TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:()=> isLoading ? null : register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Theme.of(context).primaryColor.withOpacity(.35),
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                   context.tr.signUp,
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

                  const SizedBox(height: 18),

                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: dark ? Colors.white24 : Colors.blueGrey.shade200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          context.tr.or,
                          style: TextStyle(
                            color: dark ? Colors.white60 : Colors.blueGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: dark ? Colors.white24 : Colors.blueGrey.shade200,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Google button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Google authentication
                        _showSnackBar( context.tr.googleSignUpComingSoon, isError: false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: dark
                              ? Theme.of(context).primaryColor
                              : const Color(0xFF9DBBE5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            child: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.tr.continueWithGoogle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: dark ? Colors.white : const Color(0xFF123D91),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( context.tr.alreadyHaveAccount,
                        style: TextStyle(
                          color: dark ? Colors.white60 : const Color(0xFF60799F),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child:  Text(
                         context.tr.login,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool dark,
    bool obscureText = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF101D32).withOpacity(.92)
            : Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark
              ? Theme.of(context).primaryColor
              : const Color.fromARGB(255, 208, 222, 241),
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
        keyboardType: keyboardType,
        style: TextStyle(
          color: dark ? Colors.white : const Color.fromARGB(255, 23, 51, 77),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: dark ? Colors.white54 : const Color(0xFF7890B2),
          ),
          prefixIcon: Icon(
            icon,
            color: dark ? const Color(0xFF73B4FF) : const Color.fromARGB(255, 9, 123, 199),
          ),
          suffixIcon: suffix,
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