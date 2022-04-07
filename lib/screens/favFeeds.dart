import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FavFeeds extends StatefulWidget {
  const FavFeeds({Key? key, required this.title, required this.fav}) : super(key: key);

  final String title;
  final CollectionReference fav;

  @override
  State<FavFeeds> createState() => _FavFeedsState();
}

class _FavFeedsState extends State<FavFeeds> {

  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/images/feed-placeholder.png';

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

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  updateTitle(title) {
    setState(() {
      title = title;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

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
      body: StreamBuilder(
          stream: widget.fav.snapshots(),
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
                        title: title(item['title']),
                        subtitle: subtitle(item['subtitle']),
                        leading: thumbnail(item['thumbnail']),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                          size: 30.0,
                        ),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () => openFeed(item['link'] ?? ""),
                        onLongPress: () {
                          showDeleteDialog(context,item.id);
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

  showDeleteDialog(BuildContext context, String id) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        widget.fav.doc(id).delete();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete this feed?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
