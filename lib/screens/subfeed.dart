import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:feedr/screens/addfavourite.dart';

class SubFeed extends StatefulWidget {
  const SubFeed({Key? key}) : super(key: key);

  final String title = 'subfeed';
  static const String routeName = '/subfeed';

  @override
  _SubFeedState createState() => _SubFeedState();
}

class _SubFeedState extends State<SubFeed> {
  static const String FEED_URL =
      'https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss';
  RssFeed? _feed;
  String? _title;
  RssItem? feed;
  static const loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/images/feed-placeholder.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;

  final CollectionReference _fav =
  FirebaseFirestore.instance.collection('fav');

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load().whenComplete(
            (){
          setState(() {});
        }
    );
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed!.title);
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  updateTitle(title) {
    setState(() {
      _title = title;
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

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

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

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed!.items?.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed!.items![index];
        return ListTile(
          title: title(item.title),
          subtitle: subtitle((item.pubDate ?? item.author ?? "").toString()),
          leading: thumbnail(item.enclosure?.url),
          trailing: IconButton(
              icon: Icon(
                Icons.favorite_border_sharp,
                color: Colors.green,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFavourite(feed: item),
                  ),
                );
                }),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () => openFeed(item.link ?? ""),
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed!.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
      child: CircularProgressIndicator(),
    )
        : RefreshIndicator(
      key: _refreshKey,
      child: list(),
      onRefresh: () => load(),
    );
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
        title: Text(_title!),
      ),
      body: body(),
    );
  }
}
