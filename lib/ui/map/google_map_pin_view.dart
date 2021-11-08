import 'package:fluttermulticity/config/ps_colors.dart';
import 'package:fluttermulticity/constant/ps_constants.dart';
import 'package:fluttermulticity/constant/ps_dimens.dart';
import 'package:fluttermulticity/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermulticity/viewobject/holder/google_map_pin_call_back_holder.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPinView extends StatefulWidget {
  const GoogleMapPinView(
      {@required this.flag, @required this.maplat, @required this.maplng});

  final String flag;
  final String maplat;
  final String maplng;

  @override
  _MapPinViewState createState() => _MapPinViewState();
}

class _MapPinViewState extends State<GoogleMapPinView> with TickerProviderStateMixin {
  LatLng latlng;
  double defaultRadius = 3000;
  String address = '';
  CameraPosition kGooglePlex;
  GoogleMapController mapController;

  dynamic loadAddress() async {
    final List<Address> addresses = await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(latlng.latitude, latlng.longitude));
    final Address first = addresses.first;
    address = '${first.addressLine}  \n, ${first.countryName}';
  }

  @override
  Widget build(BuildContext context) {
    latlng ??= LatLng(double.parse(widget.maplat), double.parse(widget.maplng));

    const double value = 15.0;
    // 16 - log(scale) / log(2);
    kGooglePlex = CameraPosition(
        target: LatLng(double.parse(widget.maplat), double.parse(widget.maplng)),
        zoom: value,
    ); 
    loadAddress();

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'location_tile__title'),
        actions: widget.flag == PsConst.PIN_MAP
            ? <Widget>[
                InkWell(
                  child: Ink(
                    child: Center(  
                      child: Text(
                        'PICKLOCATION',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColorWithWhite),
                      ),
                    ),
                  ),
                   onTap: () {
                    Navigator.pop(context,
                        GoogleMapPinCallBackHolder(address: address, latLng: latlng));
                  },
                ),
                const SizedBox(
                  width: PsDimens.space16,
                ),
              ]
            : <Widget>[],
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: kGooglePlex,
                    circles: <Circle> {}
                      ..add(Circle(
                        circleId: CircleId(address),
                        center: latlng,
                        radius: 200,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )
                    ),
                    onTap: widget.flag == PsConst.PIN_MAP
                        ? _handleTap
                        : _doNothingTap
                  ), 
                ),
            ],
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      this.latlng = latlng;
    });
  }

  void _doNothingTap(LatLng latlng) {}
}
