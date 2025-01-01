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
import '../edit_ad_store.dart';
import 'image_list_controller.dart';
import '../widgets/horizontal_image_gallery.dart';

class ImagesListView extends StatefulWidget {
  final EditAdStore store;

  const ImagesListView({
    super.key,
    required this.store,
  });

  @override
  State<ImagesListView> createState() => _ImagesListViewState();
}

class _ImagesListViewState extends State<ImagesListView> {
  final ctrl = ImageListController();

  EditAdStore get store => widget.store;

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.onSecondary
                : colorScheme.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 150,
          child: ValueListenableBuilder(
            valueListenable: store.updateImages,
            builder: (context, erroString, _) => HotizontalImageGallery(
              store: store,
              addImage: ctrl.addImage,
              removeImage: ctrl.removeImage,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: store.errorImages,
          builder: (context, message, _) {
            if (message == null) {
              return Container();
            } else {
              return Text(
                message,
                style:
                    AppTextStyle.font12Bold.copyWith(color: colorScheme.error),
              );
            }
          },
        )
      ],
    );
  }
}
