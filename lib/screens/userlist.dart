import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference _userList =
      FirebaseFirestore.instance.collection('users');

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Manage Users"),
        ),
        body: StreamBuilder(
            stream: _userList.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Text('Something went wrong');
              }
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot item =
                        streamSnapshot.data!.docs[index];
                    return ListTile(
                      title:
                          title(item['firstName'] + " " + item['secondName']),
                      subtitle: subtitle(item['email']),
                      contentPadding: EdgeInsets.all(5.0),
                      onLongPress: () {
                        fname = TextEditingController(text: item['firstName']);
                        lname = TextEditingController(text: item['secondName']);
                        email = TextEditingController(text: item['email']);
                        showEditDialog(item.id);
                      },
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future showEditDialog(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Edit/Delete user"),
            content: Column(children: [
              TextFormField(
                decoration: InputDecoration(hintText: "First name"),
                controller: fname,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Second name"),
                controller: lname,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                controller: email,
              ),
            ]),
            actions: [
              TextButton(
                child: Text("Delete"),
                onPressed: () async {
                  await _userList.doc(id).delete();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(msg: "Profile Deleted successfully");
                  fname.clear();
                  lname.clear();
                  email.clear();
                },
              ),
              TextButton(
                child: Text("Edit"),
                onPressed: () async {
                  if (fname.text.isEmpty ||
                      lname.text.isEmpty ||
                      email.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Cannoy have Empty Fields");
                  } else {
                    await _userList.doc(id).update({
                      "firstName": fname.text,
                      "secondName": lname.text,
                      "email": email.text
                    });
                    Fluttertoast.showToast(msg: "Profile Edited successfully");
                    Navigator.of(context).pop();
                    fname.clear();
                    lname.clear();
                    email.clear();
                  }
                },
              )
            ],
          ));
}
