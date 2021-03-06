import 'package:flutter/material.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/ui/paid_ad/paid_ad_item_list_view.dart';
import 'package:businesslistingapi/utils/utils.dart';

class PaidItemListContainerView extends StatefulWidget {
  @override
  _PaidItemListContainerViewState createState() =>
      _PaidItemListContainerViewState();
}

class _PaidItemListContainerViewState extends State<PaidItemListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'profile__paid_ad'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: PaidAdItemListView(
          scrollController: scrollController,
          animationController: animationController,
        ),
      ),
    );
  }
}
