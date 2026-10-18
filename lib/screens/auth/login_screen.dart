import 'dart:convert';
import 'dart:ui';
import 'package:ballon/main.dart';
import 'package:ballon/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDarkMode = true;
  bool rememberMe = true;
  bool obscurePassword = true;
  // late ScaffoldMessengerState scaffoldMessenger;
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    final name = nameController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(context.tr.pleaseEnterUsernameAndPassword),
        ),
      );
      return;
    }

    // TODO: Connect your Laravel/Django API here.
  }
void loginTest() async {
    try {
      Response response = await post(
          Uri.parse('https://qopera.app/prof/api/login/'),
          body: {
            'username': nameController.text,
            'password': passwordController.text
          });
          
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', data['token']);
        localStorage.setString('username', nameController.text);
        localStorage.setInt('value', 1);
        
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text( context.tr.loginSuccessfully)));
            
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QoperaApp(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text("Check Internet Connection Or incorrect username & password" )));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An error occurred. Please try again.")));
      print(e.toString());
    }
  }
   bool _isGoogleLoading = false;

  // The Web Client ID from Google Cloud Console (NOT the Android one)
  static const String _webClientId =
      '123456789012-abc...apps.googleusercontent.com';

  // Your backend base URL — use ngrok here for testing on a physical device
  static const String _apiBase = 'https://a8-197-186-74-6.ngrok-free.app';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Required on Android if you want the ID token to match your web client
    serverClientId: _webClientId,
  );

  // ==================== GOOGLE SIGN IN ====================
  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      // 1. Show Google account picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        setState(() => _isGoogleLoading = false);
        return;
      }

      // 2. Get auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        _showError('Failed to get ID token from Google.');
        setState(() => _isGoogleLoading = false);
        return;
      }

      // 3. Send ID token to your Django backend
      final response = await http.post(
        Uri.parse('$_apiBase/prof/api/auth/google/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;

        // 4. Store the token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('username', data['username'] ?? '');
        await prefs.setString('email', data['email'] ?? '');

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      } else {
        final body = jsonDecode(response.body);
        _showError(body['detail'] ?? 'Google login failed.');
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final dark =  Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark
          ? const Color(0xFF050B18)
          : const Color(0xFFF8FAFF),
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Image.asset(
              'assets/img/restaurant_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Background overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 430,
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
              child:  ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Keeps it looking good on tablets
              child: Form(
                key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                  
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
                      //         color: dark
                      //             ? Colors.white24
                      //             : Colors.blue.shade100,
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
                      //         color: dark
                      //             ? Colors.white
                      //             : const Color(0xFF0755C9),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                  
                      const SizedBox(height: 25),
                  
                      // Logo
                      Image.asset(
                        'assets/img/menuscan_logo.png',
                        width: 230,
                        height: 230,
                        fit: BoxFit.contain,
                      ),
                  
                      const SizedBox(height: 15),
                  
                      // Welcome
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                         context.tr.welcomeBack,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: dark
                                ? Colors.white
                                : const Color(0xFF123D91),
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 6),
                  
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(context.tr.loginSubtitle,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: dark
                                ? Colors.white70
                                : const Color(0xFF60799F),
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 25),
                  
                      // Email / phone
                      _inputField(
                        controller: nameController,
                        hint: context.tr.username,
                        icon: Icons.person_outline_rounded,
                        dark: dark,
                      ),
                  
                      const SizedBox(height: 14),
                  
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
                            color: dark
                                ? Colors.white60
                                : const Color(0xFF52709F),
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 10),
                  
                      // Remember / Forgot
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            activeColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                  
                          Text(
                             context.tr.rememberMe,
                            style: TextStyle(
                              color: dark
                                  ? Colors.white70
                                  : const Color(0xFF31547D),
                            ),
                          ),
                  
                          const Spacer(),
                  
                          TextButton(
                            onPressed: () {
                              // TODO: Forgot password
                            },
                            child: Text(
                               context.tr.forgotPassword,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                      const SizedBox(height: 8),
                  
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed:(){ loginTest(); },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor:
                                Theme.of(context).primaryColor.withOpacity(.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                 context.tr.login,
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
                  
                      const SizedBox(height: 22),
                  
                      // OR divider
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         color: dark ? Colors.white24 : Colors.blueGrey.shade200,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding:
                      //            EdgeInsets.symmetric(horizontal: 15),
                      //       child: Text(
                      //          context.tr.or,
                      //         style: TextStyle(
                      //           color: dark
                      //               ? Colors.white60
                      //               : Colors.blueGrey,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         color: dark ? Colors.white24 : Colors.blueGrey.shade200,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                  
                      // const SizedBox(height: 18),
                  
                      // Google button
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 55,
                      //   child: OutlinedButton(
                      //     onPressed: () {
                      //       // TODO: Google authentication
                      //     },
                      //     style: OutlinedButton.styleFrom(
                      //       side: BorderSide(
                      //         color: dark
                      //             ? const Color(0xFF4D9EFF)
                      //             : const Color(0xFF9DBBE5),
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(18),
                      //       ),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         // Simple Google-style icon
                      //         Container(
                      //           width: 25,
                      //           height: 25,
                      //           alignment: Alignment.center,
                      //           child: const Text(
                      //             'G',
                      //             style: TextStyle(
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.blue,
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Text(
                      //            context.tr.continueWithGoogle,
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w600,
                      //             color: dark
                      //                 ? Colors.white
                      //                 : const Color(0xFF123D91),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    
          //            SizedBox(
          //   width: double.infinity,
          //   height: 55,
          //   child: OutlinedButton(
          //     onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
          //     style: OutlinedButton.styleFrom(
          //       side: BorderSide(
          //         color: dark
          //             ? const Color(0xFF4D9EFF)
          //             : const Color(0xFF9DBBE5),
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(18),
          //       ),
          //     ),
          //     child: _isGoogleLoading
          //         ? const SizedBox(
          //             width: 22,
          //             height: 22,
          //             child: CircularProgressIndicator(strokeWidth: 2),
          //           )
          //         : Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 width: 25,
          //                 height: 25,
          //                 alignment: Alignment.center,
          //                 child: const Text(
          //                   'G',
          //                   style: TextStyle(
          //                     fontSize: 23,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.blue,
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(width: 12),
          //               Text(
          //                 context.tr.continueWithGoogle,
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w600,
          //                   color: dark
          //                       ? Colors.white
          //                       : const Color(0xFF123D91),
          //                 ),
          //               ),
          //             ],
          //           ),
          //   ),
          // ),
                  
                      const SizedBox(height: 25),
                  
                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                             context.tr.dontHaveAccount,
                            style: TextStyle(
                              color: dark
                                  ? Colors.white60
                                  : const Color(0xFF60799F),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Sign up
                            },
                            child:  GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                context.tr.signUp,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF101D32).withOpacity(.92)
            : Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(10),
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
        style: TextStyle(
          color: dark ? Colors.white : const Color(0xFF172D4D),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: dark
                ? Colors.white54
                : const Color(0xFF7890B2),
          ),
          prefixIcon: Icon(
            icon,
            color: dark
                ? const Color(0xFF73B4FF)
                : const Color(0xFF0755C9),
          ),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}