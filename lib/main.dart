import 'package:firebase_core/firebase_core.dart';

import 'package:feedr/screens/subfeed.dart';
import 'package:flutter/material.dart';
import 'package:feedr/screens/login.dart';
import 'package:feedr/screens/home.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
            primary: Colors.green,
            onPrimary: Colors.white
        ),

        // Define the default font family.
        fontFamily: 'Nexa',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 18.0, fontFamily: 'Poppins'),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: Home.routeName,
      routes: {
        Home.routeName: (context) => Home(),
        Login.routeName: (context) => Login(),
        SubFeed.routeName: (context) => SubFeed(),
      },
    );
  }
}