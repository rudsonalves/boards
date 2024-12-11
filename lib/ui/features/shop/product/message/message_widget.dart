import 'package:boards/ui/features/shop/product/message/widget/chat_bubble.dart';
import 'package:flutter/material.dart';
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
      onweId: widget.ownerId,
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
                    itemCount: store.messages.length,
                    itemBuilder: (cotx, index) {
                      final message = store.messages[index];
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
                } else {
                  return Container();
                }
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
