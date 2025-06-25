import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class UserProfile extends StatelessWidget {
  final String userID;
  const UserProfile({required this.userID, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: TIMUIKitProfile(
        userID: userID,
      ),
    );
  }
}