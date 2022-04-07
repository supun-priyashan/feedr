import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFavourite extends StatefulWidget {
  const AddFavourite({Key? key, required this.feed}) : super(key: key);

  final RssItem feed;

  final String title = 'Add feed to favourites';
  static const String routeName = '/subfeed';

  @override
  State<AddFavourite> createState() => _AddFavouriteState();
}

class _AddFavouriteState extends State<AddFavourite> {
  late TextEditingController category = TextEditingController();

  final CollectionReference _favCat =
  FirebaseFirestore.instance.collection('favCat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.green),
            onPressed: () => Navigator.of(context).pop(),
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
                                      addToList(documentSnapshot.id.toString());
                                    },
                                    onLongPress: () {
                                      print(documentSnapshot.id.toString());
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
        )
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
                  Navigator.of(context).pop();
                  category.clear();
                },
              )
            ],
          )
  );

  void addToList(String id) {
    RssItem item = widget.feed;
    _favCat.doc(id).collection("favs").add({"link": item.link,"subtitle": item.pubDate ?? item.author ?? "","thumbnail": item.enclosure?.url,"title": item.title}).then((value) => Navigator.of(context).pop());
  }

  Future showEditDialog(String id) =>
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Edit/Delete category"),
              content: TextField(
                decoration: InputDecoration(hintText: "New category name"),
                controller: category,
              ),
              actions: [
                TextButton(
                  child: Text("Delete"),
                  onPressed: () async {
                    await _favCat.doc(id).delete();
                    Navigator.of(context).pop();
                    category.clear();
                  },
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () async {
                    await _favCat.doc(id).update({"name": category.text});
                    Navigator.of(context).pop();
                    category.clear();
                  },
                )
              ],
            )
    );
}
