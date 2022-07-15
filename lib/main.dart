import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sondazhi/sondazhet.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isNotEmpty) {
    if (Firebase.apps.length == 0) {
      await Firebase.initializeApp(
          name: "myName",
          options: const FirebaseOptions(
            apiKey: "AIzaSyD_NVIwux13lD_XcMMcIHwlvUJwmXy-tCk",
            appId: "1:373071559569:web:c5de30bee0105b61a53830 ",
            messagingSenderId: "373071559569",
            projectId: "app-lajmi",
          ));
    }
  } else {
    Firebase.app();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Sondazhet(),
    );
  }
}
