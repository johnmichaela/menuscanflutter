// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:ballon/input.dart';
// import 'package:ballon/main.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   LoginScreen({
//     super.key,
//   });

//   // final String title;

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   late ScaffoldMessengerState scaffoldMessenger;
//   final TextEditingController _pwdController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   savePref(int value, String username, String email, int id) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     preferences.setInt("value", value);
//     preferences.setString("username", username);
//     preferences.setString("email", email);
//     preferences.setString("id", id.toString());
//     // ignore: deprecated_member_use
//     preferences.commit();
//   }

// //   List<MeModel> _list = [];
// //   Future<List<MeModel?>?> getJsonstore() async {
// //     final prefs = await SharedPreferences.getInstance();

// //     final response = await http.get(
// //       Uri.parse('https://asascaller.pythonanywhere.com/api/me'),
// //       headers: {
// //         HttpHeaders.authorizationHeader: 'Token ${prefs.getString('token')}',
// //         'Content-Type': 'application/json;charset=UTF-8',
// //         'Accept': '*/*',
// //         'Allow': 'GET, OPTIONS',
// //         'Accept-Encoding': 'gzip, deflate, br',
// //         // 'Content-Type': 'application/json',
// //         // 'Accept': 'application/json',
// //         // 'Authorization': 'Token ${tokein()}',
// //       },
// //     );
// //     // valId = prefs.getInt("profid")!.toInt();
// //     if (response.statusCode == 200) {
// //       // If the call to the server was successful, parse the JSON
// //       // Map<String, dynamic> values = <String, dynamic>{};
// //       List<dynamic> values = [];
// //       // values = json
// //       //     .decode(response.body)
// //       //     .map<HashMap<String, dynamic>>(
// //       //         (e) => HashMap<String, dynamic>.from(e))
// //       //     .toList();
// //       // values = Map<String, dynamic>.from(json.decode(response.body));
// //       // List<dynamic> value = values!["result"];
// //       // print(value);
// // //  Map<String, dynamic> resposne = jsonDecode(response.body);
// //       if (response.statusCode == 200) {
// //         var map = jsonDecode(response.body.toString());

// //         print(response.body);
// //         print(values);
// //         if (values.isNotEmpty) {
// //           setState(() async {
// //             for (int i = 0; i < values.length; i++) {
// //               if (values[i] != null) {
// //                 Map<String, dynamic> map = values[i];
// //                 // _list!.add(MeModel.fromJson(map));
// //                 // debugPrint('Id-------${map} ${_list}');
// //                 SharedPreferences localStorage =
// //                     await SharedPreferences.getInstance();
// //                 localStorage.setString('profid', map['id']);
// //                 localStorage.setString('userid', map['user']);
// //                 localStorage.setString('dp', map['dp']);
// //                 localStorage.setString('name', map['name']);
// //                 print('profid' + map['id']);
// //                 print('userid' + map['user']);
// //                 print('dp' + map['dp']);
// //                 // localStorage.setString('profid', map['id']);
// //                 // localStorage.setString('userid', map['user']);
// //                 // localStorage.setString('username', usernameController.text);
// //                 // adminCheck = map['role'];
// //                 // globalgroup = map['group']['name'];
// //                 // print(globalgroup);
// //                 // log('data: $_list');
// //               }
// //             }
// //             print('........................... ${_list}');
// //             // loading = false;
// //           });
// //           // valId = prefs.getInt("profid")!.toInt();
// //         }
// //         return _list;
// //       } else {
// //         // print(response.body);
// //         // If that call was not successful, throw an error.
// //         // scaffoldMessenger
// //         //     .showSnackBar(const SnackBar(content: Text("Try again")));
// //         throw Exception('Failed to load post ${response.body}');
// //       }
// //       // valId = prefs.getInt("profid")!.toInt();
// //     }
// //   }

//   //final snackBar = SnackBar(content: Text('email ou mot de passe incorrect'));
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     scaffoldMessenger = ScaffoldMessenger.of(context);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final double r = (175 / 360); //  rapport for web test(304 / 540);
//     final coverHeight = screenWidth * r;
//     bool _pinned = false;
//     bool _snap = false;
//     bool _floating = false;

//     final widgetList = [
//       // Row(
//       //   children: [
//       SizedBox(
//         height: 50,
//       ),
//       // Center(
//       //   // padding: const EdgeInsets.all(10.0),
//       //   child: Text(
//       //     'Login',
//       //     style: TextStyle(
//       //       fontFamily: 'Segoe UI',
//       //       fontSize: 23,
//       //       fontWeight: FontWeight.w500,
//       //       color: const Color(0xff000000),
//       //     ),
//       //     textAlign: TextAlign.left,
//       //   ),
//       // ),
//       // SizedBox(
//       //   height: 50.0,
//       // ),
//       SizedBox(height: MediaQuery.of(context).size.height / 11),
//       // Center(
//       //   child: Container(
//       //     padding: EdgeInsets.all(10),
//       //     decoration: BoxDecoration(
//       //         color: Colors.blue, borderRadius: BorderRadius.circular(90)),
//       //     child: Image.asset(
//       //       'images/flashhh.png',
//       //       // color: Colors.white,
//       //       height: 110,
//       //     ),
//       //   ),
//       // ),
//       // SizedBox(
//       //   height: 25.0,
//       // ),
//        Center(
//             child: Image.asset('assets/img/icon/house.png',height: 100,color: const Color.fromARGB(255, 22, 135, 228),),
//           ),
//       // Center(
//       //   // padding: const EdgeInsets.all(10.0),
//       //   child: Text(
//       //     'Asas',
//       //     style: TextStyle(
//       //         color: Color.fromARGB(255, 42, 145, 73),
//       //         fontSize: 45,
//       //         fontFamily: 'CooperFiveOpti',
//       //         fontWeight: FontWeight.w600),
//       //     textAlign: TextAlign.left,
//       //   ),
//       // ),
//       // Center(
//       //   // padding: const EdgeInsets.all(10.0),
//       //   child: Text(
//       //     'Group of Companies',
//       //     style: TextStyle(
//       //         color: Color.fromARGB(255, 54, 231, 244),
//       //         fontSize: 18,
//       //         fontFamily: 'CooperFiveOpti',
//       //         fontWeight: FontWeight.w500),
//       //     textAlign: TextAlign.left,
//       //   ),
//       // ),

//       SizedBox(
//         height: 150.0,
//       ),
//       // Text(
//       //   'Thenashara',
//       //   style: TextStyle(
//       //     fontFamily: 'Segoe UI',
//       //     fontSize: 40,
//       //     fontWeight: FontWeight.bold,
//       //     color: const Color(0xff000000),
//       //   ),
//       //   textAlign: TextAlign.left,
//       // ),
//       //   ],
//       // ),
//       // SizedBox(height: MediaQuery.of(context).size.height / 8),
//       // Spacer(),
//       Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               InputTextWidget(
//                   controller: usernameController,
//                   labelText: "Enter Username",
//                   icon: Icons.person_outline,
//                   obscureText: false,
//                   keyboardType: TextInputType.emailAddress),
//               SizedBox(
//                 height: 12.0,
//               ),
//               InputTextWidget(
//                   controller: passwordController,
//                   labelText: "Enter Password",
//                   icon: Icons.lock_outline,
//                   obscureText: true,
//                   keyboardType: TextInputType.text),
//               // Padding(
//               //   padding: const EdgeInsets.only(right: 25.0, top: 10.0),
//               //   child: Align(
//               //       alignment: Alignment.topRight,
//               //       child: Material(
//               //         color: Colors.transparent,
//               //         child: InkWell(
//               //           onTap: () {},
//               //           child: Text(
//               //             "",
//               //             style: TextStyle(
//               //                 fontSize: 15,
//               //                 fontWeight: FontWeight.bold,
//               //                 color: Colors.grey[700]),
//               //           ),
//               //         ),
//               //       )),
//               // ),
//               SizedBox(
//                 height: 45.0,
//               ),
//               Container(
//                 height: 55.0,
//                 child: GestureDetector(
//                   onTap: () {
//                     loginTest();
//                     // getJsonstore();
//                     // if (isLoading) {
//                     //   return;
//                     // }
//                     // if (usernameController.text.isEmpty ||
//                     //     passwordController.text.isEmpty) {
//                     //   scaffoldMessenger.showSnackBar(const SnackBar(
//                     //       content: Text("Please Fill all fileds")));
//                     //   return;
//                     // }
//                     // apilogin(usernameController.text,
//                     //     passwordController.text);
//                     // setState(() {
//                     //   isLoading = true;
//                     // });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 30),
//                     decoration: BoxDecoration(
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: Color.fromARGB(255, 170, 170, 170),
//                               offset: const Offset(1.1, 1.1),
//                               blurRadius: 4.0),
//                         ],
//                         color: const Color.fromARGB(255, 22, 135, 228),
//                         // Theme.of(context).primaryColor, // Color(0xffF05945),
//                         borderRadius: BorderRadius.circular(12.0)),
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Sign In",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white, fontSize: 25),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )),
//       SizedBox(
//         height: 15.0,
//       ),
//       // Padding(
//       //   padding: const EdgeInsets.all(15.0),
//       //   child: Row(
//       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //     children: [
//       //     Icon(Icons.home_outlined,size:50),
//       //     Icon(Icons.app_registration_rounded,size:50)
//       //   ],),
//       // ),
//       SizedBox(
//         height: 15.0,
//       ),
//     ];
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         iconTheme:  IconThemeData(color: const Color.fromARGB(255, 22, 135, 228),),
//         // leading: Icon(Icons.arrow_back),
//         backgroundColor: Color.fromARGB(255, 247, 248, 248),
//         elevation: 0.0,
//       ),
//       backgroundColor: Color.fromARGB(255, 248, 248, 248),
//       body: CustomScrollView(
//         slivers: <Widget>[
         
//           SliverToBoxAdapter(
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(),
//                   gradient: LinearGradient(colors: <Color>[
//                     Theme.of(context).primaryColor,
//                     Theme.of(context).primaryColor,
//                   ])),
//               width: screenWidth,
//               height: 25,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Container(
//                     width: screenWidth,
//                     height: 25,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(30.0),
//                         topRight: const Radius.circular(30.0),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//               delegate:
//                   SliverChildBuilderDelegate((BuildContext context, int index) {
//             return widgetList[index];
//           }, childCount: widgetList.length))
//         ],
//       ),
//       bottomNavigationBar: Stack(
//         children: [
          
//            Container(
//             height: 50.0,
//             // color: Color.fromARGB(255, 10, 20, 29),
//             child: Center(
//                 child: Wrap(
//               children: [
//                 Text(
//                   "Powered by RentHome",
//                   style: TextStyle(
//                       color: Color.fromARGB(225, 200, 201, 200), fontWeight: FontWeight.bold),
//                 ),
// //                 Material(
// //                     child: InkWell(
// //                   onTap: () {
// //                     print("sign up tapped");
// //                     // Get.to(SignUpScreen());
// //                     //  GestureDetector(
// // //                                 onTap: () {
// //                     // Navigator.push(
// //                     //   context,
// //                     //   MaterialPageRoute(
// //                     //     builder: (context) => SignUpScreen(),
// //                     //   ),
// //                     // );
// // //                                 },
// //                   },
// //                   child: Text(
// //                     "Sign Up",
// //                     style: TextStyle(
// //                       color: Colors.blue[800],
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 15,
// //                     ),
// //                   ),
// //                 )),
//               ],
//             )),
//           ),
//         ],
//       ),
//     );
//   }
//   // final _list=[];

//   void loginTest() async {
//     try {
//       Response response = await post(
//           Uri.parse('http://192.168.1.115:8000/prof/api/login/'),
//           body: {
//             'username': usernameController.text,
//             'password': passwordController.text
//             // 'email' : 'eve.holt@reqres.in',
//             // 'password' : 'cityslicka'
//           });
//       Map<String, dynamic> resposne = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body.toString());
//         SharedPreferences localStorage = await SharedPreferences.getInstance();
//         localStorage.setString('token', data['token']);
//         localStorage.setString('username', usernameController.text);
//         // localStorage.setString('usernameget', usernameController.text);
//         localStorage.setInt('value', 1);
//         print(data['token']);
//         print(data);
//         print('Login successfully');
//         // getJsonData();
//         // ignore: deprecated_member_use
//         // // localStorage.commit();
//         // savePref(1, data['user'], data['email'], data['id']);
//         // print('${localStorage.getInt('value')} Values of login');
//         // Navigator.pushReplacementNamed(context, "/home");
//         // getJsonMe();
//         // ignore: use_build_context_synchronously
//         scaffoldMessenger.showSnackBar(SnackBar(
//             content: Text(
//                 "Login Successfully ")));
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BalloonApp(),
//           ),
//         );
//       } else {
//         print('failed');
//         scaffoldMessenger.showSnackBar(SnackBar(
//             content: Text(
//                 "Check Internet Connection Or incorrect username & password ")));
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ballon/input.dart'; // Assuming this is your custom TextField widget, or use Flutter's built-in
import 'package:ballon/main.dart';
import 'package:ballon/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your SignUpScreen here if it exists in another file
// import 'package:ballon/signup_screen.dart'; 

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  savePref(int value, String username, String email, int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", value);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("id", id.toString());
    // ignore: deprecated_member_use
    preferences.commit();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Keeps it looking good on tablets
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Branding Section ---
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(
                        'assets/img/logo.png', // Replace with your main logo
                        errorBuilder: (_, __, ___) => 
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.air, size: 50, color: Color(0xFFD32F2F)),
                          ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // Title and Subtitle
                    const Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    
                    const SizedBox(height: 8),

                    const Text(
                      'Sign in to continue discovering amazing events',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- Input Fields ---
                    // Note: If you use Flutter's default InputTextWidget, the styling below is cleaner.
                    // If InputTextWidget is custom, make sure it matches this style.
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username or Email',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                      ),
                    ),

                    // --- Forgot Password ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add forgot password logic here
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Sign In Button ---
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          loginTest();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFFD32F2F).withOpacity(0.4),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- Sign Up Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(), // Replace with your SignUpScreen
                              ),
                            );
                            // Placeholder:
                            // scaffoldMessenger.showSnackBar(
                            //   const SnackBar(content: Text("Navigate to Sign Up Screen"))
                            // );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginTest() async {
    try {
      Response response = await post(
          Uri.parse('http://192.168.1.115:8000/prof/api/login/'),
          body: {
            'username': usernameController.text,
            'password': passwordController.text
          });
          
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', data['token']);
        localStorage.setString('username', usernameController.text);
        localStorage.setInt('value', 1);
        
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text("Login Successfully")));
            
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BalloonApp(),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text("Check Internet Connection Or incorrect username & password")));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}