import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())),
        ),
        centerTitle: true,
        title: Text("Manage users"),
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
}
