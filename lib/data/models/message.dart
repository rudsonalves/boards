class MessageModel {
  String? id;
  String senderId;
  String senderName;
  String ownerId;
  DateTime timestamp;
  String text;
  bool read;
  bool answered;
  String? targetUserId;
  String? parentMessageId;

  MessageModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.ownerId,
    DateTime? timestamp,
    required this.text,
    this.read = false,
    this.answered = false,
    this.targetUserId,
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
      'answered': answered,
      'targetUserId': targetUserId,
      'parentMessageId': parentMessageId,
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
      answered: map['answered'] as bool,
      targetUserId: map['targetUserId'] as String?,
      parentMessageId: map['parentMessageId'] != null
          ? map['parentMessageId'] as String
          : null,
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
        ' answered: $answered,'
        ' targetUserId: $targetUserId,'
        ' parentMessageId: $parentMessageId)';
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? ownerId,
    DateTime? timestamp,
    String? text,
    bool? read,
    bool? answered,
    String? targetUserId,
    String? parentMessageId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      ownerId: ownerId ?? this.ownerId,
      timestamp: timestamp ?? this.timestamp,
      text: text ?? this.text,
      read: read ?? this.read,
      answered: answered ?? this.answered,
      targetUserId: targetUserId ?? this.targetUserId,
      parentMessageId: parentMessageId ?? this.parentMessageId,
    );
  }
}
