import 'dart:async';
import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/db/blog_dao.dart';
import 'package:fluttermulticity/db/category_map_dao.dart';
import 'package:fluttermulticity/db/cateogry_dao.dart';
import 'package:fluttermulticity/db/comment_detail_dao.dart';
import 'package:fluttermulticity/db/comment_header_dao.dart';
import 'package:fluttermulticity/db/item_collection_dao.dart';
import 'package:fluttermulticity/db/item_dao.dart';
import 'package:fluttermulticity/db/item_map_dao.dart';
import 'package:fluttermulticity/db/rating_dao.dart';
import 'package:fluttermulticity/db/sub_category_dao.dart';
import 'package:fluttermulticity/repository/Common/ps_repository.dart';
import 'package:fluttermulticity/viewobject/item.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Item>>> allListStream) async {
    final ItemDao _productDao = ItemDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final CommentHeaderDao _commentHeaderDao = CommentHeaderDao.instance;
    final CommentDetailDao _commentDetailDao = CommentDetailDao.instance;
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ItemCollectionDao _productCollectionDao = ItemCollectionDao.instance;
    final ItemMapDao _productMapDao = ItemMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final SubCategoryDao _subCategoryDao = SubCategoryDao();
    final BlogDao _blogDao = BlogDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _commentHeaderDao.deleteAll();
    await _commentDetailDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productCollectionDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
