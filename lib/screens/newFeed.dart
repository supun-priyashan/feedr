import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class newFeed extends StatefulWidget {
  const newFeed({Key? key}) : super(key: key);

  static const String routeName = '/newFeed';

  @override
  _newFeedState createState() => _newFeedState();
}

class _newFeedState extends State<newFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("fdsfdsfr"),
      ),
      body: Container(
        height: 100,
        width: 500,
        child:
        GFListTile(
            titleText:'Title',
            subTitleText:'Lorem ipsum dolor sit amet, consectetur adipiscing',
            icon: Icon(Icons.favorite)
        ),
      ),
    );
  }

}
