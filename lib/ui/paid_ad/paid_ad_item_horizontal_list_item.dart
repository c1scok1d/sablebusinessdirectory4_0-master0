import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermulticity/constant/ps_constants.dart';
import 'package:fluttermulticity/constant/ps_dimens.dart';
import 'package:fluttermulticity/ui/common/ps_ui_widget.dart';
import 'package:fluttermulticity/utils/utils.dart';
import 'package:fluttermulticity/viewobject/item_paid_history.dart';

class PaidAdItemHorizontalListItem extends StatelessWidget {
  const PaidAdItemHorizontalListItem({
    Key key,
    @required this.paidAdItem,
    this.onTap,
  }) : super(key: key);

  final ItemPaidHistory paidAdItem;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0.3,
          child: ClipPath(
            child: Container(
              // color: Colors.white,
              width: PsDimens.space180,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: PsDimens.space4,
                          top: PsDimens.space4,
                          right: PsDimens.space12,
                          bottom: PsDimens.space4,
                        ),
                        child: Row(
                          children: <Widget>[
                            PsNetworkCircleImage(
                              photoKey: '',
                              imagePath: paidAdItem.item.user.userProfilePhoto,
                              width: PsDimens.space40,
                              height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(
                                    paidAdItem.item.defaultPhoto.imgParentId);
                                onTap();
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    bottom: PsDimens.space8,
                                    top: PsDimens.space8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    if (paidAdItem.item.user != null)
                                      Text('${paidAdItem.item.user.userName}',
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)
                                    else
                                      const Text(''),
                                    if (paidAdItem.paidStatus ==
                                        PsConst.PAID_AD_PROGRESS)
                                      Text(
                                          Utils.getString(
                                              context, 'paid_ad__sponsor'),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(color: Colors.blue))
                                    else
                                      Text('${paidAdItem.addedDateStr}',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Stack(
                      //   children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: paidAdItem.item.defaultPhoto,
                              width: PsDimens.space180,
                              height: double.infinity,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(
                                    paidAdItem.item.defaultPhoto.imgParentId);
                                onTap();
                              },
                            ),
                            Positioned(
                                bottom: 0,
                                child: (paidAdItem.paidStatus ==
                                        PsConst.ADSPROGRESS)
                                    ? Container(
                                        width: PsDimens.space180,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                PsDimens.space4),
                                            color: Colors.lightGreen),
                                        padding: const EdgeInsets.all(
                                            PsDimens.space12),
                                        child: Text(
                                          Utils.getString(
                                              context, 'paid__ads_in_progress'),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(color: Colors.white),
                                        ),
                                      )
                                    : (paidAdItem.paidStatus ==
                                            PsConst.ADSFINISHED)
                                        ? Container(
                                            width: PsDimens.space180,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                color: Colors.black45),
                                            padding: const EdgeInsets.all(
                                                PsDimens.space12),
                                            child: Text(
                                              Utils.getString(context,
                                                  'paid__ads_in_completed'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          )
                                        : (paidAdItem.paidStatus ==
                                                PsConst.ADSNOTYETSTART)
                                            ? Container(
                                                width: PsDimens.space180,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.yellow),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_is_not_yet_start'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                              )
                                            : Container()),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space8,
                            top: PsDimens.space12,
                            right: PsDimens.space8,
                            bottom: PsDimens.space4),
                        child: Text(
                          paidAdItem.item.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space8,
                            top: PsDimens.space4,
                            right: PsDimens.space8),
                        child: Row(
                          children: <Widget>[
                            // Text(
                            //     paidAdItem.item.price != ''
                            //         ? '${paidAdItem.item.itemCurrency.currencySymbol}${Utils.getPriceFormat(paidAdItem.item.price)}'
                            //         : '',
                            //     textAlign: TextAlign.start,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .subtitle2
                            //         .copyWith(color: PsColors.mainColor)),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space8),
                                child: Text('(${paidAdItem.item.name})',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.blue)))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: PsDimens.space6,
                              height: PsDimens.space6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space8),
                                child: Text(
                                    Utils.getString(
                                        context, 'profile__start_date'),
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(color: Colors.blue))),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      right: PsDimens.space8),
                                  child: Text(
                                      paidAdItem.startTimestamp == ''
                                          ? ''
                                          : Utils.changeTimeStampToStandardDateTimeFormat(
                                              paidAdItem.startTimestamp),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: Colors.blue))),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space6,
                              height: PsDimens.space6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space4),
                                child: Text(
                                    Utils.getString(
                                        context, 'profile__end_date'),
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(color: Colors.blue))),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: PsDimens.space8),
                                  child: Text(
                                      paidAdItem.endTimeStamp == ''
                                          ? ''
                                          : Utils.changeTimeStampToStandardDateTimeFormat(
                                              paidAdItem.endTimeStamp),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: Colors.blue))),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8,
                            bottom: PsDimens.space16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: PsDimens.space6,
                                  height: PsDimens.space6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space8,
                                        right: PsDimens.space4),
                                    child: Text(
                                        Utils.getString(
                                            context, 'profile__amount'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(color: Colors.blue))),
                                // Padding(
                                //     padding: const EdgeInsets.only(
                                //         right: PsDimens.space8),
                                //     child: Text(
                                //         '${paidAdItem.item.itemCurrency.currencySymbol}${paidAdItem.amount}',
                                //         textAlign: TextAlign.start,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .caption
                                //             .copyWith(color: Colors.blue))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
          ),
        ));
  }
}
