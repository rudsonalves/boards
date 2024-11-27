import 'package:flutter/material.dart';

import '/core/models/ad.dart';
import '/core/theme/app_text_style.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(AdStatus newStatus) setProductStatus;

  const MyTabBar({
    super.key,
    required this.setProductStatus,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(
          icon: const Icon(Icons.hourglass_empty),
          child: Text(
            'Pendentes',
            style: AppTextStyle.font14Thin,
          ),
        ),
        Tab(
          icon: const Icon(Icons.verified),
          child: Text(
            'Ativos',
            style: AppTextStyle.font14,
          ),
        ),
        Tab(
          icon: const Icon(Icons.attach_money),
          child: Text(
            'Vendidos',
            style: AppTextStyle.font14,
          ),
        ),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            setProductStatus(AdStatus.pending);
            break;
          case 1:
            setProductStatus(AdStatus.active);
            break;
          case 2:
            setProductStatus(AdStatus.sold);
            break;
        }
      },
    );
  }
}
