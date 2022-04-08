import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedr/screens/subfeed.dart';
import 'package:feedr/screens/updatefeed.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  final String title = 'feed';
  static const String routeName = '/feed';

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // Dummy Product Data Here
  final List myProducts = List.generate(100, (index) {
    return {"id": index, "title": "Product #$index", "price": index + 1};
  });
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('feeds').snapshots();
  final CollectionReference urls =
  FirebaseFirestore.instance.collection('feeds');

  Future<void> _deleteProduct(String id) async {
    print( id);
    await urls.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        appBar: AppBar(
          title: const Text('Feeds'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              UpdateFeed (feedId: document.id.toString(), feedUrl:data['url'].toString()),
                          ),);
                        //print(document.id);
                      },
                      child: Text("Update")),
                  trailing: ElevatedButton(
                      onPressed: () {
                        _deleteProduct(document.id);
                      },
                      child: Text("Delete")),
                  title: Text(data['url']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubFeed(),
                      ),
                    );
                  },
                ));
              }).toList(),
            );

          },
        ),);
  }
}
