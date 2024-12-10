import 'dart:io';

import '../edit_ad_store.dart';

class ImageListController {
  late final EditAdStore store;

  List<String> get images => store.ad.images;

  void init(EditAdStore store) {
    this.store = store;
  }

  void addImage(String image) {
    store.addImage(image);
  }

  void removeImage(int index) {
    final image = images[index];
    store.removeImage(image);
    if (!image.startsWith('http')) {
      final file = File(image);
      file.delete();
    }
  }
}
