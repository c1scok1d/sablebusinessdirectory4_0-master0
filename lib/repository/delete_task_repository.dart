import 'dart:async';
import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/db/favourite_item_dao.dart';
import 'package:fluttermulticity/db/history_dao.dart';
import 'package:fluttermulticity/db/user_login_dao.dart';
import 'package:fluttermulticity/repository/Common/ps_repository.dart';
import 'package:fluttermulticity/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final FavouriteItemDao _favProductDao = FavouriteItemDao.instance;
    final UserLoginDao _userLoginDao = UserLoginDao.instance;
    final HistoryDao _historyDao = HistoryDao.instance;
    await _favProductDao.deleteAll();
    await _userLoginDao.deleteAll();
    await _historyDao.deleteAll();

    allListStream.sink
        .add(await _userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
