import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNotifications extends StatefulWidget {
  const AddNotifications({Key? key}) : super(key: key);

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  List tokenIdList = [];
  var users = FirebaseFirestore.instance.collection('users').doc().get();

  Future<Response> sendNotification(
    String url,
    String contents,
  ) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization':
            'Basic ZjQ1OTQ2ZWEtYjYxMC00MzdmLTlhMGUtM2U5ZTNhYTkwNzQz'
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "a942c389-8dd1-428f-8e49-f6c2e78f1ee7",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon":
            "https://lajmi.net/wp-content/uploads/2022/03/cropped-274911459_510490313991928_5833048493577778828_n.jpg",
        "headings": {"en": "lajmi.net"},
        "contents": {"en": contents},
        "included_segments": ["Subscribed Users"],
      }),
    );
  }

  var contentController = TextEditingController();
  var urlController = TextEditingController();
  var imageUrlController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextFormField(
                      maxLines: 5,
                      controller: contentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Content'),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'URL'),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'imageUrl'),
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(52, 72, 172, 2),
                    ),
                    onPressed: () async {
                      var res = sendNotification(
                        urlController.text,
                        contentController.text,
                      );
                      var notifications = await FirebaseFirestore.instance
                          .collection('notifications')
                          .doc();
                      notifications.set({
                        'createdAt': DateTime.now(),
                        'id': notifications.id,
                        'content': contentController.text,
                        'url': urlController.text,
                        'imageUrl': imageUrlController.text.isEmpty
                            ? 'https://pbs.twimg.com/profile_images/1498880488869662721/bre-zF3r_400x400.jpg'
                            : imageUrlController.text,
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification u dërgua'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    },
                    child: const Text('Dergo notification')),
              )
            ],
          )
        ],
      ),
    );
  }
}
