import '/core/models/address.dart';

class AddressRepositoryException implements Exception {
  final String message;
  AddressRepositoryException(this.message);

  @override
  String toString() => 'AdRepositoryException: $message';
}

abstract class IAddressRepository {
  Future<AddressModel?> save(AddressModel address);
  Future<bool> delete(String addressId);
  Future<List<AddressModel>?> getUserAddresses(String userId);
}
