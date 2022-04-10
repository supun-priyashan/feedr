import 'package:feedr/screens/AddFeed.dart';
import 'package:feedr/screens/favourites.dart';
import 'package:feedr/screens/feed.dart';
import 'package:feedr/screens/home.dart';
import 'package:feedr/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {

  Widget sideNavItems(BuildContext context){
    return Container(
      color: Colors.black54,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Home()
                ));
                  },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: const Text("Favourites"),
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Favourites()
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add new feed"),
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AddFeed()
                  ));
                },
              ),
              const Divider(),
              Spacer(),
            const Divider(),
            ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign out'),
              onTap: () {
                    _signOut();
              },
              ),
            ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [sideNavItems(context)],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
    Fluttertoast.showToast(
        msg: "Logout Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
