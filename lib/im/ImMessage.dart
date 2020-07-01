
enum SessionType{
  P2P,
  Team
}

enum MessageType{
  text,
  image,
}

//IM 消息
class ImMessage{
  String from;
  String to;
  SessionType sessionType;
  MessageType messageType;

  factory ImMessage.createImMessage(){
    return null;
  }
}


