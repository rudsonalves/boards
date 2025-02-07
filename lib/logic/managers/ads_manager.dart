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

import '/core/abstracts/data_result.dart';
import '/data/models/ad.dart';
import '/data/models/filter.dart';
import '/core/singletons/search_filter.dart';
import '/core/get_it.dart';
import '/data/repository/firebase/common/constantes.dart';
import '/data/repository/interfaces/remote/i_ads_repository.dart';

class AdsManager {
  final adRepository = getIt<IAdsRepository>();
  final searchFilter = getIt<SearchFilter>();

  final List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;

  FilterModel get filter => searchFilter.filter;

  Future<DataResult<AdModel?>> add(AdModel ad) async {
    final result = await adRepository.add(ad);

    if (result.isFailure || result.data == null) return result;

    // update _ads
    _ads.insert(0, result.data!);
    return result;
  }

  Future<DataResult<List<AdModel>?>> getMyAds({
    required String ownerId,
    required AdStatus status,
  }) async {
    return await adRepository.getMyAds(
      ownerId: ownerId,
      status: status,
    );
  }

  Future<DataResult<List<AdModel>?>> get({
    required FilterModel filter,
    required String search,
    int page = 0,
  }) async {
    return adRepository.get(filter: filter, search: search, page: page);
  }

  Future<DataResult<AdModel?>> update(AdModel ad) async {
    final result = await adRepository.update(ad);

    if (result.isFailure || result.data == null) return result;

    // update _ads
    final index = _ads.indexWhere((item) => item.id == ad.id);
    if (index >= 0) _ads[index] = result.data!;

    return result;
  }

  Future<DataResult<void>> updateStatus({
    required String adsId,
    required AdStatus status,
    required int quantity,
  }) async {
    return adRepository.updateStatus(
      adsId: adsId,
      status: status,
      quantity: quantity,
    );
  }

  Future<bool> getAds() async {
    bool getMorePages = false;

    final result = await adRepository.get(
      filter: filter,
      search: searchFilter.searchString,
    );
    if (result.isFailure) {
      // FIXME: Complete this error handling
      throw Exception('AdManager._getAds error: ${result.error}');
    }
    final newAds = result.data;
    ads.clear();
    if (newAds != null && newAds.isNotEmpty) {
      ads.addAll(newAds);
      getMorePages = docsPerPage == newAds.length;
    } else {
      getMorePages = false;
    }

    return getMorePages;
  }

  Future<bool> getMoreAds(int page) async {
    bool getMorePages = false;

    final result = await adRepository.get(
      filter: filter,
      search: searchFilter.searchString,
      page: page,
    );
    if (result.isFailure) {
      throw Exception('AdManager._getMoreAds error: ${result.error}');
    }

    final newAds = result.data;
    if (newAds != null && newAds.isNotEmpty) {
      _ads.addAll(newAds);
      getMorePages = docsPerPage == newAds.length;
    } else {
      getMorePages = false;
    }

    return getMorePages;
  }

  /// This method gets the ad with id `adId` from the manager's `_ads` list,
  /// or from the server's database if the ad has not been dowloaded.
  Future<DataResult<AdModel?>> getAdById(String adId) async {
    try {
      final ad = _ads.firstWhere((ad) => ad.id == adId);
      return DataResult.success(ad);
    } catch (err) {
      final result = await adRepository.getById(adId);
      return result;
    }
  }
}
