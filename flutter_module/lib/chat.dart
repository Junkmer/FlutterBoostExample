import 'package:flutter/material.dart';
import 'package:flutter_module/user_profile.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class Chat extends StatelessWidget {
  final V2TimConversation selectedConversation;

  const Chat({Key? key, required this.selectedConversation}) : super(key: key);

  String? _getConvID() {
    return selectedConversation.type == 1
        ? selectedConversation.userID
        : selectedConversation.groupID;
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      conversation: selectedConversation,
      onTapAvatar: (userID, tapDetails) {
        // 如果需要适配桌面端，此处需要参考 Demo 代码修改。
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userID: userID),
            ));
      }, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }
}