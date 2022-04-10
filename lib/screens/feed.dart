import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedr/screens/subfeed.dart';
import 'package:feedr/screens/updatefeed.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  final String title = 'feed';
  static const String routeName = '/feed';

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

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
        body: StreamBuilder(
          stream: urls.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String, dynamic>? data = document.data()! as Map<String, dynamic>;
                return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  trailing: SizedBox(
                      height: 100,
                      width: 96,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    UpdateFeed (feedId: document.id.toString(), feedUrl:data['url'].toString()),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit_outlined,color: Colors.green,),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteProduct(document.id);
                              Fluttertoast.showToast(msg: "Deleted Feed successfully");
                            },
                            icon: Icon(Icons.delete_outline,color: Colors.red,),
                          ),
                        ],
                  )),
                  title: Text(data['url']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubFeed(data['url']),
                      ),
                    );
                  },
                ));
              }).toList(),
            );} else {
                return Text('Something went wrong');
            }
          },
        ),);
  }
}
