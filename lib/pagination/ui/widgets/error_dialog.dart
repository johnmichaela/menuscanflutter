  import 'package:flutter/material.dart';

Widget errorDialog({
    required double size,
     Function()? onPressed,
  }) {
    return SizedBox(
      height: 220,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Internet Connection',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 168, 168, 168)),
          ),
          const SizedBox(
            height: 10,
          ),
          Icon(Icons.wifi_off,size: 80,color: Colors.grey,),
           const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                "Refresh",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color:Color.fromARGB(255, 28, 196, 114)),
              )),
        ],
      ),
    );
  }
