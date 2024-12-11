// ignore_for_file: public_member_api_docs, sort_constructors_first

import '/data/repository/interfaces/remote/i_message_repository.dart';
import '/core/get_it.dart';
import '/core/singletons/current_user.dart';
import '/data/models/message.dart';
import 'message_store.dart';

class MessageController {
  final MessageStore store;
  final String adId;
  final String onweId;

  MessageController({
    required this.store,
    required this.adId,
    required this.onweId,
  });

  final user = getIt<CurrentUser>().user;
  final messageRepository = getIt<IMessageRepository>();

  Future<void> sendMessage() async {
    try {
      if (user == null) {
        throw Exception('É preciso estar logado para enviar uma mensagem'
            ' para o vendedor.');
      }
      store.setStateLoading();
      final message = MessageModel(
        senderId: user!.id!,
        senderName: user!.name!,
        ownerId: onweId,
        text: store.messageController.text,
      );
      store.messageController.text = '';
      final result = await messageRepository.sendMessage(
        adId: adId,
        message: message,
      );
      if (result.isFailure) {
        throw Exception('Desculpe. Ocorreu um erro.');
      }

      store.setStateSuccess();
    } catch (err) {
      store.setError(err.toString());
    }
  }

  Future<void> readMessages() async {
    try {
      if (user == null) {
        throw Exception('É preciso estar logado para enviar uma mensagem'
            ' para o vendedor.');
      }
      store.setStateLoading();
      final result = await messageRepository.get(adId);
      if (result.isFailure) {
        throw Exception('Desculpe. Ocorreu um erro.');
      }
      await Future.delayed(Duration(seconds: 5));

      final messages = result.data ?? [];
      store.setMessages(messages);

      store.setStateSuccess();
    } catch (err) {
      store.setError(err.toString());
    }
  }
}
