import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;
import '../../Globals/global_settings.dart';

class FollowersAPI {
  FollowersAPI();

  Future<OrderedPagedCollection> getFollowers(String followerEndpoint) async {

    Uri followerEndpointUri = Uri.parse(followerEndpoint);

    if(followerEndpointUri.authority != GlobalSettings.domainName){
      followerEndpointUri = followerEndpointUri.asProxyUri();
    }

    http.Response response = await http.get(
      followerEndpointUri,
      headers: <String, String>{
        "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
