import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/config/ps_config.dart';
import 'package:fluttermulticity/constant/ps_constants.dart';
import 'package:fluttermulticity/constant/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'package:fluttermulticity/constant/route_paths.dart';
import 'package:fluttermulticity/provider/item/added_item_provider.dart';
import 'package:fluttermulticity/repository/item_repository.dart';
import 'package:fluttermulticity/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermulticity/ui/common/ps_ui_widget.dart';
import 'package:fluttermulticity/ui/items/item_upload/item_upload_list_item.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/api_status.dart';
import 'package:fluttermulticity/viewobject/common/ps_value_holder.dart';
import 'package:fluttermulticity/viewobject/holder/delete_item_parameter_holder.dart';
import 'package:fluttermulticity/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:fluttermulticity/viewobject/holder/item_parameter_holder.dart';
import 'package:provider/provider.dart';

class ItemUploadListView extends StatefulWidget {
  const ItemUploadListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _ItemUploadListViewState createState() => _ItemUploadListViewState();
}

class _ItemUploadListViewState extends State<ItemUploadListView>
    with SingleTickerProviderStateMixin {
  ItemRepository itemRepo;
  PsValueHolder psValueHolder;
  ItemParameterHolder parameterHolder;
  AddedItemProvider _uploadItemProvider;
  final ScrollController _scrollController = ScrollController();
  dynamic data;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _uploadItemProvider.addedUserParameterHolder.addedUserId =
            psValueHolder.loginUserId;
        _uploadItemProvider.nextItemList(psValueHolder.loginUserId,
            _uploadItemProvider.addedUserParameterHolder);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    itemRepo = Provider.of<ItemRepository>(context);

    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    return ChangeNotifierProvider<AddedItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final AddedItemProvider provider = AddedItemProvider(
            repo: itemRepo,
            psValueHolder: psValueHolder,
          );
          provider.addedUserParameterHolder.addedUserId =
              psValueHolder.loginUserId;
          provider.loadItemList(
              psValueHolder.loginUserId, provider.addedUserParameterHolder);
          _uploadItemProvider = provider;
          return provider;
        },
        child: Consumer<AddedItemProvider>(
          builder:
              (BuildContext context, AddedItemProvider provider, Widget child) {
            if (provider.itemList != null && provider.itemList.data != null) {
              // final City city = provider.itemList.data[0].city;
              // provider.replaceCityInfoData(
              //     city.id, city.name, city.lat, city.lng);
              provider.addedUserParameterHolder.addedUserId =
                  psValueHolder.loginUserId;
              return Column(
                children: <Widget>[
                  // const PsAdMobBannerWidget(),
                  Expanded(
                    // child:
                    // Container(
                    //   margin: const EdgeInsets.only(bottom: PsDimens.space10),
                    child: Stack(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      final int count =
                                          provider.itemList.data.length;
                                      return ItemUploadListItem(
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
                                        item: provider.itemList.data[index],
                                        onTap: () async {
                                          final dynamic returnData =
                                              await Navigator.pushNamed(
                                                  context, RoutePaths.itemEntry,
                                                  arguments:
                                                      ItemEntryIntentHolder(
                                                          flag:
                                                              PsConst.EDIT_ITEM,
                                                          item: provider
                                                              .itemList
                                                              .data[index]));
                                          if (returnData != null) {
                                            provider.loadItemList(
                                                psValueHolder.loginUserId,
                                                provider
                                                    .addedUserParameterHolder);
                                          }
                                        },
                                        deleteOnTap: () async {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmDialogView(
                                                  leftButtonText: 'Cancel',
                                                  rightButtonText: 'Ok',
                                                  // leftButtonText: Utils.getString(
                                                  //     context,
                                                  //     'item_upload_list__cancel'),
                                                  description: Utils.getString(
                                                      context,
                                                      'specification_list__delete_warning'),
                                                  onAgreeTap: () async {
                                                    Navigator.of(context).pop();
                                                    if (await Utils
                                                        .checkInternetConnectivity()) {
                                                      final DeleteItemParameterHolder
                                                          deleteItemParameterHolder =
                                                          DeleteItemParameterHolder(
                                                        itemId: provider
                                                            .itemList
                                                            .data[index]
                                                            .id,
                                                        userId: provider
                                                            .itemList
                                                            .data[index]
                                                            .user
                                                            .userId,
                                                      );

                                                      final PsResource<
                                                              ApiStatus>
                                                          _apiStatus =
                                                          await provider
                                                              .postDeleteItem(
                                                                  deleteItemParameterHolder
                                                                      .toMap());

                                                      if (_apiStatus.data !=
                                                          null) {
                                                        print(_apiStatus
                                                            .data.message);
                                                        await provider
                                                            .resetItemList(
                                                                provider
                                                                    .itemList
                                                                    .data[index]
                                                                    .user
                                                                    .userId,
                                                                provider
                                                                    .addedUserParameterHolder);
                                                        print(provider
                                                            .addedUserParameterHolder
                                                            .addedUserId);
                                                      }
                                                    }
                                                  },
                                                );
                                              });
                                        },
                                      );
                                    },
                                    childCount: provider.itemList.data.length,
                                  ),
                                )
                              ]),
                          onRefresh: () async {
                            return _uploadItemProvider.resetItemList(
                                provider.psValueHolder.loginUserId,
                                provider.addedUserParameterHolder);
                          },
                        ),
                      ),
                      PSProgressIndicator(provider.itemList.status)
                    ]),
                    // ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
