import 'dart:async';

import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/provider/common/ps_provider.dart';
import 'package:fluttermulticity/repository/clear_all_data_repository.dart';
import 'package:fluttermulticity/viewobject/common/ps_value_holder.dart';
import 'package:fluttermulticity/viewobject/item.dart';
import 'package:flutter/cupertino.dart';

class ClearAllDataProvider extends PsProvider {
  ClearAllDataProvider(
      {@required ClearAllDataRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ClearAllData Provider: $hashCode');
    allListStream = StreamController<PsResource<List<Item>>>.broadcast();
    subscription =
        allListStream.stream.listen((PsResource<List<Item>> resource) {
      updateOffset(resource.data.length);

      _basketList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<Item>>> allListStream;
  ClearAllDataRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Item>> _basketList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get basketList => _basketList;
  StreamSubscription<PsResource<List<Item>>> subscription;
  @override
  void dispose() {
    subscription.cancel();

    isDispose = true;
    print('ClearAll Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> clearAllData() async {
    isLoading = true;
    _repo.clearAllData(allListStream);
  }
}
