import 'package:fluttermulticity/api/common/ps_resource.dart';
import 'package:fluttermulticity/api/common/ps_status.dart';
import 'package:fluttermulticity/config/ps_colors.dart';
import 'package:fluttermulticity/config/ps_config.dart';
import 'package:fluttermulticity/constant/ps_dimens.dart';
import 'package:fluttermulticity/constant/route_paths.dart';
import 'package:fluttermulticity/provider/comment/comment_header_provider.dart';
import 'package:fluttermulticity/repository/comment_header_repository.dart';
import 'package:fluttermulticity/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermulticity/ui/common/dialog/error_dialog.dart';
import 'package:fluttermulticity/ui/common/dialog/info_dialog.dart';
import 'package:fluttermulticity/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermulticity/ui/common/ps_textfield_widget.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/comment_header.dart';
import 'package:fluttermulticity/viewobject/common/ps_value_holder.dart';
import 'package:fluttermulticity/viewobject/holder/comment_header_holder.dart';
import 'package:fluttermulticity/viewobject/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item/comment_list_item.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;
  @override
  _CommentListViewState createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  CommentHeaderRepository commentHeaderRepo;
  PsValueHolder psValueHolder;
  CommentHeaderProvider _commentHeaderProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentHeaderProvider.nextCommentList(widget.item.id);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
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
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
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

    commentHeaderRepo = Provider.of<CommentHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CommentHeaderProvider>(
        appBarTitle: Utils.getString(context, 'comment_list__title') ?? '',
        initProvider: () {
          return CommentHeaderProvider(
              repo: commentHeaderRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (CommentHeaderProvider provider) {
          provider.loadCommentList(widget.item.id);
          _commentHeaderProvider = provider;
          return provider;
        },
        builder: (BuildContext context, CommentHeaderProvider provider,
            Widget child) {
          return Container(
            color: PsColors.baseColor,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // const PsAdMobBannerWidget(),
                    // Visibility(
                    //   visible: PsConfig.showAdMob &&
                    //       isSuccessfullyLoaded &&
                    //       isConnectedToInternet,
                    //   child: AdmobBanner(
                    //     adUnitId: Utils.getBannerAdUnitId(),
                    //     adSize: AdmobBannerSize.FULL_BANNER,
                    //     listener:
                    //         (AdmobAdEvent event, Map<String, dynamic> map) {
                    //       print('BannerAd event is $event');
                    //       if (event == AdmobAdEvent.loaded) {
                    //         isSuccessfullyLoaded = true;
                    //       } else {
                    //         isSuccessfullyLoaded = false;
                    //         setState(() {});
                    //       }
                    //     },
                    //   ),
                    // ),
                    if (provider.commentHeaderList != null &&
                        provider.commentHeaderList.data != null &&
                        provider.commentHeaderList.data.isNotEmpty)
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(bottom: PsDimens.space8),
                          child: CustomScrollView(
                              controller: _scrollController,
                              reverse: true,
                              slivers: <Widget>[
                                CommentListWidget(
                                    animationController: animationController,
                                    provider: provider),
                              ]),
                        ),
                      )
                    else
                      Expanded(child: Container()),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            width: double.infinity,
                            child: EditTextAndButtonWidget(
                              provider: provider,
                              item: widget.item,
                            ))),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: provider.commentHeaderList.status ==
                            PsStatus.PROGRESS_LOADING
                        ? 1.0
                        : 0.0,
                    child: const LinearProgressIndicator(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key key,
    @required this.provider,
    @required this.item,
  }) : super(key: key);

  final CommentHeaderProvider provider;
  final Item item;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.provider.commentHeaderList != null &&
        widget.provider.commentHeaderList.data != null) {
      return SizedBox(
        width: double.infinity,
        height: PsDimens.space72,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            border: Border.all(color: PsColors.mainLightShadowColor),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PsDimens.space12),
                topRight: Radius.circular(PsDimens.space12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: PsColors.mainShadowColor,
                blurRadius: 4.0, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
                offset: const Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space1),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: PsDimens.space4,
                ),
                Expanded(
                    flex: 6,
                    child: PsTextFieldWidget(
                      hintText: Utils.getString(
                          context, 'comment_list__comment_hint'),
                      textEditingController: commentController,
                      showTitle: false,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: PsDimens.space44,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      color: PsColors.mainColor,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(color: PsColors.mainShadowColor),
                    ),
                    child: InkWell(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Icon(
                          Icons.send,
                          color: PsColors.white,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () async {
                        if (widget.provider.psValueHolder.loginUserId == null) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return InfoDialog(
                                  message: Utils.getString(
                                    context,
                                    Utils.getString(
                                        context, 'comment__login_first'),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutePaths.login_container,
                                    );
                                  },
                                );
                              });
                        } else {
                          if (commentController.text.isEmpty) {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WarningDialog(
                                    message: Utils.getString(
                                        context,
                                        Utils.getString(
                                            context, 'comment__empty')),
                                    onPressed: () {},
                                  );
                                });
                          } else {
                            if (await Utils.checkInternetConnectivity()) {
                              Utils.navigateOnUserVerificationView(context,
                                  () async {
                                final CommentHeaderParameterHolder
                                    commentHeaderParameterHolder =
                                    CommentHeaderParameterHolder(
                                  userId:
                                      widget.provider.psValueHolder.loginUserId,
                                  itemId: widget.item.id,
                                  cityId: widget.item.city.id,
                                  headerComment: commentController.text,
                                );

                                final PsResource<List<CommentHeader>>
                                    _apiStatus =
                                    await widget.provider.postCommentHeader(
                                        commentHeaderParameterHolder.toMap());
                                if (_apiStatus.data != null) {
                                  widget.provider
                                      .resetCommentList(widget.item.id);
                                  commentController.clear();
                                } else {
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message: Utils.getString(
                                              context,
                                              Utils.getString(
                                                  context, _apiStatus.message)),
                                        );
                                      });
                                }
                              });
                            } else {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: Utils.getString(
                                          context, 'error_dialog__no_internet'),
                                    );
                                  });
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: PsDimens.space4,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class CommentListWidget extends StatefulWidget {
  const CommentListWidget({
    Key key,
    this.animationController,
    this.provider,
  }) : super(key: key);

  final AnimationController animationController;
  final CommentHeaderProvider provider;
  @override
  _CommentListWidgetState createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          widget.animationController.forward();
          final int count = widget.provider.commentHeaderList.data.length;
          return CommetListItem(
            animationController: widget.animationController,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            ),
            comment: widget.provider.commentHeaderList.data[index],
            onTap: () async {
              final dynamic data = await Navigator.pushNamed(
                  context, RoutePaths.commentDetail,
                  arguments: widget.provider.commentHeaderList.data[index]);

              if (data != null) {
                await widget.provider.syncCommentByIdAndLoadCommentList(
                    widget.provider.commentHeaderList.data[index].id,
                    widget.provider.commentHeaderList.data[index].itemId);
              }
            },
          );
        },
        childCount: widget.provider.commentHeaderList.data.length,
      ),
    );
  }
}
