import 'package:feedr/screens/login.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));}, child: Text("login")),
            ElevatedButton(onPressed: (){}, child: Text("gfdh")),
            ElevatedButton(onPressed: (){}, child: Text("nbvn")),
          ],
        ),
      ),
    );
  }
}
