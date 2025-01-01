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

import 'package:boards/ui/components/widgets/app_snackbar.dart';
import 'package:boards/ui/features/shop/product/message/widget/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../core/theme/app_text_style.dart';
import 'message_controller.dart';
import 'message_store.dart';

class MessageWidget extends StatefulWidget {
  final String adId;
  final String ownerId;

  const MessageWidget({
    super.key,
    required this.adId,
    required this.ownerId,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final store = MessageStore();
  late final MessageController ctrl;

  @override
  void initState() {
    super.initState();

    ctrl = MessageController(
      store: store,
      adId: widget.adId,
      owneId: widget.ownerId,
    );
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    ctrl.sendMessage();
  }

  void _showMessages() {
    ctrl.readMessages();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Perguntas e Respostas',
                style: AppTextStyle.font18SemiBold,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: store.messageController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Escreva sua pergunda',
                        hintStyle: TextStyle(
                          color: colorScheme.outlineVariant,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onEditingComplete: _sendMessage,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Symbols.send_rounded),
                ),
              ],
            ),
            ListenableBuilder(
              listenable: store.state,
              builder: (context, _) {
                if (store.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (store.isSuccess) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: ctrl.messages.length,
                    itemBuilder: (cotx, index) {
                      final message = ctrl.messages[index];
                      final isAdOwner = message.ownerId == message.senderId;

                      return ChatBubble(
                        widget: ListTile(
                          title: Text(message.senderName),
                          subtitle: Text(message.text),
                        ),
                        isAdOwner: isAdOwner,
                      );
                    },
                  );
                } else if (store.isError) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.show(
                      context,
                      message: store.errorMessage ??
                          'Ocorreu um erro. Tente mais tarde.',
                      onClosed: store.setStateSuccess,
                    );
                  });
                }
                return Container();
              },
            ),
            TextButton(
              onPressed: _showMessages,
              child: Text('Ver todas mensagens'),
            ),
          ],
        ),
      ),
    );
  }
}
