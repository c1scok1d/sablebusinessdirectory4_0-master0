import 'package:fluttermulticity/config/ps_colors.dart';
import 'package:fluttermulticity/config/ps_config.dart';
import 'package:fluttermulticity/ui/items/list_with_filter/item_list_with_filter_view.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/holder/item_parameter_holder.dart';
import 'package:flutter/material.dart';

class ItemListWithFilterContainerView extends StatefulWidget {
  const ItemListWithFilterContainerView(
      {@required this.itemParameterHolder,
      @required this.appBarTitle,
      @required this.checkPage});
  final ItemParameterHolder itemParameterHolder;
  final String appBarTitle;
  final String checkPage;
  @override
  _ItemListWithFilterContainerViewState createState() =>
      _ItemListWithFilterContainerViewState();
}

class _ItemListWithFilterContainerViewState
    extends State<ItemListWithFilterContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String appBarTitleName;

  void changeAppBarTitle(String categoryName) {
    appBarTitleName = categoryName;
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
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: PsColors.white),
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            appBarTitleName ?? widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(color: PsColors.white),
          ),
          elevation: 0,
        ),
        body: ItemListWithFilterView(
          checkPage: widget.checkPage,
          animationController: animationController,
          itemParameterHolder: widget.itemParameterHolder,
          changeAppBarTitle: changeAppBarTitle,
        ),
      ),
    );
  }
}
