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

import '/core/theme/app_text_style.dart';

class ShopTextTitle extends StatelessWidget {
  final String label;

  const ShopTextTitle({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Text(
      label,
      style: AppTextStyle.font15SemiBold.copyWith(color: primary),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
