// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
// import 'package:gctc/component/table.dart';
// import 'package:gctc/models/group.dart';
// import 'package:gctc/models/prof.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:gctc/screen/sigup.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Products {
//   final String title;
//   final String discription;

//   Products(this.title, this.discription);
// }

// ignore: must_be_immutable
// class EditProfileScreen extends StatelessWidget {
// EditProfileScreen({Key? key}) : super(key: key);
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key,
      this.country,
      this.id,
      this.email,
      this.firstname,
      this.group,
      this.middlename,
      this.picture,
      this.phone,
      this.surname});
  final int? id;
  final String? group;
  final String? firstname, middlename, surname, phone, country, email, picture;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  DateTime datetime = DateTime.now();
  // final List<GroupL>? _list = [];
  var items = ['Show'];
  late String firstname, middlename, surname;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  StreamSubscription? connection;
  bool isoffline = false;
  String? dropdownvalue;
// final prefs=await SharedPreferences.getInstance();
// final username=prefs.getString('username');
  // get group => null;
  // String datestr = datetime.toString().substring(0,10);
  @override
  void initState() {
    super.initState();
    // tokein();
    // groupList();
    getSWData();
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        // ignore: avoid_print
        print("Internet connection No data");
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection
        print("Internet connection is mobile data network No data");
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        print("Internet connection is from wificonnection No data");
        //
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //
        print("Internet connection is from wired connectionconnection No data");
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //
        print(
            "Internet connection is from bluetooth threateningconnection No data");
        setState(() {
          isoffline = false;
        });
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  // Future<List<GroupL>> getJsonData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final response = await http.get(
  //     Uri.parse("https://gctctz.pythonanywhere.com/api-group/"),
  //     headers: <String, String>{
  //       HttpHeaders.authorizationHeader: 'Token ${prefs.getString('token')}',

  //       'Content-Type': 'application/json;charset=UTF-8',
  //       'Accept': '*/*',
  //       'Allow': 'GET, OPTIONS',
  //       'Accept-Encoding': 'gzip, deflate, br',
  //       // 'Cookie':
  //       //     'csrftoken=Io45Vb2gXtkQpaLLhatpi8OPHCCtJ0r797Gms4VO0zXLawjEMmKeWjcs6QHDDmPS; sessionid=fskdhln9j3fmelasw7hrjqi1t9zvdwke',
  //       // 'Authorization': 'Token; ${tokein()}',
  //       // HttpHeaders.authorizationHeader: 'Token${tokein()}',
  //       // HttpHeaders.authorizationHeader: tokein().toString(),
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // If the call to the server was successful, parse the JSON
  //     List<dynamic> values = [];
  //     values = json.decode(response.body);
  //     // if (values.isNotEmpty) {
  //     //   setState(() {
  //     //     for (int i = 0; i < values.length; i++) {
  //     //       if (values[i] != null) {
  //     //         Map<String, dynamic> map = values[i];
  //     //         _list!.add(GroupL.fromJson(map));
  //     //         debugPrint('Id-------${map['id']} $_list');
  //     //         // log('data: $_list');
  //     //       }
  //     //     }
  //     //     loading = false;
  //     //   });
  //     // }
  //     return _list!;
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }
  // }

  // Future<String?> tokein() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print(prefs.getString('token'));
  //   return prefs.getString('token');
  // }

  // Future<Profile> editProfile(dynamic firstName, middleName, surname, country,
  //     phoneNumber, email) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final http.Response response = await http.put(
  //     Uri.parse(
  //         // "https://ministrymedia.pythonanywhere.com/myadminpost/12/view/"),
  //         "https://gctctz.pythonanywhere.com/api-prof/${widget.id}"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'authorization': 'Token ' + prefs.getString('token').toString(),
  //     },
  //     body: jsonEncode(<dynamic, String>{
  //       // "pk": pk,
  //       // "user": user,
  //       "first_name": firstName,
  //       "middle_name": middleName,
  //       "surname": surname,
  //       "country": country,
  //       // "picture": picture,
  //       "phone_number": phoneNumber,
  //       "email": email,
  //       "group": '1',
  //     }),
  //   );
  //   if (response.statusCode == 201) {
  //     // If the server did return a 201 CREATED response,
  //     // then parse the JSON.
  //     print(response.body);
  //     Navigator.pop(context);
  //     return Profile.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     print('errrrrorr');
  //     print(response.body);
  //     // print('data is:' + views.toString());
  //     throw Exception('Failed to send views');
  //   }
  // }

  // List<GroupL>? grouplist = [];
  // Widget groupList() {
  //   grouplist = List<GroupL>.from(_list!.map((i) {
  //     return i;
  //   }));
  //   return DropdownButton(
  //       hint: Text("select group"),
  //       isExpanded: true,
  //       items: grouplist!.map((groupL) {
  //         // ignore: sort_child_properties_last
  //         return DropdownMenuItem(
  //           child: Text(groupL.name!),
  //           value: groupL.name,
  //         );
  //       }).toList(),
  //       onChanged: ((value) {
  //         print("selected is $value");
  //       }));
  // }

  List categoryItemlist = [];
  Future getAllCategory() async {
    var baseUrl = "https://gctctz.pythonanywhere.com/api-group/";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
    }
  }

  // Future<Profile> createProfile(dynamic firstName, middleName, surname, country,
  //     picture, phoneNumber, email, group) async {
  //   final http.Response response = await http.post(
  //     Uri.parse(
  //         // "https://ministrymedia.pythonanywhere.com/myadminpost/12/view/"),
  //         "https://gctctz.pythonanywhere.com/api-prof/create"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'authorization': 'Token ' + tokein().toString(),
  //     },
  //     body: jsonEncode(<dynamic, int>{
  //       // "pk": pk,
  //       // "user": user,
  //       "first_name": firstName,
  //       "middle_name": middleName,
  //       "surname": surname,
  //       "country": country,
  //       "picture": picture,
  //       "phone_number": phoneNumber,
  //       "email": email,
  //       "group": group,
  //     }),
  //   );
  //   if (response.statusCode == 201) {
  //     // If the server did return a 201 CREATED response,
  //     // then parse the JSON.
  //     print(response.body);
  //     return Profile.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     print('errrrrorr');
  //     // print('data is:' + views.toString());
  //     throw Exception('Failed to send views');
  //   }
  // }

  final String url = "https://gctctz.pythonanywhere.com/api-group/";
  String? _mySelection;
  List data = [];

  Future<String> getSWData() async {
    var res =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    // final Todo data = ModalRoute.of(context).settings.arguments;
    // Use the Todo to create the UI.
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Container(
          // temp
          height: MediaQuery.of(context).size.height,
          color:
              // const Color.fromARGB(255, 42, 50, 102),
              Color.fromARGB(10, 254, 254, 255),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color:
                      // const Color.fromARGB(255, 42, 50, 102),
                      const Color.fromARGB(255, 33, 51, 159),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      const Spacer(),
                      const Text(
                        'Profile Edit',
                        style: TextStyle(
                            color: Color.fromARGB(255, 27, 27, 27),
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),

                      DropdownButton(
                        items: items.map((String items) {
                          return DropdownMenuItem(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => EditProfileScreen(),
                              //       ));
                              // },
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ));
                        }).toList(),
                        // value: dropdownvalue,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.more_vert,
                          size: 28,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            if (newValue == 'Show') {
                              print('object');
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                      // const IconButton(
                      //     onPressed: null,
                      //     icon: Icon(
                      //       Icons.more_vert,
                      //       size: 28,
                      //       color: Colors.white,
                      //     )),
                      const SizedBox(
                        width: 6,
                      )
                      // SvgPicture.asset(
                      //   "assets/icons/dots.svg",
                      //   height: 8,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(children: [
                    widget.picture!.isNotEmpty
                        ? CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(widget.picture!),
                            // foregroundImage: ,
                            radius: 90,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                const AssetImage('images/user.png'),
                            // foregroundImage: ,
                            radius: 90,
                          ),
                    Positioned(
                      right: 5.0,
                      bottom: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [

                // const Text(
                //   'Antony Ernest Mrope',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 19,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(
                //   width: 5,
                // ),
                // GestureDetector(
                //     onTap: () {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               backgroundColor: Colors.white,
                //               title: const Text('Edit Name',
                //                   style: TextStyle(fontSize: 22)),
                //               content: Container(
                //                   padding: const EdgeInsets.all(0),
                //                   child: Column(
                //                     children: const [
                //                       TextField(
                //                         showCursor: true,
                //                         decoration: InputDecoration(
                //                           border: OutlineInputBorder(
                //                             borderRadius: BorderRadius.all(
                //                                 Radius.circular(10.0)),
                //                             borderSide: BorderSide(
                //                               width: 0,
                //                               style: BorderStyle.none,
                //                             ),
                //                           ),
                //                           filled: true,
                //                           // prefixIcon: Icon(
                //                           //   Icons.lock_outline,
                //                           //   color: Color(0xFF666666),
                //                           //   // size: defaul,
                //                           // ),
                //                           // suffixIcon: Icon(
                //                           //   Icons.remove_red_eye,
                //                           //   color: Color(0xFF666666),
                //                           //   // size: defaultIconSize,
                //                           // ),
                //                           fillColor: Color.fromARGB(
                //                               255, 222, 222, 231),
                //                           hintStyle: TextStyle(
                //                             color: Color.fromARGB(
                //                                 255, 93, 93, 95),
                //                             // fontFamily: defaultFontFamily,
                //                             // fontSize: defaultFontSize,
                //                           ),
                //                           hintText: "Antony",
                //                         ),
                //                       ),
                //                       SizedBox(
                //                         height: 6,
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(
                //                             horizontal: 0),
                //                         child: TextField(
                //                           showCursor: true,
                //                           decoration: InputDecoration(
                //                             border: OutlineInputBorder(
                //                               borderRadius:
                //                                   BorderRadius.all(
                //                                       Radius.circular(
                //                                           10.0)),
                //                               borderSide: BorderSide(
                //                                 width: 0,
                //                                 style: BorderStyle.none,
                //                               ),
                //                             ),
                //                             filled: true,
                //                             // prefixIcon: Icon(
                //                             //   Icons.lock_outline,
                //                             //   color: Color(0xFF666666),
                //                             //   // size: defaul,
                //                             // ),
                //                             // suffixIcon: Icon(
                //                             //   Icons.remove_red_eye,
                //                             //   color: Color(0xFF666666),
                //                             //   // size: defaultIconSize,
                //                             // ),
                //                             fillColor: Color.fromARGB(
                //                                 255, 222, 222, 231),
                //                             hintStyle: TextStyle(
                //                               color: Color(0xFF666666),
                //                               // fontFamily: defaultFontFamily,
                //                               // fontSize: defaultFontSize,
                //                             ),
                //                             hintText: "Ernest",
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(
                //                         height: 6,
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(
                //                             horizontal: 0),
                //                         child: TextField(
                //                           showCursor: true,
                //                           decoration: InputDecoration(
                //                             border: OutlineInputBorder(
                //                               borderRadius:
                //                                   BorderRadius.all(
                //                                       Radius.circular(
                //                                           10.0)),
                //                               borderSide: BorderSide(
                //                                 width: 0,
                //                                 style: BorderStyle.none,
                //                               ),
                //                             ),
                //                             filled: true,
                //                             // prefixIcon: Icon(
                //                             //   Icons.lock_outline,
                //                             //   color: Color(0xFF666666),
                //                             //   // size: defaul,
                //                             // ),
                //                             // suffixIcon: Icon(
                //                             //   Icons.remove_red_eye,
                //                             //   color: Color(0xFF666666),
                //                             //   // size: defaultIconSize,
                //                             // ),
                //                             fillColor: Color.fromARGB(
                //                                 255, 222, 222, 231),
                //                             hintStyle: TextStyle(
                //                               color: Color(0xFF666666),
                //                               // fontFamily: defaultFontFamily,
                //                               // fontSize: defaultFontSize,
                //                             ),
                //                             hintText: "Mrope",
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(
                //                         height: 1,
                //                       ),
                //                     ],
                //                   )),
                //               actions: <Widget>[
                //                 TextButton(
                //                   child: const Text(
                //                     'Save',
                //                     style: TextStyle(
                //                         fontSize: 16,
                //                         color: Color.fromARGB(
                //                             255, 3, 13, 145)),
                //                   ),
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                 ),
                //               ],
                //             );
                //           });
                //     },
                //     child: const Icon(
                //       Icons.edit,
                //       color: Colors.white,
                //     ))
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    '@username',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 120,
                  decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        // blurRadius: 0.3,
                        // offset: Offset(0.0, 0.45)
                      )
                    ],
                    color: Colors.grey[200],
                    // const Color.fromARGB(255, 235, 234, 247),
                    // const Color.fromARGB(255, 252, 251, 253),
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: firstnameController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.text_fields,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "First name",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: middlenameController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.text_fields,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "Middle name",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: surnameController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.text_fields,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "Surname",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: countryController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.public,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "Country",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: emailController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "Email",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            controller: phoneController,
                            showCursor: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Color.fromARGB(255, 73, 73, 73),
                                // size: defaultIconSize,
                              ),
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                // fontFamily: defaultFontFamily,
                                // fontSize: defaultFontSize),
                              ),
                              hintText: "Phone number",
                            ),
                            onSaved: (val) {
                              // username = val!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(Icons.people,
                                    color: Color.fromARGB(255, 73, 73, 73)),
                                SizedBox(
                                  width: 12,
                                ),
                                DropdownButton(
                                  hint: Text('Select group'),
                                  items: data.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item['name']),
                                      value: item.toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      _mySelection = newVal as String?;
                                      // groupname = item['name'];
                                      print('print value' +
                                          _mySelection!.toString());
                                    });
                                  },
                                  value: _mySelection,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            // widget.id!.toString().isNotEmpty
                                // ? editProfile(
                                //     // firstnameController.text.isEmpty?
                                //     // widget.firstname:
                                //     firstnameController.text,
                                //     // middlenameController.text.isEmpty?

                                //     middlenameController.text,
                                //     surnameController.text,
                                //     countryController.text,

                                //     phoneController.text,
                                //     emailController.text,
                                //   )
                                // : createProfile(
                                //     firstnameController.text,
                                //     middlenameController.text,
                                //     surnameController.text,
                                //     countryController.text,
                                //     "",
                                //     phoneController.text,
                                //     emailController.text,
                                //     groupController.text);
                          },
                          child: Container(
                            // color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            // const Color.fromARGB(255, 223, 28, 26),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 13, bottom: 13),
                            decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey,
                                  // blurRadius: 0.3,
                                  // offset: Offset(0.0, 0.45)
                                )
                              ],
                              color: const Color.fromARGB(255, 33, 51, 159),
                              // border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    ));
  }
}
