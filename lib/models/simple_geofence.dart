import 'package:flutter_geofence/geofence.dart';

class SimpleGeofence {
  String id;
  double latitude;
  double longitude;
  String isfeatured, isPromotion;
  String city_id;
  String item_name, imageId;
  double radius;
  double expirationDuration;
  GeolocationEvent transitionType;
  int loiteringDelay = 60000;
  bool isNear=false;

  SimpleGeofence(
      this.id,
      this.latitude,
      this.longitude,
      this.isfeatured,
      this.isPromotion,
      this.city_id,
      this.item_name,
      this.imageId,
      this.radius,
      this.expirationDuration,
      this.transitionType);


  Geolocation toGeofence() {
    return Geolocation(
        latitude: latitude, longitude: longitude, radius: radius, id: id);
  }
  SimpleGeofence m(){
    return this;
  }
}
