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

import 'dart:developer';

import '/data/models/message.dart';
import '/logic/managers/messages_manager.dart';
import '/core/get_it.dart';
import '/core/singletons/current_user.dart';
import 'message_store.dart';

class MessageController {
  final MessageStore store;
  final String adId;
  final String owneId;

  MessageController({
    required this.store,
    required this.adId,
    required this.owneId,
  });

  final user = getIt<CurrentUser>().user;
  final messagesManager = getIt<MessagesManager>();

  List<MessageModel> get messages => messagesManager.messages;

  Future<void> sendMessage([String? targetId]) async {
    try {
      store.setStateLoading();
      final result = await messagesManager.sendMessage(
        adId: adId,
        ownerId: owneId,
        msg: store.messageController.text,
        targetUserId: targetId,
      );
      if (result.isFailure) {
        if (result.error != null && result.error!.code == 1000) {
          store.setError('É preciso estar logado para enviar uma mensagem.');
          return;
        }
        throw Exception('Unknow error');
      }

      store.messageController.text = '';

      store.setStateSuccess();
    } catch (err) {
      log('Messagecontroller.sendMessage: $err');
      store.setError('Desculpe. Ocorreu um erro.');
    }
  }

  Future<void> readMessages() async {
    try {
      store.setStateLoading();
      final result = await messagesManager.readMessages(adId);
      if (result.isFailure) {
        if (result.error != null && result.error!.code == 1000) {
          store.setError('É preciso estar logado para enviar uma mensagem.');
          return;
        }
        throw Exception('Unknow error');
      }

      if (messages.isEmpty) {
        store.setError('Não há mensagens para este anúncio.');
        return;
      }

      store.setStateSuccess();
    } catch (err) {
      log('MessageController.readMessages: $err');
      store.setError(err.toString());
    }
  }
}
