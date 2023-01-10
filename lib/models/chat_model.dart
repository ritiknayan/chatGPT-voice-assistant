// ignore_for_file: public_member_api_docs, sort_constructors_first

enum ChatMessageType { user, bot }

class ChatMessage {
  ChatMessage({
    required this.text,
    required this.type,
  });
  
  String? text;
  ChatMessageType? type;
}
