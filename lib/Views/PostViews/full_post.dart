import 'package:fedodo_micro/Components/icon_bar.dart';
import 'package:fedodo_micro/DataProvider/activity_handler.dart';
import 'package:fedodo_micro/DataProvider/likes_provider.dart';
import 'package:fedodo_micro/DataProvider/shares_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/activity.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../Models/ActivityPub/link.dart';
import '../../Models/ActivityPub/post.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.post,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;
  final String userId;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  @override
  Widget build(BuildContext context) {
    LikesProvider likesProv = LikesProvider(widget.accessToken);
    SharesProvider sharesProvider = SharesProvider(widget.accessToken);

    var likesFuture = likesProv.getLikes(widget.post.id);
    var sharesFuture = sharesProvider.getShares(widget.post.id);

    List<Widget> children = [];
    children.addAll(
      [
        PostView(
          isClickable: false,
          post: widget.post,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          userId: widget.userId,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
          child: Column(
            children: [
              FutureBuilder<OrderedPagedCollection>(
                future: sharesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderedPagedCollection> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = IconBar(
                      name: "Reblogs",
                      count: snapshot.data!.totalItems,
                      iconData: FontAwesomeIcons.retweet,
                    );
                  } else if (snapshot.hasError) {
                    child = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    );
                  } else {
                    child = const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return child;
                },
              ),
              FutureBuilder<OrderedPagedCollection>(
                future: likesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderedPagedCollection> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = IconBar(
                      name: "Likes",
                      count: snapshot.data!.totalItems,
                      iconData: FontAwesomeIcons.star,
                    );
                  } else if (snapshot.hasError) {
                    child = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    );
                  } else {
                    child = const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return child;
                },
              ),
              Row(
                children: [
                  Text(
                    DateFormat("MMMM d, yyyy HH:mm", "en_us")
                        .format(widget.post.published.toLocal()),
                    // TODO Internationalization
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0, // TODO ?
        ),
      ],
    );

    if (widget.post.replies != null) {
      for (Link link in widget.post.replies!.items) {
        ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
        Future<Activity> activityFuture =
            activityHandler.getActivity(link.href);

        children.add(
          FutureBuilder<Activity>(
            future: activityFuture,
            builder: (BuildContext context, AsyncSnapshot<Activity> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = PostView(
                  post: snapshot.data?.object,
                  accessToken: widget.accessToken,
                  appTitle: widget.appTitle,
                  userId: widget.userId,
                );
              } else if (snapshot.hasError) {
                child = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                );
              } else {
                child = const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                );
              }
              return child;
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}
