import 'package:flutter/material.dart';

import '../../core/models/ad.dart';
import '../../core/models/address.dart';
import '../../core/models/boardgame.dart';
import '../../core/utils/validators.dart';
import '../../core/state/state_store.dart';

class EditAdStore extends StateStore {
  late AdModel ad;

  final errorName = ValueNotifier<String?>(null);
  final errorDescription = ValueNotifier<String?>(null);
  final errorAddress = ValueNotifier<String?>(null);
  final errorPrice = ValueNotifier<String?>(null);
  final errorImages = ValueNotifier<String?>(null);
  final updateImages = ValueNotifier<int>(0);
  final bgInfo = ValueNotifier<String?>(null);

  void init(AdModel? ad) {
    this.ad = ad?.copyWith() ??
        AdModel(
          images: [],
          title: '',
          description: '',
          mechanicsIds: [],
          price: 0,
        );
  }

  @override
  void dispose() {
    super.dispose();
    errorName.dispose();
    errorDescription.dispose();
    errorAddress.dispose();
    errorPrice.dispose();
    errorImages.dispose();
    updateImages.dispose();
  }

  void addImage(String image) {
    if (ad.images.contains(image)) return;
    updateImages.value++;
    ad.images.add(image);
    _validateImages();
  }

  void removeImage(String image) {
    if (!ad.images.contains(image)) return;
    updateImages.value++;
    ad.images.remove(image);
    _validateImages();
  }

  void moveImaveLeft(int index) {
    if (index == 0) return;
    final auxImage = ad.images[index];
    ad.images[index] = ad.images[index - 1];
    ad.images[index - 1] = auxImage;
    updateImages.value++;
  }

  void moveImageRight(int index) {
    if (index + 1 == ad.images.length) return;
    final auxImage = ad.images[index];
    ad.images[index] = ad.images[index + 1];
    ad.images[index + 1] = auxImage;
    updateImages.value++;
  }

  void _validateImages() {
    errorImages.value =
        ad.images.length > 2 ? null : 'Adicione ao menos duas imagens.';
  }

  void setName(String value) {
    ad.title = value;
    _validateName();
  }

  void _validateName() {
    errorName.value = Validator.name(ad.title);
  }

  void setDescription(String value) {
    ad.description = value;
    _validateDescription();
  }

  void _validateDescription() {
    errorDescription.value = ad.description.length > 12
        ? null
        : 'Dê uma descrição melhor sobre o estado do produto.';
  }

  void setAddress(AddressModel value) {
    ad.ownerCity = value.city;
    ad.ownerState = value.state;
    _validateAddress();
  }

  void _validateAddress() {
    errorAddress.value = ad.ownerCity != null && ad.ownerState != null
        ? null
        : 'Selecione um endereço valido.';
  }

  void setPrice(double value) {
    ad.price = value;
    _validatePrice();
  }

  void _validatePrice() {
    errorPrice.value = ad.price > 0 ? null : 'Preencha o valor de seu produto.';
  }

  void setMechanics(List<String> mechs) {
    ad.mechanicsIds = mechs;
  }

  void setQuantity(int value) {
    ad.quantity = value;
  }

  void setStatus(AdStatus value) {
    ad.status = value;
  }

  void setCondition(ProductCondition value) {
    ad.condition = value;
  }

  void setBGInfo(BoardgameModel bg) {
    ad.boardgameId = bg.id;
    addImage(bg.image);
    bgInfo.value = ad.boardgameId.toString();
  }

  bool get isValid {
    _validateName();
    _validateDescription();
    _validateAddress();
    _validatePrice();
    _validateImages();

    return errorImages.value == null &&
        errorName.value == null &&
        errorDescription.value == null &&
        errorAddress.value == null &&
        errorPrice.value == null;
  }

  void resetStore() {
    errorName.value = null;
    errorDescription.value = null;
    errorAddress.value = null;
    errorPrice.value = null;
    errorImages.value = null;
  }
}
