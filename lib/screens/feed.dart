import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedr/screens/updatefeed.dart';
import 'package:flutter/material.dart';


class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  final String title = 'feed';
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      theme: ThemeData.light(),
      home: const FeedPage(),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
          title: const Text('Kindacode.com'),
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
                ));
              }).toList(),




            );

          },
        ),);
  }
}
