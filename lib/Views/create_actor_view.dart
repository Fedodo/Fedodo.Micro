import 'package:fedodo_micro/APIs/ActivityPub/actor_api.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CreateActorView extends StatelessWidget {
   CreateActorView({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final userNameController = TextEditingController();
   final summaryController = TextEditingController();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fedodo Micro",
          style: TextStyle(
            fontFamily: "Righteous",
            fontSize: 25,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                hintText: 'Name of the profile',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: summaryController,
              decoration: const InputDecoration(
                hintText: 'Description of your profile',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var token = JwtDecoder.decode(Preferences.prefs!.getString("AccessToken")!);
                  String userId = token["sub"];

                  ActorAPI actorApi = ActorAPI();
                  actorApi.createActor(userId, userNameController.text, summaryController.text);
                }
              },
              child: const Text("Create Actor"),
            ),
          ],
        ),
      ),
    );
  }
}
