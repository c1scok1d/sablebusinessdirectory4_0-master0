import 'package:flutter/cupertino.dart';
import 'package:fluttermulticity/viewobject/item.dart';

class ItemEntryIntentHolder {
  const ItemEntryIntentHolder({
    @required this.flag,
    @required this.item,
  });
  final String flag;
  final Item item;
}
