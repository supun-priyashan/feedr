import 'package:feedr/screens/AddFeed.dart';
import 'package:feedr/screens/favourites.dart';
import 'package:feedr/screens/feed.dart';
import 'package:feedr/screens/home.dart';
import 'package:flutter/material.dart';

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
              ListTile(
                  leading: Icon(Icons.person_outline_rounded),
                  title: Text('Profile')
              ),
            ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign out')
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
}
