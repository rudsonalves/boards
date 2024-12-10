import 'package:flutter/material.dart';

import '../../addresses/addresses_screen.dart';
import '../my_data/my_data_screen.dart';
import '../../shop/product/widgets/title_product.dart';

class ConfigHooks extends StatelessWidget {
  const ConfigHooks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleProduct(title: 'Meus Dados', color: primary),
        ListTile(
          leading: Icon(Icons.person, color: primary),
          title: Text('Dados', style: TextStyle(color: primary)),
          onTap: () => Navigator.pushNamed(context, MyDataScreen.routeName),
        ),
        ListTile(
          leading: Icon(Icons.contact_mail_rounded, color: primary),
          title: Text('Endereços', style: TextStyle(color: primary)),
          onTap: () => Navigator.pushNamed(context, AddressesScreen.routeName),
        ),
      ],
    );
  }
}
