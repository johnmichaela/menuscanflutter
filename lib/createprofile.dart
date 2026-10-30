// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:ballon/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateProfileScreen extends StatefulWidget {
  // String church;
  CreateProfileScreen({
    super.key,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  DateTime datetime = DateTime.now();
  var items = ['Show'];
  late String firstname, middlename, surname;

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;
  String? dropdownvalue;
  int? downid;
  // final List<GroupL>? _list = [];
  StreamSubscription? connection;
  bool isoffline = false;
  var loading = true;
  var _image;
  var imagePicker;
  var type;

  // ignore: non_constant_identifier_names

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    // tokein();
    // getJsonData();
    // getAllCategory();
    // connection = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   // whenevery connection status is changed.
    //   if (result == ConnectivityResult.none) {
    //     // ignore: avoid_print
    //     print("Internet connection No data");
    //     //there is no any connection
    //     setState(() {
    //       isoffline = true;
    //     });
    //   } else if (result == ConnectivityResult.mobile) {
    //     //connection
    //     print("Internet connection is mobile data network No data");
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.wifi) {
    //     print("Internet connection is from wificonnection No data");
    //     //
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.ethernet) {
    //     //
    //     print("Internet connection is from wired connectionconnection No data");
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.bluetooth) {
    //     //
    //     print(
    //         "Internet connection is from bluetooth threateningconnection No data");
    //     setState(() {
    //       isoffline = false;
    //     });
    //   }
    // });
  }

  // ignore: prefer_typing_uninitialized_variables
  var resJson;

  onUploadImage(
      dynamic name, bio, birthday, activity, phoneNumber, email, place) async {
    final prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.1.115:8000 /prof/api-prof/create"),
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'authorization': 'Token ' + prefs.getString('token').toString(),
    };

    request.fields['name'] = name;
    request.fields['bio'] = bio;
    // request.fields['activity'] = activity;
    request.fields['birthday'] = birthday;
    request.fields['phone_number'] = phoneNumber;
    request.fields['email'] = email;
    // request.fields['group'] = group;
    request.fields['place'] = place;
    request.files.add(
      http.MultipartFile(
        'picture',
        image!.readAsBytes().asStream(),
        image!.lengthSync(),
        filename: image!.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    if (response.statusCode == 201) {
      setState(() {
        resJson = jsonDecode(response.body);
        print(resJson);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QoperaApp(),
        ),
      );
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text("Created Successful")));
    } else {
      print(response.body);
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text("Check Internet Connection Or Fill all Field ")));
    }

    // } else {
  }

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 50);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      print(image.path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      // selectedImage = File(image!.path);
    });
  }

  XFile? uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? choosedimage =
        (await _picker.pickImage(source: ImageSource.gallery));
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
      print(uploadimage);
    });
  }

  Future<void> uploadImage(dynamic firstName, middleName, surname, country,
      phoneNumber, email, group) async {
    //show your own loading or progressing code here
    final prefs = await SharedPreferences.getInstance();
    String uploadurl =
        "http://192.168.1.115:8000 /prof/api-prof/create";

    try {
      List<int> imageBytes = uploadimage!.readAsBytes() as List<int>;
      // readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(
        Uri.parse(uploadurl),
        body: {
          'picture': baseimage,
          "first_name": firstName,
          "middle_name": middleName,
          "surname": surname,
          "country": country,
          // "picture": uploadimage.toString(),
          "phone_number": phoneNumber,
          "email": email,
          // "group": group,
        },
        headers: <String, String>{
          HttpHeaders.authorizationHeader: 'Token ${prefs.getString('token')}',
          'Content-Type': 'application/json;charset=UTF-8',
          'Accept': '*/*',
          'Allow': 'GET, OPTIONS',
          'Accept-Encoding': 'gzip, deflate, br',
        },
      );
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          print(jsondata["msg"]);
          //if error return from server, show message from server
        } else {
          print("Upload successful");
        }
      } else {
        print("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      print("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
  }

  // Future<List<GroupL>> getJsonData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final response = await http.get(
  //     Uri.parse(
  //         "https://gctctz.pythonanywhere.com/api-group/?q=${widget.church}"),
  //     headers: <String, String>{
  //       // HttpHeaders.authorizationHeader: 'Token ${prefs.getString('token')}',

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
  //     if (values.isNotEmpty) {
  //       setState(() {
  //         for (int i = 0; i < values.length; i++) {
  //           if (values[i] != null) {
  //             Map<String, dynamic> map = values[i];
  //             _list!.add(GroupL.fromJson(map));
  //             debugPrint('Id-------${map['pk']} $_list');
  //             // log('data: $_list');
  //           }
  //         }
  //         loading = false;
  //       });
  //     }
  //     return _list!;
  //   } else {
  //     // If that call was not successful, throw an error.
  //     throw Exception('Failed to load post');
  //   }
  // }

  // Future<Profile> createProfile(dynamic firstName, middleName, surname, country,
  //     phoneNumber, email, group) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final http.Response response = await http.post(
  //     Uri.parse(
  //         // "https://ministrymedia.pythonanywhere.com/myadminpost/12/view/"),
  //         "https://gctctz.pythonanywhere.com/api-prof/create"),
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
  //       "picture": uploadimage.toString(),
  //       "phone_number": phoneNumber,
  //       "email": email,
  //       "group": group,
  //     }),
  //   );
  //   if (response.statusCode == 201) {
  //     // If the server did return a 201 CREATED response,
  //     // then parse the JSON.
  //     // SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     // localStorage.setString('group', group);
  //     print(response.body);
  //     // ignore: use_build_context_synchronously
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const ProfileScreen(),
  //       ),
  //     );
  //     return Profile.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     print('errrrrorr');
  //     // print('data is:' + views.toString());
  //     throw Exception('Failed to send views ${response.body}');
  //   }
  // }

  // List<GroupL>? grouplist = [];
  // Widget groupList() {
  //   grouplist = List<GroupL>.from(_list!.map((i) {
  //     // return GroupL.fromJson(i);
  //   }));
  //   return DropdownButton(
  //       hint: const Text("select group"),
  //       isExpanded: true,
  //       items: grouplist!.map((groupL) {
  //         return DropdownMenuItem(
  //           child: Text(groupL.name!),
  //           value: groupL.name,
  //         );
  //       }).toList(),
  //       onChanged: ((value) {
  //         print("selected is $value");
  //       }));
  // }

  // List categoryItemlist = [];
  // Future getAllCategory() async {
  //   var baseUrl =
  //       "https://gctctz.pythonanywhere.com/api-group/?q=${widget.church}";

  //   http.Response response = await http.get(Uri.parse(baseUrl));

  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     setState(() {
  //       categoryItemlist = jsonData;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Create profile',
          style: TextStyle(
              color: Color.fromARGB(255, 248, 247, 247),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color.fromARGB(255, 197, 4, 4),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          // temp
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                ),
                const SizedBox(
                  height: 10,
                ),
                  
                Center(
                  child: Stack(children: [
                    image == null
                        ? CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                const AssetImage('assets/img/logo.png'),
                            // foregroundImage: ,Image.file(selectedImage)
                            radius: 60,
                          )
                        // Image.file(selectedImage),
                        :
                        // Image.file(uploadimage)
                        CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: FileImage(File(image!.path)),
                            // backgroundImage: Image.file(uploadimage!.readAsBytes()),
                            radius: 60,
                          ),
                    Positioned(
                      right: 6.0,
                      bottom: 6.0,
                      child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 197, 4, 4),
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
               
                // const Center(
                //   child: Text(
                //     '@username',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height - 120,
                  decoration: BoxDecoration(
                    // boxShadow: const <BoxShadow>[
                    //   BoxShadow(
                    //     color: Colors.grey,
                    //     // blurRadius: 0.3,
                    //     // offset: Offset(0.0, 0.45)
                    //   )
                    // ],
                    color: Colors.grey[200],
                    // const Color.fromARGB(255, 235, 234, 247),
                    // const Color.fromARGB(255, 252, 251, 253),
                    // border: Border.all(color: Colors.white),
                    // borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          // decoration: BoxDecoration(color: Colors.grey),
                          child: TextField(
                            controller: nameController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Full name',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 230, 229, 229),
                                // icon: Icon(
                                //   Icons.person_outline,
                                //   color: Theme.of(context).primaryColor,
                                // ), //icon of text field
                                labelText: "Full Name",

                                //label text of field
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(155, 46, 45, 45))),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: countryController,
                            //editing controller of this TextField
                            cursorColor: Color.fromARGB(255, 221, 220, 220),

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 221, 220, 220)),
                                ),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                filled: true,
                                hintText: 'Enter Your Place',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // icon: Icon(Icons.work,
                                //     color: Theme.of(context)
                                //         .primaryColor), //icon of text field
                                labelText: "Place",
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 27, 27, 27)) //label text of field
                                ),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: activityController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 238, 238, 238))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Your Job & Activities',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // icon: Icon(Icons.work,
                                //     color: Theme.of(context)
                                //         .primaryColor), //icon of text field
                                labelText: "Job & Activities",
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 47, 65, 87)) //label text of field
                                ),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: birthdayController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Your Birth Date',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // icon: Icon(
                                //   Icons.calendar_month_sharp,
                                //   color: Theme.of(context).primaryColor,
                                // ), //icon of text field
                                labelText: "Birth date", //label text of field
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 47, 65, 87))),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1990),
                                  firstDate: DateTime(1990),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  birthdayController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: bioController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,
                            maxLines: 3,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Your Bio',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // fillColor:
                                //     const Color.fromARGB(255, 240, 238, 238),

                                // enabledBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                // icon: Icon(
                                //   Icons.edit,
                                //   color: Theme.of(context).primaryColor,
                                // ), //icon of text field
                                labelText: "Bio", //label text of field
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 47, 65, 87))),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: emailController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Email ',
                                hintMaxLines: 1,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // fillColor:
                                //     const Color.fromARGB(255, 240, 238, 238),
                                // icon: Icon(
                                //   Icons.mail_outline,
                                //   color: Theme.of(context).primaryColor,
                                // ), //icon of text field
                                labelText: "Email", //label text of field
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 47, 65, 87))),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: phoneController,
                            //editing controller of this TextField
                            cursorColor: Theme.of(context).primaryColor,

                            //editing controller of this TextField
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // prefixIconColor:
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 221, 220, 220))),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).primaryColor)),
                                filled: true,
                                hintText: 'Enter Your phone',
                                hintMaxLines: 1,
                                alignLabelWithHint: true,
                                //  helperText: 'goo',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 68, 68, 68)),
                                fillColor: Color.fromARGB(255, 226, 225, 225),
                                // fillColor:
                                //     const Color.fromARGB(255, 240, 238, 238),
                                // icon: Icon(
                                //   Icons.phone,
                                //   color: Theme.of(context).primaryColor,
                                // ), //icon of text field
                                labelText: "Phone Number", //label text of field
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 47, 65, 87))),
                            // readOnly: true,
                            //set it true, so that user will not able to edit text
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            onUploadImage(
                              nameController.text,
                              bioController.text,
                              birthdayController.text,
                              activityController.text,
                              phoneController.text,
                              emailController.text,
                              countryController.text,
                            );
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
                              color: const Color.fromARGB(255, 197, 4, 4),
                              // border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                // Icon(
                                //   Icons.person_add,
                                //   color: Colors.white,
                                //   size: 28,
                                // ),
                                // SizedBox(
                                //   width: 8,
                                // ),
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                       
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
