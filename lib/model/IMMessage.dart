import 'dart:typed_data';

import 'package:imclient/core/Account.dart';
import 'package:imclient/core/Codes.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/util/GenUtil.dart';
import 'package:imclient/util/TimeUtil.dart';
import 'package:imclient/model/Login.dart';
import 'package:imclient/model/AuthBaseBean.dart';

//会话类型
enum SessionType {
  P2P, //0
  TEAM, //1
}

//消息方法  发出 or 接收
enum MessageDirection { IN, OUT }

enum MessageType {
  text, //文本 0
  image, //图片 1
  audio, // 音频 2
  video, // 视频 3
  file, //文件 4
  stick, // 贴图表情5
  tip, //提示 6
  custom, //自定义 7
}

//消息状态
enum MessageState {
  init, //
  sending,
  sendSuccess,
  sendFailed,
  readed,
  error
}

//IM消息结构体
class IMMessage extends Codec {
  int msgUuid; //消息唯一标识
  int createTime; //创建时间
  int updateTime; //更新时间
  int from; //消息发出者
  int to; //消息接收者
  SessionType sessionType; // 会话类型 1.p2p   2.team
  MessageType messageType; // 消息类型
  MessageDirection direction; //消息方向
  MessageState state; //消息状态

  String content; //消息内容
  String config; //配置
  String attachJsonStr;
  String extra; //

  dynamic attachment; //附件

  static IMMessage createBaseIMMessage(SessionType sessionType, int toUid) {
    if (!Account.isLogin()) {
      return null;
    }

    IMMessage imMessage = new IMMessage();
    imMessage.msgUuid = GenUtil.genUuid();
    int time = TimeUtil.getNowMilliseconds();
    imMessage.createTime = time;
    imMessage.updateTime = time;
    imMessage.from = Account.getUid();
    imMessage.to = toUid;
    imMessage.sessionType = sessionType;
    imMessage.direction = MessageDirection.OUT;
    imMessage.state = MessageState.init;
    return imMessage;
  }

  //创建文本类型消息
  static IMMessage createTextIMMessage(
      SessionType sessionType, int toUid, String content) {
    IMMessage imMessage = createBaseIMMessage(sessionType, toUid);

    //set message type
    imMessage.messageType = MessageType.text;
    imMessage.content = content;

    return imMessage;
  }

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    msgUuid = readInt64(rawData);
    createTime = readInt64(rawData);
    updateTime = readInt64(rawData);
    from = readInt64(rawData);
    to = readInt64(rawData);

    int sessionTypeValue = readInt8(rawData);
    sessionType = SessionType.values[sessionTypeValue];

    int messageTypeValue = readInt8(rawData);
    messageType = MessageType.values[messageTypeValue];

    int messageDirectionValue = readInt8(rawData);
    direction = MessageDirection.values[messageDirectionValue];

    int stateValue = readInt8(rawData);
    state = MessageState.values[stateValue];

    content = readString(rawData);
    config = readString(rawData);
    attachJsonStr = readString(rawData);
    extra = readString(rawData);

    switch (messageType) {
      case MessageType.text:
        break;
      case MessageType.image:
        break;
      case MessageType.audio:
        break;
      case MessageType.video:
        break;
      case MessageType.file:
        break;
      case MessageType.stick:
        break;
      case MessageType.tip:
        break;
      case MessageType.custom:
        break;
      default:
        break;
    } //end switch

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    //result.add(writeInt32(resultCode));
    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  @override
  bool needResend() {
    return true;
  }

  @override
  int getCode() {
    return 0;
  }
} //end class


//发送IM消息packet
class SendIMMessagePacket extends AuthBaseBean{
  IMMessage imMessage;
  
  SendIMMessagePacket() : super(Account.getToken());

  @override
  int decodeModel(Uint8List rawData) {
    return getReadIndex();
  }

  //是否有超时重发确认机制  
  bool needResend() {
    return true;
  }

  @override
  Uint8List encodeModel(List<Uint8List> result) {
    Uint8List imMessageUint8List = imMessage.encode();
    result.add(imMessageUint8List);
    return imMessageUint8List;
  }

  @override
  int getCode() {
    return Codes.CODE_IMMESSAGE_SEND;
  }
}//end class


