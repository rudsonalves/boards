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

import '../../../../../data/models/ad.dart';
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
