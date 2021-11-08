import 'package:fluttermulticity/config/ps_colors.dart';
import 'package:fluttermulticity/config/ps_config.dart';
import 'package:fluttermulticity/ui/blog/list/city_blog_list_view.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:flutter/material.dart';

class CityBlogListContainerView extends StatefulWidget {
  const CityBlogListContainerView({@required this.cityId});
  final String cityId;
  @override
  _CityBlogListContainerViewState createState() =>
      _CityBlogListContainerViewState();
}

class _CityBlogListContainerViewState extends State<CityBlogListContainerView>
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
          title: Text(Utils.getString(context, 'blog_list__app_bar_name'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.white)),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: CityBlogListView(
            animationController: animationController,
            cityId: widget.cityId,
          ),
        ),
      ),
    );
  }
}
