import '../../../core/abstracts/data_result.dart';
import '/core/models/address.dart';

class AddressRepositoryException implements Exception {
  final String message;
  AddressRepositoryException(this.message);

  @override
  String toString() => 'AdRepositoryException: $message';
}

abstract class IAddressRepository {
  Future<DataResult<AddressModel?>> add(AddressModel address);
  Future<DataResult<void>> delete(String addressId);
  Future<DataResult<List<AddressModel>?>> getUserAddresses(String userId);
}
