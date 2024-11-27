import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/bag_item.dart';
import '../../../data_managers/bag_manager.dart';
import '../../../get_it.dart';

class QuantityButtons extends StatelessWidget {
  final BagItemModel item;

  QuantityButtons({
    super.key,
    required this.item,
  });

  final bagManager = getIt<BagManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Material(
                child: InkWell(
                  onTap: () => bagManager.decreaseQt(item.adId),
                  child: ValueListenableBuilder(
                      valueListenable: bagManager.itemsCount,
                      builder: (context, _, __) {
                        return Icon(
                          item.quantity == 1 ? Symbols.delete : Symbols.remove,
                          size: 18,
                        );
                      }),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: bagManager.itemsCount,
              builder: (context, _, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(item.quantity.toString()),
              ),
            ),
            ClipOval(
              child: Material(
                child: InkWell(
                  onTap: () => bagManager.increaseQt(item.adId),
                  child: Icon(
                    Symbols.add,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
