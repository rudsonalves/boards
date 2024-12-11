import 'package:cloud_firestore/cloud_firestore.dart';

import 'common/data_functions.dart';
import '../../models/message.dart';
import '../interfaces/remote/i_message_repository.dart';
import '/core/abstracts/data_result.dart';
import 'common/errors_codes.dart';

class FbMessageRepository implements IMessageRepository {
  static const keyMessages = 'messages';
  static const keyMessageId = 'id';
  static const keyMessageRead = 'read';
  static const keyMessageAnswered = 'answered';
  static const keyMessageTimestamp = 'timestamp';
  static const keyAds = 'ads';

  CollectionReference<Map<String, dynamic>> get _adsCollection =>
      FirebaseFirestore.instance.collection(keyAds);

  CollectionReference<Map<String, dynamic>> _messageCollection(String adId) {
    return _adsCollection.doc(adId).collection(keyMessages);
  }

  @override
  Future<DataResult<List<MessageModel>>> get(String adId) async {
    try {
      final msgsDocs = await _messageCollection(adId)
          .orderBy(
            keyMessageTimestamp,
            descending: true,
          )
          .get();

      final messages = msgsDocs.docs
          .map((doc) => MessageModel.fromMap(doc.data()).copyWith(id: doc.id))
          .toList();

      return DataResult.success(messages);
    } catch (err) {
      return _handleError('get', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<MessageModel>> sendMessage({
    required String adId,
    required MessageModel message,
  }) async {
    try {
      // Add new message do ad with adId
      final doc = await _messageCollection(adId).add(
        message.toMap()..remove(keyMessageId),
      );

      // Update Message id
      final newMessage = message.copyWith(id: doc.id);

      return DataResult.success(newMessage);
    } catch (err) {
      return _handleError('sendMessage', err, ErrorCodes.unknownError);
    }
  }

  @override
  Future<DataResult<void>> updateStatus({
    required String adId,
    required String messageId,
    bool? read,
    bool? answered,
  }) async {
    try {
      if (read == null && answered == null) {
        return DataResult.success(null);
      }
      final doc = _messageCollection(adId).doc(messageId);

      final map = <String, dynamic>{};
      if (read != null) {
        map[keyMessageRead] = read;
      }
      if (answered != null) {
        map[keyMessageAnswered] = answered;
      }

      await doc.update(map);
      return DataResult.success(null);
    } catch (err) {
      return _handleError('updateStatus', err, ErrorCodes.unknownError);
    }
  }

  /// Handles and logs errors during repository operations.
  ///
  /// [module] - The module where the error occurred.
  /// [err] - The error object.
  /// [code] - An optional error code for custom handling.
  ///
  /// Returns a [DataResult] encapsulating the error.
  DataResult<T> _handleError<T>(String module, Object err, [int code = 0]) {
    return DataFunctions.handleError<T>(
        'FbMessageRepository', module, err, code);
  }
}
