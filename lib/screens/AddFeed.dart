import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddFeed extends StatelessWidget {
  static const String _title = 'RSS Submission Link';

  final String title = 'AddFeed';
  static const String routeName = '/AddFeed';

  @override
  AddFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference _feeds =
      FirebaseFirestore.instance.collection('feeds');

  String? _name;

   _ValidateURL() async {
    //print(_name);
    if (Uri.parse(_name!).isAbsolute) {
      try {
        final client = http.Client();
        final response = await client.get(Uri.parse(_name!));
        // print(response);
        // print(response.body);
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
    return Form(
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {

                //if(_ValidateURL()){
                  await _feeds.add({"url": _name});
                  print(_name);
                //}

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
    );
  }
}
