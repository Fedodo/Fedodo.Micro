import 'package:fedodo_micro/Models/ActivityPub/endpoints.dart';
import 'package:fedodo_micro/Models/ActivityPub/public_key.dart';
import 'package:fedodo_micro/Models/ActivityPub/media.dart';

class Actor {
  final List<dynamic>? context;
  final String? id;
  final String? type;
  final String? name;
  final String? preferredUsername;
  final String? summary;
  final String? inbox;
  final String? outbox;
  final String? followers;
  final String? following;
  final Media? icon;
  final PublicKey? publicKey;
  final Endpoints? endpoints;
  final DateTime? published;

  Actor(
    this.context,
    this.id,
    this.type,
    this.name,
    this.preferredUsername,
    this.summary,
    this.inbox,
    this.outbox,
    this.followers,
    this.following,
    this.icon,
    this.publicKey,
    this.endpoints,
    this.published,
  );

  Actor.fromJson(Map<String, dynamic> json)
      : context = json["@context"],
        id = json["id"],
        type = json["type"],
        name = json["name"],
        preferredUsername = json["preferredUsername"],
        summary = json["summary"],
        inbox = json["inbox"],
        outbox = json["outbox"],
        followers = json["followers"],
        following = json["following"],
        icon = getMedia(json["icon"]),
        publicKey = PublicKey.fromJson(json["publicKey"]),
        endpoints = Endpoints.fromJson(json["endpoints"]),
        published = DateTime.tryParse(json["published"]);

  static Media? getMedia(dynamic json) {
    if (json != null) {
      Media? media = Media.fromJson(json);
      return media;
    }

    return null;
  }
}
