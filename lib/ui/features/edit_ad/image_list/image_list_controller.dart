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
