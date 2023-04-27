import 'package:fedodo_micro/Components/PostComponents/icon_bar.dart';
import 'package:fedodo_micro/APIs/ActivityPub/activity_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/likes_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/shares_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/activity.dart';
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
    required this.activity,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
    required this.domainName,
  }) : super(key: key);

  final Activity<Post> activity;
  final String accessToken;
  final String appTitle;
  final String userId;
  final String domainName;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  @override
  Widget build(BuildContext context) {
    LikesAPI likesProv = LikesAPI(
      widget.accessToken,
      widget.domainName,
      widget.userId,
    );
    SharesAPI sharesProvider = SharesAPI(
      widget.accessToken,
      widget.domainName,
      widget.userId,
    );

    var likesFuture = likesProv.getLikes(widget.activity.object.id);
    var sharesFuture = sharesProvider.getShares(widget.activity.object.id);

    List<Widget> children = [];
    children.addAll(
      [
        PostView(
          isClickable: false,
          activity: widget.activity,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          userId: widget.userId,
          domainName: widget.domainName,
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
                        .format(widget.activity.object.published.toLocal()),
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

    if (widget.activity.object.replies != null) {
      for (Link link in widget.activity.object.replies!.items) {
        ActivityAPI activityHandler = ActivityAPI(
          widget.accessToken,
          widget.userId,
          widget.domainName,
        );
        Future<Activity<Post>> activityFuture =
            activityHandler.getActivity(link.href);

        children.add(
          FutureBuilder<Activity<Post>>(
            future: activityFuture,
            builder:
                (BuildContext context, AsyncSnapshot<Activity<Post>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = PostView(
                  activity: snapshot.data!,
                  accessToken: widget.accessToken,
                  appTitle: widget.appTitle,
                  userId: widget.userId,
                  domainName: widget.domainName,
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
