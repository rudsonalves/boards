// import 'dart:developer';

// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// import '/core/models/address.dart';
// import '../interfaces/i_address_repository.dart';
// import 'common/constants.dart';
// import 'common/parse_to_model.dart';

// class PSAddressRepository implements IAddressRepository {
//   @override
//   Future<AddressModel?> add(AddressModel address) async {
//     try {
//       final parseAddress = ParseObject(keyAddressTable);

//       final parseUser = await ParseUser.currentUser() as ParseUser?;
//       if (parseUser == null) {
//         throw Exception('current user not found. Make a login');
//       }

//       if (address.id != null) {
//         parseAddress.objectId = address.id;
//       }

//       final parseAcl = ParseACL(owner: parseUser);
//       parseAcl.setPublicReadAccess(allowed: true);
//       parseAcl.setPublicWriteAccess(allowed: false);

//       parseAddress
//         ..setNonNull<ParseUser>(keyAddressOwner, parseUser)
//         ..setNonNull<String>(keyAddressName, address.name)
//         ..setNonNull<String>(keyAddressZipCode, address.zipCode)
//         ..setNonNull<String>(keyAddressStreet, address.street)
//         ..setNonNull<String>(keyAddressNumber, address.number)
//         ..setNonNull<String?>(keyAddressComplement, address.complement)
//         ..setNonNull<String>(keyAddressNeighborhood, address.neighborhood)
//         ..setNonNull<String>(keyAddressState, address.state)
//         ..setNonNull<String>(keyAddressCity, address.city)
//         ..setACL(parseAcl);

//       final response = await parseAddress.save();
//       if (!response.success) {
//         log('parseAddress.save error');
//         throw Exception(response.error.toString());
//       }

//       return ParseToModel.address(parseAddress);
//     } catch (err) {
//       final message = 'AddressRepository.save: $err';
//       log(message);
//       throw Exception(message);
//     }
//   }

//   @override
//   Future<bool> delete(String addressId) async {
//     try {
//       final parseAddress = ParseObject(keyAddressTable);
//       parseAddress.objectId = addressId;

//       final response = await parseAddress.delete();
//       if (!response.success) {
//         throw Exception(response.error?.message ?? 'unknown error');
//       }
//       return true;
//     } catch (err) {
//       final message = 'AddressRepository.delete: $err';
//       log(message);
//       throw Exception(message);
//     }
//   }

//   @override
//   Future<List<AddressModel>?> getUserAddresses(String userId) async {
//     try {
//       List<AddressModel>? addresses;

//       final parseAddress = ParseObject(keyAddressTable);

//       final parseUser = await ParseUser.currentUser() as ParseUser?;
//       if (parseUser == null) {
//         throw Exception('current user not found. Make login again.');
//       }

//       final queryBuilder = QueryBuilder<ParseObject>(parseAddress)
//         ..whereEqualTo(keyAddressOwner, parseUser.toPointer());

//       final response = await queryBuilder.query();
//       if (!response.success) {
//         throw Exception(response.error);
//       }

//       if (response.results == null || response.results!.isEmpty) return [];
//       addresses = response.results!
//           .map((parse) => ParseToModel.address(parse as ParseObject))
//           .toList();

//       return addresses;
//     } catch (err) {
//       final message = 'AddressRepository.getUserAddresses: $err';
//       log(message);
//       throw Exception(err);
//     }
//   }
// }
