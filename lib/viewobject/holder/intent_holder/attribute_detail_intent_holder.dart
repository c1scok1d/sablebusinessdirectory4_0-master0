import 'package:flutter/material.dart';
import 'package:fluttermulticity/viewobject/AttributeDetail.dart';
import 'package:fluttermulticity/viewobject/item.dart';

class AttributeDetailIntentHolder {
  const AttributeDetailIntentHolder({
    @required this.product,
    @required this.attributeDetail,
  });
  final Item product;
  final List<AttributeDetail> attributeDetail;
}
