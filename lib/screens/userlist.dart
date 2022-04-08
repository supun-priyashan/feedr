import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference _favCat =
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
        title: Text("Manage users"),
      ),
      body: StreamBuilder(
          stream: _favCat.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasError) {
              return Text('Something went wrong');
            }
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            if (streamSnapshot.hasData) {
              return
                ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot item =
                    streamSnapshot.data!.docs[index];
                    return ListTile(
                      title: title(item['firstName']+ " "+item['secondName']),
                      subtitle: subtitle(item['email']),
                      contentPadding: EdgeInsets.all(5.0),
                      onLongPress: () {
                        showEditDialog(item.id);
                      },
                    );
                  },
                )
              ;
            } else {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
          })
    );
  }

  Future showEditDialog(String id) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Edit/Delete user"),
            content: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "First name"),
                    controller: fname,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Last name"),
                    controller: lname,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                    controller: email,
                  ),
                ]),
            actions: [
              TextButton(
                child: Text("Delete"),
                onPressed: () async {
                  await _favCat.doc(id).delete();
                  Navigator.of(context).pop();
                  fname.clear();
                },
              ),
              TextButton(
                  onPressed: () async {
                    await _favCat.doc(id).update({"email": email.text, "firstName": fname.text, "lastName": lname.text});
                    Navigator.of(context).pop();
                    fname.clear();
                  },
                  child: Text("Save"))
            ],
          )
  );

}
