import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ballon/createprofile.dart';
import 'package:ballon/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({
    super.key,
  });

  // final String title;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  savePref(int value, String username, String email, int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("id", id.toString());
    // ignore: deprecated_member_use
    preferences.commit();
  }

//   List<MeModel> _list = [];
//   Future<List<MeModel?>?> getJsonstore() async {
//     final prefs = await SharedPreferences.getInstance();

//     final response = await http.get(
//       Uri.parse('https://asascaller.pythonanywhere.com/api/me'),
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
//       // Map<String, dynamic> values = <String, dynamic>{};
//       List<dynamic> values = [];
//       // values = json
//       //     .decode(response.body)
//       //     .map<HashMap<String, dynamic>>(
//       //         (e) => HashMap<String, dynamic>.from(e))
//       //     .toList();
//       // values = Map<String, dynamic>.from(json.decode(response.body));
//       // List<dynamic> value = values!["result"];
//       // print(value);
// //  Map<String, dynamic> resposne = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         var map = jsonDecode(response.body.toString());

//         print(response.body);
//         print(values);
//         if (values.isNotEmpty) {
//           setState(() async {
//             for (int i = 0; i < values.length; i++) {
//               if (values[i] != null) {
//                 Map<String, dynamic> map = values[i];
//                 // _list!.add(MeModel.fromJson(map));
//                 // debugPrint('Id-------${map} ${_list}');
//                 SharedPreferences localStorage =
//                     await SharedPreferences.getInstance();
//                 localStorage.setString('profid', map['id']);
//                 localStorage.setString('userid', map['user']);
//                 localStorage.setString('dp', map['dp']);
//                 localStorage.setString('name', map['name']);
//                 print('profid' + map['id']);
//                 print('userid' + map['user']);
//                 print('dp' + map['dp']);
//                 // localStorage.setString('profid', map['id']);
//                 // localStorage.setString('userid', map['user']);
//                 // localStorage.setString('username', usernameController.text);
//                 // adminCheck = map['role'];
//                 // globalgroup = map['group']['name'];
//                 // print(globalgroup);
//                 // log('data: $_list');
//               }
//             }
//             print('........................... ${_list}');
//             // loading = false;
//           });
//           // valId = prefs.getInt("profid")!.toInt();
//         }
//         return _list;
//       } else {
//         // print(response.body);
//         // If that call was not successful, throw an error.
//         // scaffoldMessenger
//         //     .showSnackBar(const SnackBar(content: Text("Try again")));
//         throw Exception('Failed to load post ${response.body}');
//       }
//       // valId = prefs.getInt("profid")!.toInt();
//     }
//   }

  //final snackBar = SnackBar(content: Text('email ou mot de passe incorrect'));
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;

    final widgetList = [
      // Row(
      //   children: [
      SizedBox(
        height: 50,
      ),
      // Center(
      //   // padding: const EdgeInsets.all(10.0),
      //   child: Text(
      //     'Login',
      //     style: TextStyle(
      //       fontFamily: 'Segoe UI',
      //       fontSize: 23,
      //       fontWeight: FontWeight.w500,
      //       color: const Color(0xff000000),
      //     ),
      //     textAlign: TextAlign.left,
      //   ),
      // ),
      // SizedBox(
      //   height: 50.0,
      // ),
      SizedBox(height: MediaQuery.of(context).size.height / 26),
      // Center(
      //   child: Container(
      //     padding: EdgeInsets.all(10),
      //     decoration: BoxDecoration(
      //         color: Colors.blue, borderRadius: BorderRadius.circular(90)),
      //     child: Image.asset(
      //       'images/flashhh.png',
      //       // color: Colors.white,
      //       height: 110,
      //     ),
      //   ),
      // ),
      // SizedBox(
      //   height: 25.0,
      // ),
       Center(
            child: Image.asset('assets/img/icon/house.png',height: 100,color: const Color.fromARGB(255, 22, 135, 228),),
          ),
      // Center(
      //   // padding: const EdgeInsets.all(10.0),
      //   child: Text(
      //     'Asas',
      //     style: TextStyle(
      //         color: Color.fromARGB(255, 42, 145, 73),
      //         fontSize: 45,
      //         fontFamily: 'CooperFiveOpti',
      //         fontWeight: FontWeight.w600),
      //     textAlign: TextAlign.left,
      //   ),
      // ),
      // Center(
      //   // padding: const EdgeInsets.all(10.0),
      //   child: Text(
      //     'Group of Companies',
      //     style: TextStyle(
      //         color: Color.fromARGB(255, 54, 231, 244),
      //         fontSize: 18,
      //         fontFamily: 'CooperFiveOpti',
      //         fontWeight: FontWeight.w500),
      //     textAlign: TextAlign.left,
      //   ),
      // ),

      SizedBox(
        height: 100.0,
      ),
      // Text(
      //   'Thenashara',
      //   style: TextStyle(
      //     fontFamily: 'Segoe UI',
      //     fontSize: 40,
      //     fontWeight: FontWeight.bold,
      //     color: const Color(0xff000000),
      //   ),
      //   textAlign: TextAlign.left,
      // ),
      //   ],
      // ),
      // SizedBox(height: MediaQuery.of(context).size.height / 8),
      // Spacer(),
      Form(
          key: _formKey,
          child: Column(
            children: [
              InputTextWidget(
                  controller: usernameController,
                  labelText: "Enter Username",
                  icon: Icons.person_outline,
                  obscureText: false,
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 12.0,
              ),
               InputTextWidget(
                  controller: _emailController,
                  labelText: "Enter Email",
                  icon: Icons.person_outline,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(
                height: 12.0,
              ),
               InputTextWidget(
                  controller: password1Controller,
                  labelText: "Enter Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 12.0,
              ),
              InputTextWidget(
                  controller: passwordController,
                  labelText: "Enter comfirm Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                  keyboardType: TextInputType.text),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, top: 10.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 45.0,
              ),
              Container(
                height: 55.0,
                child: GestureDetector(
                  onTap: () {
                      if (usernameController.text.isEmpty) {
                      scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text("Please Enter Name")));
                      return;
                    }
                    // if (!reg.hasMatch(_emailController.text)) {
                    //   scaffoldMessenger.showSnackBar(
                    //       const SnackBar(content: Text("Enter Valid Email")));
                    //   return;
                    // }
                    if (passwordController.text.isEmpty ||
                        passwordController.text.length < 7) {
                      passwordController.text = '';
                      scaffoldMessenger.showSnackBar(const SnackBar(
                          content:
                              Text("Password should be min 8 characters")));
                      return;
                    }
                    register(usernameController.text, _emailController.text,
                        passwordController.text, password1Controller.text);
                    // getJsonstore();
                    // if (isLoading) {
                    //   return;
                    // }
                    // if (usernameController.text.isEmpty ||
                    //     passwordController.text.isEmpty) {
                    //   scaffoldMessenger.showSnackBar(const SnackBar(
                    //       content: Text("Please Fill all fileds")));
                    //   return;
                    // }
                    // apilogin(usernameController.text,
                    //     passwordController.text);
                    // setState(() {
                    //   isLoading = true;
                    // });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color.fromARGB(255, 207, 207, 207),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 4.0),
                        ],
                        color:const Color.fromARGB(255, 22, 135, 228),
                        //  Theme.of(context).primaryColor, // Color(0xffF05945),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromARGB(255, 234, 236, 238), fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
      SizedBox(
        height: 15.0,
      ),
      // Row(children: [
      //   Icon(Icons.home_outlined,size:50),
      //   Icon(Icons.login_rounded,size:50)
      // ],),
      SizedBox(
        height: 15.0,
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 22, 135, 228),),
        backgroundColor: Color.fromARGB(255, 251, 252, 253),
        elevation: 0.0,
      ),
      backgroundColor: Color.fromARGB(255, 248, 249, 250),
      body: CustomScrollView(
        slivers: <Widget>[
         
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(),
                  gradient: LinearGradient(colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ])),
              width: screenWidth,
              height: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return widgetList[index];
          }, childCount: widgetList.length))
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          new Container(
            height: 50.0,
            // color: Color.fromARGB(255, 10, 20, 29),
            child: Center(
                child: Wrap(
              children: [
                Text(
                  "Powered by RentHome",
                  style: TextStyle(
                      color: Color.fromARGB(206, 177, 179, 178), fontWeight: FontWeight.bold),
                ),
//                 Material(
//                     child: InkWell(
//                   onTap: () {
//                     print("sign up tapped");
//                     // Get.to(SignUpScreen());
//                     //  GestureDetector(
// //                                 onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => SignUpScreen(),
//                     //   ),
//                     // );
// //                                 },
//                   },
//                   child: Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       color: Colors.blue[800],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//                 )),
              ],
            )),
          ),
        ],
      ),
    );
  }
  // final _list=[];
 Future<void> register(String username, email, password, password1) async {
    print(username + email + password + password1);
    final http.Response response = await http.post(
      Uri.parse("http://192.168.1.115:8000/api/register/"),
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
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Successful Account created")));
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
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(response.body)));
      // scaffoldMessenger
      //     .showSnackBar(const SnackBar(content: Text("TRy again")));
      // print('data is:' + views.toString());
      throw Exception('Failed to send views');
    }
  }

  void loginTest() async {
    try {
      Response response = await post(
          Uri.parse('http://192.168.1.115:8000/prof/api/login/'),
          body: {
            'username': usernameController.text,
            'password': passwordController.text
            // 'email' : 'eve.holt@reqres.in',
            // 'password' : 'cityslicka'
          });
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', data['token']);
        localStorage.setString('username', usernameController.text);
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
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(
                "Login Successfully ")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfileScreen(),
          ),
        );
      } else {
        print('failed');
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(
                "Check Internet Connection Or incorrect username & password ")));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
