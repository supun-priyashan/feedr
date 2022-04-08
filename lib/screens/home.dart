import 'package:feedr/components/sidenav.dart';
import 'package:feedr/screens/editProfile.dart';
import 'package:feedr/screens/profile.dart';
import 'package:flutter/material.dart';

import 'package:feedr/screens/login.dart';
import 'package:feedr/screens/feed.dart';
import 'package:feedr/screens/subfeed.dart';
import 'package:feedr/screens/AddFeed.dart';
import 'package:feedr/screens/userlist.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
      ),
      drawer: const SideNav(),
      body: Container(
        child: Feed()
      ),
    );
  }
}
