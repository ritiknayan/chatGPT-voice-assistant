import 'package:chatgpt_assistant/constants/colors.dart';
import 'package:chatgpt_assistant/models/chat_model.dart';
import 'package:flutter/material.dart';

Widget chatBubble({required chattext, required ChatMessageType? type}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        backgroundColor: kBgColor,
        child: type == ChatMessageType.bot
            ? ClipOval(child: Image.asset('assets/icon.jpg',colorBlendMode: BlendMode.clear,))
            : const Icon(
                Icons.person,
                color: Colors.lightGreenAccent,
              ),
      ),
      const SizedBox(
        width: 12,
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: type == ChatMessageType.bot ? kBgColor : Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Text(
            "$chattext",
            style: TextStyle(
                color: type == ChatMessageType.bot ? kTextColor : kChatBgColor,
                fontSize: 15,
                fontWeight: type == ChatMessageType.bot
                    ? FontWeight.w600
                    : FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
