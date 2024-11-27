import 'package:flutter/material.dart';

import '/core/theme/app_text_style.dart';
import '/get_it.dart';
import '/data_managers/addresses_manager.dart';
import '../../filters/widgets/text_title.dart';

class DestinyAddressDialog extends StatefulWidget {
  final List<String> addressNames;
  final String addressRemoveName;
  final int adsListLength;

  const DestinyAddressDialog({
    super.key,
    required this.addressNames,
    required this.addressRemoveName,
    required this.adsListLength,
  });

  static Future<String?> open(
    BuildContext context, {
    required List<String> addressNames,
    required String addressRemoveName,
    required int adsListLength,
  }) async {
    return await showDialog<String?>(
      context: context,
      builder: (_) => DestinyAddressDialog(
        addressNames: addressNames,
        addressRemoveName: addressRemoveName,
        adsListLength: adsListLength,
      ),
    );
  }

  @override
  State<DestinyAddressDialog> createState() => _DestinyAddressDialogState();
}

class _DestinyAddressDialogState extends State<DestinyAddressDialog> {
  final addressManager = getIt<AddressesManager>();
  String selected = '';
  late final int adsListLength;
  late final String s;
  late final List<String> avaliableAddress;

  @override
  void initState() {
    super.initState();
    adsListLength = widget.adsListLength;
    s = adsListLength > 1 ? 's' : '';

    avaliableAddress = addressManager.addressNames
        .where((name) => name != widget.addressRemoveName)
        .toList();
    selected = avaliableAddress[0];
  }

  List<String> dialogTexts() {
    return [
      'O endereço "${widget.addressRemoveName.toUpperCase()}" possui'
          ' $adsListLength anúcio$s vinculado$s.',
      'Para removê-lo é necessário Mover este$s anúcio$s para'
          ' outro endereço.',
      'Selecione um endereço destino para continuar, ou cancele a operação.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.onSecondary,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: TextTitle('Atenção')),
            const SizedBox(height: 8),
            ...dialogTexts().map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t,
                  style: AppTextStyle.font16,
                ),
              ),
            ),
            DropdownButton<String>(
              value: selected,
              items: avaliableAddress
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selected = value;
                  setState(() {});
                }
              },
            ),
            OverflowBar(
              children: [
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('Aplicar'),
                ),
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}