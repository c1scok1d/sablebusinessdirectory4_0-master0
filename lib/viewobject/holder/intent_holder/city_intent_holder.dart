import 'package:flutter/material.dart';
import 'package:fluttermulticity/viewobject/holder/city_parameter_holder.dart';

class CityIntentHolder {
  const CityIntentHolder(
      {@required this.appBarTitle, @required this.cityParameterHolder});

  final String appBarTitle;
  final CityParameterHolder cityParameterHolder;
}
