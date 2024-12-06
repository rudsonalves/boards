import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '/core/models/mechanic.dart';
import '/core/models/address.dart';
import '/core/models/ad.dart';
import '/core/models/bg_name.dart';
import '/core/models/boardgame.dart';
import '/core/models/favorite.dart';
import '/core/models/user.dart';
import 'constants.dart';

extension ParseObjectExtensions on ParseObject {
  void setNonNull<T>(String key, T? value) {
    if (value != null) {
      set<T>(key, value);
    }
  }
}

/// This class provides static methods to convert Parse objects to application
/// models.
class ParseToModel {
  ParseToModel._();

  /// Converts a ParseUser object to a UserModel.
  ///
  /// [parse] - The ParseUser object to convert.
  /// Returns a UserModel representing the ParseUser.
  static UserModel user(ParseUser parse) {
    return UserModel(
      id: parse.objectId,
      name: parse.get<String>(keyUserNickname),
      email: parse.username!,
      phone: parse.get<String>(keyUserPhone),
      role: UserRole.values
          .firstWhere((role) => role.name == parse.get<String>(keyUserRole)!),
      createdAt: parse.createdAt,
    );
  }

  /// Converts a ParseObject representing an address to an AddressModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns an AddressModel representing the ParseObject.
  static AddressModel address(ParseObject parse) {
    return AddressModel(
      id: parse.objectId,
      name: parse.get<String>(keyAddressName)!,
      zipCode: parse.get<String>(keyAddressZipCode)!,
      street: parse.get<String>(keyAddressStreet)!,
      number: parse.get<String>(keyAddressNumber)!,
      complement: parse.get<String?>(keyAddressComplement),
      neighborhood: parse.get<String>(keyAddressNeighborhood)!,
      state: parse.get<String>(keyAddressState)!,
      city: parse.get<String>(keyAddressCity)!,
      createdAt: parse.get<DateTime>(keyAddressCreatedAt)!,
    );
  }

  /// Converts a ParseObject representing an advertisement to an AdModel.
  ///
  /// [parse] - The ParseObject to convert.
  /// Returns an AdModel representing the ParseObject if the address and
  /// user are not null, otherwise returns null.
  static AdModel? ad(ParseObject parse, [bool full = false]) {
    AddressModel? address;
    UserModel? user;

    if (full) {
      final parseAddress = parse.get<ParseObject?>(keyAdAddress);
      if (parseAddress == null) return null;
      address = ParseToModel.address(parseAddress);

      final parseUser = parse.get<ParseUser?>(keyAdOwner);
      if (parseUser == null) return null;
      user = ParseToModel.user(parseUser);
    }

    final mechs = parse.get<List<dynamic>>(keyAdMechanics) ?? [];

    return AdModel(
      id: parse.objectId,
      owner: user,
      ownerId: parse.get<String>(keyAdOwnerId)!,
      ownerName: parse.get<String>(keyAdOwnerName)!,
      ownerRate: parse.get<double>(keyAdOwnerRate)!,
      ownerCity: parse.get<String>(keyAdOwnerCity)!,
      ownerCreateAt: parse.get<DateTime>(keyAdOwnerCreatedAt)!,
      title: parse.get<String>(keyAdTitle)!,
      description: parse.get<String>(keyAdDescription)!,
      price: parse.get<num>(keyAdPrice)!.toDouble(),
      quantity: parse.get<int>(keyAdQuantity)!,
      images: (parse.get<List<dynamic>>(keyAdImages) as List<dynamic>)
          .map((item) => (item as ParseFile).url!)
          .toList(),
      mechanicsIds: mechs.map((element) => element as String).toList(),
      address: address,
      status: AdStatus.values
          .firstWhere((s) => s.name == parse.get<String>(keyAdStatus)!),
      condition: ProductCondition.values
          .firstWhere((c) => c.name == parse.get<String>(keyAdCondition)!),
      views: parse.get<int>(keyAdViews, defaultValue: 0)!,
      createdAt: parse.get<DateTime>(keyAdCreatedAt)!,
    );
  }

  static FavoriteModel favorite(ParseObject parse) {
    final adMap = parse.get(keyFavoriteAd);

    return FavoriteModel(
      id: parse.objectId,
      adId: adMap['objectId'],
      userId: '',
    );
  }

  static BoardgameModel boardgameModel(ParseObject parse) {
    final mechs = parse.get<List<dynamic>>(keyBgMechanics)!;

    return BoardgameModel(
      id: parse.objectId,
      name: parse.get<String>(keyBgName)!,
      image: parse.get<ParseFile>(keyBgImage)!.url!,
      publishYear: parse.get<int>(keyBgPublishYear)!,
      minPlayers: parse.get<int>(keyBgMinPlayers)!,
      maxPlayers: parse.get<int>(keyBgMaxPlayers)!,
      minTime: parse.get<int>(keyBgMinTime)!,
      maxTime: parse.get<int>(keyBgMaxTime)!,
      minAge: parse.get<int>(keyBgMinAge)!,
      designer: parse.get<String?>(keyBgDesigner)!,
      artist: parse.get<String?>(keyBgArtist)!,
      description: parse.get<String?>(keyBgDescription)!,
      mechIds: mechs.map((item) => item as String).toList(),
    );
  }

  static BGNameModel bgNameModel(ParseObject parse) {
    String name = parse.get<String>(keyBgName)!;
    int year = parse.get<int>(keyBgPublishYear)!;

    return BGNameModel(
      id: parse.objectId!,
      name: '$name ($year)',
    );
  }

  static MechanicModel mechanic(ParseObject parse) {
    return MechanicModel(
      id: parse.objectId,
      name: parse.get<String>(keyMechanicName)!,
      description: parse.get<String>(keyMechanicDescription)!,
    );
  }
}
