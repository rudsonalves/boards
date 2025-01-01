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

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../data/models/bag_item.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../logic/managers/bag_manager.dart';
import '../../../../core/get_it.dart';
import '../bag_controller.dart';
import 'bag_sub_total.dart';
import 'quantity_buttons.dart';

class SallerBag extends StatefulWidget {
  final BagController ctrl;
  final String sallerId;
  final String sallerName;
  final void Function(String) openAd;
  final void Function(List<BagItemModel>) makePayment;

  const SallerBag({
    super.key,
    required this.ctrl,
    required this.sallerId,
    required this.sallerName,
    required this.openAd,
    required this.makePayment,
  });

  @override
  State<SallerBag> createState() => _SallerBagState();
}

class _SallerBagState extends State<SallerBag> {
  final bagManager = getIt<BagManager>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = widget.ctrl.items(widget.sallerId).toList();

    return Card(
      color: colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vendido por ${widget.sallerName}',
              style:
                  AppTextStyle.font16Bold.copyWith(color: colorScheme.primary),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item', style: AppTextStyle.font14Bold),
                  Text('Preço', style: AppTextStyle.font14Bold),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                final double size = 60;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () => widget.openAd(item.adId),
                          child: Container(
                            width: size,
                            height: size,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.network(item.ad!.images.first),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.font16Bold,
                            ),
                            Text(
                              item.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.font12,
                            ),
                            QuantityButtons(
                              item: item,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '\$${item.unitPrice.toStringAsFixed(2)}',
                            style: AppTextStyle.font16Bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            ListenableBuilder(
                listenable: bagManager.itemsCount,
                builder: (context, _) {
                  return BagSubTotal(
                    length: items.fold(0, (sum, item) => sum + item.quantity),
                    total: bagManager.total(widget.sallerId),
                  );
                }),
            FilledButton.icon(
              onPressed: () => widget.makePayment(items),
              label: Text('Efetuar o Pagamento'),
              icon: Icon(Symbols.encrypted_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
