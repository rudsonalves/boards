// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'package:boards/data/models/message.dart';

import '/core/abstracts/data_result.dart';
import '/core/singletons/current_user.dart';
import '/data/repository/interfaces/remote/i_message_repository.dart';
import '/core/get_it.dart';

class MessagesManager {
  final messagesRepository = getIt<IMessageRepository>();

  final List<MessageModel> _messages = [];
  final user = getIt<CurrentUser>().user;
  final messageRepository = getIt<IMessageRepository>();

  List<MessageModel> get messages => _messages;

  bool started = false;

  Future<DataResult<void>> sendMessage({
    required String adId,
    required String ownerId,
    required String msg,
    String? targetUserId,
  }) async {
    try {
      if (user == null) {
        return DataResult.failure(
            GenericFailure(message: 'User is not authenticated', code: 1000));
      }

      String? targetId = targetUserId;
      targetId ??= user!.id! != ownerId ? ownerId : null;
      final message = MessageModel(
        senderId: user!.id!,
        senderName: user!.name!,
        ownerId: ownerId,
        targetUserId: targetId,
        text: msg,
      );
      final result = await messageRepository.sendMessage(
        adId: adId,
        message: message,
      );
      if (result.isFailure) {
        throw Exception(result.error ?? 'Unknow error');
      }

      final newMessage = result.data!;
      _messages.insert(0, newMessage);
      return DataResult.success(null);
    } catch (err) {
      return DataResult.failure(
          GenericFailure(message: 'Unknow error', code: 1100));
    }
  }

  Future<DataResult<void>> readMessages(
    String adId,
  ) async {
    try {
      if (started) return DataResult.success(null);
      started = true;

      if (user == null) {
        return DataResult.failure(
            GenericFailure(message: 'User is not authenticated', code: 1000));
      }
      final result = await messageRepository.get(adId);
      if (result.isFailure) {
        return result;
      }

      _messages.clear();
      _messages.addAll(result.data ?? []);

      return DataResult.success(null);
    } catch (err) {
      return DataResult.failure(
          GenericFailure(message: 'Unknow error', code: 1100));
    }
  }
}
