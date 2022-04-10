import 'package:feedr/screens/favFeeds.dart';
import 'package:feedr/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  final String title = 'My Favourites';
  static const String routeName = '/favourites';

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late TextEditingController category = TextEditingController();
  late TextEditingController nameCtrl;

  final CollectionReference _favCat =
  FirebaseFirestore.instance.collection('favCat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())),
        ),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          OutlinedButton(
            onPressed: (){
              inputCategory();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text('Add new favourites collection'),
              ],
            ),
          ),
          StreamBuilder(
              stream: _favCat.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return Expanded(
                      child:
                      ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Icon(Icons.favorite, color: Colors.green,),
                              title: Text(documentSnapshot['name']),
                              onTap: () {
                                CollectionReference favou = FirebaseFirestore.instance.collection('favCat').doc(documentSnapshot.id).collection('favs');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavFeeds(title: documentSnapshot['name'], fav: favou),
                                  ),
                                );
                              },
                              onLongPress: () {
                                nameCtrl = TextEditingController(text: documentSnapshot['name']);
                                showEditDialog(documentSnapshot.id.toString());
                              },
                            ),
                          );
                        },
                      )
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              })
        ],
      ),
    );
  }

  Future inputCategory() => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Add new category"),
            content: TextField(
              decoration: InputDecoration(hintText: "Category name"),
              controller: category,
            ),
            actions: [
              TextButton(
                child: Text("Add"),
                onPressed: () async {
                  await _favCat.add({"name": category.text});
                  Fluttertoast.showToast(
                      msg: "Category added",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.of(context).pop();
                  category.clear();
                },
              )
            ],
          )
  );

  Future showEditDialog(String id) =>
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Edit/Delete category"),
                content: TextField(
                  decoration: InputDecoration(hintText: "New category name"),
                  controller: nameCtrl,
                ),
                actions: [
                  TextButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      await _favCat.doc(id).delete();
                      Fluttertoast.showToast(
                          msg: "Successfully deleted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Navigator.of(context).pop();
                      category.clear();
                    },
                  ),
                  TextButton(
                    child: Text("Save"),
                    onPressed: () async {
                      await _favCat.doc(id).update({"name": category});
                      Fluttertoast.showToast(
                          msg: "Edit Success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Navigator.of(context).pop();
                      category.clear();
                    },
                  )
                ],
              )
      );
}
