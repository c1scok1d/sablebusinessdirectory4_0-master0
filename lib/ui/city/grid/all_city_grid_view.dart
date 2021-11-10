import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/city/city_provider.dart';
import 'package:businesslistingapi/repository/city_repository.dart';
import 'package:businesslistingapi/ui/city/item/city_grid_item.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/holder/city_parameter_holder.dart';
import 'package:provider/provider.dart';

class AllCityListView extends StatefulWidget {
  const AllCityListView(
      {Key key,
      this.scrollController,
      @required this.animationController,
      @required this.cityParameterHolder})
      : super(key: key);
  final AnimationController animationController;
  final ScrollController scrollController;
  final CityParameterHolder cityParameterHolder;
  @override
  _AllCityListView createState() => _AllCityListView();
}

class _AllCityListView extends State<AllCityListView>
    with TickerProviderStateMixin {
  CityProvider _recentCityProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _recentCityProvider.nextCityListByKey(widget.cityParameterHolder);
      }
    });

    super.initState();
  }

  CityRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CityRepository>(context);
    print(
        '............................Build UI Again ............................');

    return ChangeNotifierProvider<CityProvider>(
        lazy: false,
        create: (BuildContext context) {
          final CityProvider provider = CityProvider(
            repo: repo1,
          );
          provider.loadCityListByKey(widget.cityParameterHolder);
          _recentCityProvider = provider;
          return provider;
        },
        child: Consumer<CityProvider>(
          builder: (BuildContext context, CityProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8,
                      right: PsDimens.space8,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller:
                            widget.scrollController ?? _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 1.2),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.cityList.data != null ||
                                    provider.cityList.data.isNotEmpty) {
                                  final int count =
                                      provider.cityList.data.length;
                                  return CityGridItem(
                                    animationController:
                                        widget.animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    city: provider.cityList.data[index],
                                    onTap: () async {
                                     await provider.replaceCityInfoData(
                                        provider.cityList.data[index].id,
                                        provider.cityList.data[index].name,
                                        provider.cityList.data[index].lat,
                                        provider.cityList.data[index].lng,
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        RoutePaths.itemHome,
                                        arguments:
                                            provider.cityList.data[index],
                                      );
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.cityList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () {
                      return provider
                          .resetCityListByKey(widget.cityParameterHolder);
                    },
                  )),
              PSProgressIndicator(provider.cityList.status)
            ]);
          },
          // ),
        ));
  }
}
