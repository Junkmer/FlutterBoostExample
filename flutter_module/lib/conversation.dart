import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'chat.dart';

class Conversation extends StatelessWidget {
  const Conversation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Message",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: TIMUIKitConversation(
        onTapItem: (selectedConv) {
          // 如果需要适配桌面端，此处需要参考 Demo 代码修改。
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Chat(
          //         selectedConversation: selectedConv,
          //       ),
          //     ));
          BoostNavigator.instance
              .push("chatPage", arguments: {"conversation":selectedConv});
        },
      ),
    );
  }
}