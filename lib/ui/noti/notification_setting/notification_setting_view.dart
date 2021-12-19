import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/db/common/ps_shared_preferences.dart';
import 'package:businesslistingapi/provider/common/notification_provider.dart';
import 'package:businesslistingapi/repository/Common/notification_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_appbar.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/noti_register_holder.dart';
import 'package:businesslistingapi/viewobject/holder/noti_unregister_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';



class NotificationSettingView extends StatefulWidget {
  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

NotificationRepository notiRepository;
NotificationProvider notiProvider;
PsValueHolder _psValueHolder;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class _NotificationSettingViewState extends State<NotificationSettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotificationRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ...........................');

    return PsWidgetWithAppBar<NotificationProvider>(
        appBarTitle:
            Utils.getString(context, 'noti_setting__toolbar_name') ?? '',
        initProvider: () {
          return NotificationProvider(
              repo: notiRepository, psValueHolder: _psValueHolder);
        },
        onProviderReady: (NotificationProvider provider) {
          notiProvider = provider;
        },
        builder: (BuildContext context, NotificationProvider provider,
            Widget child) {
          return _NotificationSettingWidget(notiProvider: provider);
        });
  }
}

class _NotificationSettingWidget extends StatefulWidget {
  const _NotificationSettingWidget({this.notiProvider});

  final NotificationProvider notiProvider;

  @override
  __NotificationSettingWidgetState createState() =>
      __NotificationSettingWidgetState();
}

class __NotificationSettingWidgetState
    extends State<_NotificationSettingWidget> {
  bool isSwitched = true;
  bool isGeoEnabled = true;

  @override
  void initState() {
    super.initState();
    PsSharedPreferences.instance.futureShared.then((pref) {
      try {
        if (isGeoEnabled != pref.getBool(PsConst.GEO_SERVICE_KEY)) {
          isGeoEnabled = pref.getBool(PsConst.GEO_SERVICE_KEY);
          setState(() {});
        }
      } on Exception catch (e) {
        print('GEO_SERVICE_KEY not available');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('******* Login User Id : ${notiProvider.psValueHolder.loginUserId}');

    if (notiProvider.psValueHolder.notiSetting != null) {
      isSwitched = notiProvider.psValueHolder.notiSetting;
    }
    final Widget _switchButtonwidget = Switch(
        value: isSwitched,
        onChanged: (bool value) {
          setState(() async {
            isSwitched = value;
            notiProvider.psValueHolder.notiSetting = value;
            await notiProvider.replaceNotiSetting(value);
          });

          if (isSwitched == true) {
            _fcm.subscribeToTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final NotiRegisterParameterHolder notiRegisterParameterHolder =
                  NotiRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      loginUserId:
                          Utils.checkUserLoginId(notiProvider.psValueHolder));
              notiProvider
                  .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
            }
          } else {
            _fcm.unsubscribeFromTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final NotiUnRegisterParameterHolder
                  notiUnRegisterParameterHolder = NotiUnRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      loginUserId:
                          Utils.checkUserLoginId(notiProvider.psValueHolder));
              notiProvider.rawUnRegisterNotiToken(
                  notiUnRegisterParameterHolder.toMap());
            }
          }
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);
    final Widget _geofenceSwitch = Switch(
        value: isGeoEnabled,
        onChanged: (bool value) async {
          checkPermissions();
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);

    final Widget _notiSettingTextWidget = Text(
      Utils.getString(context, 'noti_setting__onof'),
      style: Theme.of(context).textTheme.subtitle1,
    );
    final Widget _geoSettingTextWidget = Text(
      'Geo Notification Setting (Off/On)',
      style: Theme.of(context).textTheme.subtitle1,
    );

    final Widget _messageTextWidget = Row(
      children: <Widget>[
        const Icon(
          FontAwesome.bullhorn,
          size: PsDimens.space16,
        ),
        const SizedBox(
          width: PsDimens.space16,
        ),
        Text(
          Utils.getString(context, 'noti__latest_message'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _notiSettingTextWidget,
              _switchButtonwidget,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _geoSettingTextWidget,
              _geofenceSwitch,
            ],
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space20,
              bottom: PsDimens.space20,
              left: PsDimens.space8),
          child: _messageTextWidget,
        ),
      ],
    );
  }

  Future<void> checkPermissions() async {
    print('REQUESTING PERMISSION');

    final PermissionStatus locationWhenInUse = await Permission.locationWhenInUse.status;
    switch (locationWhenInUse) {
      case PermissionStatus.granted:
        print('Granted');
        checkPermissionAlways();
        break;
      case PermissionStatus.denied:
        print('denied');
        final Map<Permission, PermissionStatus> status = await [
          Permission.locationWhenInUse
        ].request();
        print(status[Permission.locationWhenInUse]);
        //checkLocationAlways(globalCoordinate);
        break;
      case PermissionStatus.restricted:
        print('restricted');
        (await PsSharedPreferences.instance.futureShared).setBool(
            PsConst.GEO_SERVICE_KEY, false);
        break;
      case PermissionStatus.permanentlyDenied:
        print('Permanently denied');
        (await PsSharedPreferences.instance.futureShared).setBool(
            PsConst.GEO_SERVICE_KEY, false);
        break;
      default:
    }
  }
  Future<void> checkPermissionAlways() async {
    print('REQUESTING PERMISSION');
    final PermissionStatus locationAlways = await Permission.locationAlways.status;
    switch (locationAlways) {
      case PermissionStatus.granted:
        print('Granted');
        (await PsSharedPreferences.instance.futureShared).setBool(PsConst.GEO_SERVICE_KEY, true);
        break;
      case PermissionStatus.denied:
        print('denied');
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.permissionRationale,
        );
        break;
      case PermissionStatus.restricted:
        print('restricted');
        (await PsSharedPreferences.instance.futureShared).setBool(
            PsConst.GEO_SERVICE_KEY, false);
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.permissionRationale,
        );
        break;
      case PermissionStatus.permanentlyDenied:
        print('Permanently denied');
        (await PsSharedPreferences.instance.futureShared).setBool(
            PsConst.GEO_SERVICE_KEY, false);
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.permissionRationale,
        );
        break;
      default:
    }
  }

  void showDeniedDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(PsDimens.space8),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: PsColors.mainColor),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: PsDimens.space4),
                        Icon(
                          Icons.pin_drop,
                          color: PsColors.white,
                        ),
                        const SizedBox(width: PsDimens.space4),
                        Text(
                          'Special Permission',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: PsColors.white,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: PsDimens.space20),
                Container(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space16,
                      right: PsDimens.space16,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: Text(
                    "You will not be alerted when you are near a registered black owned business.\n "
                        "We respect user privacy. You location will never be recorded or shared for any reason.\n "
                        "Tap 'Continue' to proceed without receiving alerts.\n"
                        "To enable alerts when near a registered black owned business select 'allow all the time' at [Go to Settings] > [Permissions]\n"
                        "Tap 'Continue' and select 'Allow all the time' from the next screen to receive alerts.\n",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(height: PsDimens.space20),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: Theme.of(context).iconTheme.color,
                ),
                ButtonBar(
                  children: [
                    MaterialButton(
                      height: 50,
                      minWidth: 100,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        AppSettings.openAppSettings(asAnotherTask: true);
                        //geo.Geofence.initialize();
                      },
                      child: Text(
                        'Go to Settings',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: PsColors.mainColor),
                      ),
                    ),
                    MaterialButton(
                      height: 50,
                      minWidth: 100,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'No',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: PsColors.mainColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
