import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedr/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../components/sidenav.dart';

class AddFeed extends StatefulWidget {
  const AddFeed({Key? key}) : super(key: key);

  final String _title = 'RSS Submission Link';

  final String title = 'AddFeed';
  static const String routeName = '/AddFeed';

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference _feeds =
      FirebaseFirestore.instance.collection('feeds');

  String? _name;

   bool _ValidateURL() {
    //print(_name);
    if (Uri.parse(_name!).isAbsolute) {
      try {
        final client = http.Client();
        return true;
        // if (response.body != null) {
        //   //
        // }
      } catch (e) {
        return false;
      }
    } else {
      print("Invalid Input");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text(widget._title)),
          drawer: const SideNav(),
        body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your Link',
            ),
            onChanged: (text) {
              setState(() {
                _name = text;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the URL';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () async {

                if(!_ValidateURL()) {
                  Fluttertoast.showToast(msg: "Invalid URL");
                  return;

                }
                  await _feeds.add({"url": _name});
                Fluttertoast.showToast(msg: "RSS Feed added Successful");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                  print(_name);

                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {

                  // Process data.
                }
              },
              child: const Text('ADD'),
            ),
          ),
        ],
      ),
    ));
  }
}
