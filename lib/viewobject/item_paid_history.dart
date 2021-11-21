import 'package:businesslistingapi/viewobject/common/ps_object.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:quiver/core.dart';

class ItemPaidHistory extends PsObject<ItemPaidHistory> {
  ItemPaidHistory(
      {this.id,
      this.itemId,
      this.startDate,
      this.startTimestamp,
      this.endDate,
      this.endTimeStamp,
      this.amount,
      this.paymentMethod,
      this.transCode,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.addedDateStr,
      this.razorId,
      this.paidStatus,
      this.item});

  String id;
  String itemId;
  String startDate;
  String startTimestamp;
  String endDate;
  String endTimeStamp;
  String amount;
  String paymentMethod;
  String transCode;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String addedDateStr;
  String razorId;
  String paidStatus;
  Item item;
  @override
  bool operator ==(dynamic other) => other is ItemPaidHistory && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ItemPaidHistory fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ItemPaidHistory(
          id: dynamicData['id'],
          itemId: dynamicData['item_id'],
          startDate: dynamicData['start_date'],
          startTimestamp: dynamicData['start_timestamp'],
          endDate: dynamicData['end_date'],
          endTimeStamp: dynamicData['end_timestamp'],
          amount: dynamicData['amount'],
          paymentMethod: dynamicData['payment_method'],
          transCode: dynamicData['trans_code'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str'],
          razorId: dynamicData['razor_id'],
          paidStatus: dynamicData['paid_status'],
          item: Item().fromMap(dynamicData['item']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_id'] = object.itemId;
      data['start_date'] = object.startDate;
      data['start_timestamp'] = object.startTimestamp;
      data['end_date'] = object.endDate;
      data['end_timestamp'] = object.endTimeStamp;
      data['amount'] = object.amount;
      data['payment_method'] = object.paymentMethod;
      data['trans_code'] = object.transCode;
      data['status'] = object.city;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      data['razor_id'] = object.razorId;
      data['paid_status'] = object.paidStatus;
      data['item'] = Item().toMap(object.item);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemPaidHistory> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemPaidHistory> newFeedList = <ItemPaidHistory>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }
}
