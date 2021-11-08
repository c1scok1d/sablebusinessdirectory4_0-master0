import 'dart:async';
import 'package:fluttermulticity/repository/history_repsitory.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/provider/common/ps_provider.dart';

class HistoryProvider extends PsProvider {
  HistoryProvider({@required HistoryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('History Provider: $hashCode');

    historyListStream = StreamController<PsResource<List<Item>>>.broadcast();
    subscription =
        historyListStream.stream.listen((PsResource<List<Item>> resource) {
      updateOffset(resource.data.length);

      _historyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  HistoryRepository _repo;

  PsResource<List<Item>> _historyList =
      PsResource<List<Item>>(PsStatus.NOACTION, '', <Item>[]);

  PsResource<List<Item>> get historyList => _historyList;
  StreamSubscription<PsResource<List<Item>>> subscription;
  StreamController<PsResource<List<Item>>> historyListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadHistoryList() async {
    isLoading = true;
    await _repo.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addHistoryList(Item product) async {
    isLoading = true;
    await _repo.addAllHistoryList(
        historyListStream, PsStatus.PROGRESS_LOADING, product);
  }

  Future<void> resetHistoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
