class MessageModel {
  String? id;
  String senderId;
  String senderName;
  String ownerId;
  DateTime timestamp;
  String text;
  bool read;
  String? parentMessageId;
  bool answered;

  MessageModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.ownerId,
    DateTime? timestamp,
    required this.text,
    this.read = false,
    this.answered = false,
    this.parentMessageId,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'ownerId': ownerId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'text': text,
      'read': read,
      'parentMessageId': parentMessageId,
      'answered': answered,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] != null ? map['id'] as String : null,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      ownerId: map['ownerId'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      text: map['text'] as String,
      read: map['read'] as bool,
      parentMessageId: map['parentMessageId'] != null
          ? map['parentMessageId'] as String
          : null,
      answered: map['answered'] as bool,
    );
  }

  @override
  String toString() {
    return 'MessageModel(id: $id,'
        ' senderId: $senderId,'
        ' senderName: $senderName,'
        ' ownerId: $ownerId,'
        ' timestamp: $timestamp,'
        ' text: $text,'
        ' read: $read,'
        ' parentMessageId: $parentMessageId,'
        ' answered: $answered)';
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? ownerId,
    DateTime? timestamp,
    String? text,
    bool? read,
    String? parentMessageId,
    bool? answered,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      ownerId: ownerId ?? this.ownerId,
      timestamp: timestamp ?? this.timestamp,
      text: text ?? this.text,
      read: read ?? this.read,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      answered: answered ?? this.answered,
    );
  }
}
