import 'package:flutter/material.dart';

class TextFormDropdown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final TextEditingController controller;
  final void Function(String value) submitItem;
  final FocusNode? focusNode;

  const TextFormDropdown({
    super.key,
    required this.items,
    this.hintText,
    required this.controller,
    required this.submitItem,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: 4,
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Column(
            children: [
              TextFormField(
                focusNode: focusNode,
                controller: controller,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onEditingComplete: () {
                  submitItem(controller.text);
                  FocusScope.of(context).nextFocus();
                },
              ),
              if (controller.text.isNotEmpty)
                Card(
                  child: Builder(
                    builder: (context) {
                      final matchItems = items
                          .where((i) => i.toLowerCase().contains(
                                RegExp(r'^' + controller.text.toLowerCase()),
                              ))
                          .toList();
                      matchItems.removeWhere((i) =>
                          i.toLowerCase() == controller.text.toLowerCase());
                      final maxHeight = 54.0 *
                          (matchItems.length < 3 ? matchItems.length : 3);
                      return SizedBox(
                        height: maxHeight,
                        child: ListView.builder(
                          itemCount: matchItems.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(matchItems[index]),
                            onTap: () {
                              controller.text = matchItems[index];
                              submitItem(controller.text);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
