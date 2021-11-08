import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/provider/common/ps_provider.dart';
import 'package:fluttermulticity/repository/item_repository.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/common/ps_value_holder.dart';
import 'package:fluttermulticity/viewobject/item.dart';

class ItemEntryProvider extends PsProvider {
  ItemEntryProvider(
      {@required ItemRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('Item Entry Provider: $hashCode');

    itemListStream = StreamController<PsResource<Item>>.broadcast();
    subscription = itemListStream.stream.listen((PsResource<Item> resource) async {
      if (resource != null && resource.data != null) {
        _itemEntry = resource;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        if (_itemEntry != null && _itemEntry.data != null) {
         await replaceCityInfoData(
            _itemEntry.data.id,
            _itemEntry.data.name,
            _itemEntry.data.lat,
            _itemEntry.data.lng,
          );

          notifyListeners();
        }
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ItemRepository _repo;
  PsValueHolder psValueHolder;
  String openingHour;
  String closingHour;
  PsResource<Item> _itemEntry = PsResource<Item>(PsStatus.NOACTION, '', null);
  PsResource<Item> get item => _itemEntry;

  StreamSubscription<PsResource<Item>> subscription;
  StreamController<PsResource<Item>> itemListStream;

  // String selectedCategoryName = '';
  // String selectedSubCategoryName = '';
  // String selectedItemTypeName = '';
  // String selectedItemConditionName = '';
  // String selectedItemPriceTypeName = '';
  // String selectedItemCurrencySymbol = '';
  // String selectedItemLocation = '';
  // String selectedItemDealOption = '';
  String categoryId = '';
  String subCategoryId = '';
  String cityId = '';
  String statusId = '';
  String isFeatured = '';
  String isPromotion = '';
  String itemLocationId = '';
  bool isCheckBoxSelect = true;
  bool isFeaturedCheckBoxSelect;
  bool isPromotionCheckBoxSelect;
  String checkOrNotShop = '1';
  String itemId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Entry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemEntry(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemEntry = await _repo.postItemEntry(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemEntry;
    // return null;
  }

  Future<dynamic> getItemFromDB(String itemId) async {
    isLoading = true;

    _itemEntry = await _repo.getItemFromDB(
        itemId, itemListStream, PsStatus.PROGRESS_LOADING);

    return _itemEntry;
  }
}
