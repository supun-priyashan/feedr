import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateFeed extends StatefulWidget {
  static const String _title = 'Update link';

  final String title = 'UpdateFeed';
  static const String routeName = '/updatefeed';

  final String feedId;
  final String feedUrl;

  const UpdateFeed({Key? key, required this.feedId, required this.feedUrl}) : super(key: key);

  @override
  State<UpdateFeed> createState() => _UpdateFeedState();
}

class _UpdateFeedState extends State<UpdateFeed> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference urls =
  FirebaseFirestore.instance.collection('feeds');
  @override
  Widget build(BuildContext context) {

    String url = widget.feedUrl.toString();
    late TextEditingController editurl = TextEditingController(text: url);

    String? _name;
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your Link',
                ),
                controller: editurl,
                // onChanged: (text) {
                //   print(text);
                //   setState(() {
                //     _name = text;
                //   });
                // },
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
                   //  await urls.add({"url": editurl.text});
                     print(editurl.text);
                    await urls
                        .doc(widget.feedId)
                        .update({"url": editurl.text});
                     Navigator.of(context).pop();
                    //}
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
