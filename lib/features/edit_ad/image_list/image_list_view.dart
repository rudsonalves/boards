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
                : colorScheme.primary.withOpacity(0.25),
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
