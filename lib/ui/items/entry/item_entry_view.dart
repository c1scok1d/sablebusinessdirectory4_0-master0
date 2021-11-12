import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:businesslistingapi/api/common/ps_resource.dart';
import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/config/ps_config.dart';
import 'package:businesslistingapi/constant/ps_constants.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/constant/route_paths.dart';
import 'package:businesslistingapi/provider/entry/item_entry_provider.dart';
import 'package:businesslistingapi/provider/gallery/gallery_provider.dart';
import 'package:businesslistingapi/repository/gallery_repository.dart';
import 'package:businesslistingapi/repository/item_repository.dart';
import 'package:businesslistingapi/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:businesslistingapi/ui/common/dialog/error_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/success_dialog.dart';
import 'package:businesslistingapi/ui/common/dialog/warning_dialog_view.dart';
import 'package:businesslistingapi/ui/common/ps_button_widget.dart';
import 'package:businesslistingapi/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:businesslistingapi/ui/common/ps_textfield_widget.dart';
import 'package:businesslistingapi/ui/common/ps_ui_widget.dart';
import 'package:businesslistingapi/utils/ps_progress_dialog.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:businesslistingapi/viewobject/api_status.dart';
import 'package:businesslistingapi/viewobject/category.dart';
import 'package:businesslistingapi/viewobject/common/ps_value_holder.dart';
import 'package:businesslistingapi/viewobject/default_photo.dart';
import 'package:businesslistingapi/viewobject/holder/delete_imge_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/holder/google_map_pin_call_back_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/grallery_list_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/item_entry_image_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/intent_holder/sub_category_intent_holder.dart';
import 'package:businesslistingapi/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:businesslistingapi/viewobject/item.dart';
import 'package:businesslistingapi/viewobject/status.dart';
import 'package:businesslistingapi/viewobject/sub_category.dart';
import 'package:latlong/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key key, this.flag, this.item, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final String flag;
  final Item item;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ItemRepository itemRepo;
  GalleryRepository galleryRepo;
  ItemEntryProvider _itemEntryProvider;
  GalleryProvider galleryProvider;
  PsValueHolder valueHolder;

  final TextEditingController userInputItemName = TextEditingController();
  final TextEditingController userInputSearchTagsKeyword =
      TextEditingController();
  final TextEditingController userInputItemHighLightInformation =
      TextEditingController();
  final TextEditingController userInputItemDescription =
      TextEditingController();
  final TextEditingController userInputOpenTime = TextEditingController();
  final TextEditingController userInputCloseTime = TextEditingController();
  final TextEditingController userInputTimeRemark = TextEditingController();
  final TextEditingController userInputPhone1 = TextEditingController();
  final TextEditingController userInputPhone2 = TextEditingController();
  final TextEditingController userInputPhone3 = TextEditingController();
  final TextEditingController userInputEmail = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputFacebook = TextEditingController();
  final TextEditingController userInputTwitter = TextEditingController();
  final TextEditingController userInputYoutube = TextEditingController();
  final TextEditingController userInputGoogle = TextEditingController();
  final TextEditingController userInputInstagram = TextEditingController();
  final TextEditingController userInputWebsite = TextEditingController();
  final TextEditingController userInputPinterest = TextEditingController();
  final TextEditingController userInputWhatsappNumber = TextEditingController();
  final TextEditingController userInputMessenger = TextEditingController();
  final TextEditingController userInputTermsAndConditions =
      TextEditingController();
  final TextEditingController userInputCancelationPolicy =
      TextEditingController();
  final TextEditingController userInputAdditionalInfo = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController googleMapController;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  LatLng latlng;
  final double zoom = 10;
  bool bindDataFirstTime = true;

  dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    itemRepo = Provider.of<ItemRepository>(context);
    galleryRepo = Provider.of<GalleryRepository>(context);
    // deleteImageRepo = Provider.of<DeleteImageRepository>(context);
    widget.animationController.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: itemRepo, psValueHolder: valueHolder);

                  latlng = LatLng(
                      double.parse(_itemEntryProvider.psValueHolder.cityLat),
                      double.parse(_itemEntryProvider.psValueHolder.cityLng));
                  if (_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider.itemLocationId != '')
                    _itemEntryProvider.itemLocationId =
                        _itemEntryProvider.psValueHolder.cityId;
                  if (userInputLattitude.text.isEmpty)
                    userInputLattitude.text =
                        _itemEntryProvider.psValueHolder.cityLat;
                  if (userInputLongitude.text.isEmpty)
                    userInputLongitude.text =
                        _itemEntryProvider.psValueHolder.cityLng;
                  _itemEntryProvider.getItemFromDB(widget.item.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepo);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider.loadImageList(
                      widget.item.id,
                    );
                  }
                  return galleryProvider;
                }),
          ],
          child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context,
                              ItemEntryProvider itemEntryProvider,
                              Widget child) {
                        return Consumer<GalleryProvider>(builder:
                            (BuildContext context,
                                GalleryProvider galleryProvider, Widget child) {
                          if (itemEntryProvider != null &&
                              itemEntryProvider.item != null &&
                              itemEntryProvider.item.data != null) {
                            if (bindDataFirstTime) {
                              userInputItemName.text =
                                  itemEntryProvider.item.data.name;
                              categoryController.text =
                                  itemEntryProvider.item.data.category.name;
                              subCategoryController.text =
                                  itemEntryProvider.item.data.subCategory.name;
                              userInputSearchTagsKeyword.text =
                                  itemEntryProvider.item.data.searchTag;
                              userInputItemHighLightInformation.text =
                                  itemEntryProvider
                                      .item.data.highlightInformation;
                              userInputItemDescription.text =
                                  itemEntryProvider.item.data.description;
                              statusController.text =
                                  itemEntryProvider.item.data.transStatus;
                              userInputOpenTime.text =
                                  itemEntryProvider.item.data.openingHour;
                              userInputCloseTime.text =
                                  itemEntryProvider.item.data.closingHour;
                              userInputTimeRemark.text =
                                  itemEntryProvider.item.data.timeRemark;
                              userInputPhone1.text =
                                  itemEntryProvider.item.data.phone1;
                              userInputPhone2.text =
                                  itemEntryProvider.item.data.phone2;
                              userInputPhone3.text =
                                  itemEntryProvider.item.data.phone3;
                              userInputEmail.text =
                                  itemEntryProvider.item.data.email;
                              userInputAddress.text =
                                  itemEntryProvider.item.data.address;
                              userInputFacebook.text =
                                  itemEntryProvider.item.data.facebook;
                              userInputTwitter.text =
                                  itemEntryProvider.item.data.twitter;
                              userInputYoutube.text =
                                  itemEntryProvider.item.data.youtube;
                              userInputGoogle.text =
                                  itemEntryProvider.item.data.googlePlus;
                              userInputInstagram.text =
                                  itemEntryProvider.item.data.instagram;
                              userInputWebsite.text =
                                  itemEntryProvider.item.data.website;
                              userInputPinterest.text =
                                  itemEntryProvider.item.data.pinterest;
                              userInputWhatsappNumber.text =
                                  itemEntryProvider.item.data.whatsapp;
                              userInputMessenger.text =
                                  itemEntryProvider.item.data.messenger;
                              userInputTermsAndConditions.text =
                                  itemEntryProvider.item.data.terms;
                              userInputCancelationPolicy.text =
                                  itemEntryProvider.item.data.cancelationPolicy;
                              userInputAdditionalInfo.text =
                                  itemEntryProvider.item.data.additionalInfo;
                              userInputLattitude.text =
                                  itemEntryProvider.item.data.lat;
                              userInputLongitude.text =
                                  itemEntryProvider.item.data.lng;
                              itemEntryProvider.categoryId =
                                  itemEntryProvider.item.data.category.id;
                              itemEntryProvider.subCategoryId =
                                  itemEntryProvider.item.data.subCategory.id;
                              itemEntryProvider.isFeatured =
                                  itemEntryProvider.item.data.isFeatured;
                              itemEntryProvider.isPromotion =
                                  itemEntryProvider.item.data.isPromotion;
                              bindDataFirstTime = false;
                            }
                          }

                          return AllControllerTextWidget(
                            userInputItemName: userInputItemName,
                            userInputSearchTagsKeyword:
                                userInputSearchTagsKeyword,
                            userInputItemHighLightInformation:
                                userInputItemHighLightInformation,
                            userInputItemDescription: userInputItemDescription,
                            userInputOpenTime: userInputOpenTime,
                            userInputCloseTime: userInputCloseTime,
                            userInputTimeRemark: userInputTimeRemark,
                            userInputPhone1: userInputPhone1,
                            userInputPhone2: userInputPhone2,
                            userInputPhone3: userInputPhone3,
                            userInputEmail: userInputEmail,
                            userInputAddress: userInputAddress,
                            userInputFacebook: userInputFacebook,
                            userInputTwitter: userInputTwitter,
                            userInputYoutube: userInputYoutube,
                            userInputGoogle: userInputGoogle,
                            userInputInstagram: userInputInstagram,
                            userInputWebsite: userInputWebsite,
                            userInputPinterest: userInputPinterest,
                            userInputWhatsappNumber: userInputWhatsappNumber,
                            userInputMessenger: userInputMessenger,
                            userInputTermsAndConditions:
                                userInputTermsAndConditions,
                            userInputCancelationPolicy:
                                userInputCancelationPolicy,
                            userInputAdditionalInfo: userInputAdditionalInfo,
                            userInputLattitude: userInputLattitude,
                            userInputLongitude: userInputLongitude,
                            categoryController: categoryController,
                            subCategoryController: subCategoryController,
                            statusController: statusController,
                            mapController: mapController,
                            locationController: locationController,
                            latLng: latlng,
                            item: widget.item,
                            isFeatured: widget.item.isFeatured,
                            isPromotion: widget.item.isPromotion,
                            provider: itemEntryProvider,
                            galleryProvider: galleryProvider,
                            zoom: zoom,
                            flag: widget.flag,
                            valueHolder: valueHolder,
                            updateMapController: updateMapController,
                            googleMapController: googleMapController,
                          );
                        });
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return child;
                }),
          )),
    );
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key key,
    this.userInputItemName,
    this.userInputSearchTagsKeyword,
    this.userInputItemHighLightInformation,
    this.userInputItemDescription,
    this.userInputOpenTime,
    this.userInputCloseTime,
    this.userInputTimeRemark,
    this.userInputPhone1,
    this.userInputPhone2,
    this.userInputPhone3,
    this.userInputEmail,
    this.userInputAddress,
    this.userInputFacebook,
    this.userInputTwitter,
    this.userInputYoutube,
    this.userInputGoogle,
    this.userInputInstagram,
    this.userInputWebsite,
    this.userInputPinterest,
    this.userInputWhatsappNumber,
    this.userInputMessenger,
    this.userInputTermsAndConditions,
    this.userInputCancelationPolicy,
    this.userInputAdditionalInfo,
    this.userInputLattitude,
    this.userInputLongitude,
    this.categoryController,
    this.subCategoryController,
    this.statusController,
    this.mapController,
    this.locationController,
    this.latLng,
    this.item,
    this.isFeatured,
    this.isPromotion,
    this.provider,
    this.galleryProvider,
    this.zoom,
    this.flag,
    this.valueHolder,
    this.googleMapController,
    this.updateMapController,
  }) : super(key: key);

  final TextEditingController userInputItemName;
  final TextEditingController userInputSearchTagsKeyword;
  final TextEditingController userInputItemHighLightInformation;
  final TextEditingController userInputItemDescription;
  final TextEditingController userInputOpenTime;
  final TextEditingController userInputCloseTime;
  final TextEditingController userInputTimeRemark;
  final TextEditingController userInputPhone1;
  final TextEditingController userInputPhone2;
  final TextEditingController userInputPhone3;
  final TextEditingController userInputEmail;
  final TextEditingController userInputAddress;
  final TextEditingController userInputFacebook;
  final TextEditingController userInputTwitter;
  final TextEditingController userInputYoutube;
  final TextEditingController userInputGoogle;
  final TextEditingController userInputInstagram;
  final TextEditingController userInputWebsite;
  final TextEditingController userInputPinterest;
  final TextEditingController userInputWhatsappNumber;
  final TextEditingController userInputMessenger;
  final TextEditingController userInputTermsAndConditions;
  final TextEditingController userInputCancelationPolicy;
  final TextEditingController userInputAdditionalInfo;
  final TextEditingController userInputLattitude;
  final TextEditingController userInputLongitude;
  final TextEditingController categoryController;
  final TextEditingController subCategoryController;
  final TextEditingController statusController;
  final TextEditingController locationController;
  final MapController mapController;
  final LatLng latLng;
  final Item item;
  final String isFeatured;
  final String isPromotion;
  final ItemEntryProvider provider;
  final GalleryProvider galleryProvider;
  final double zoom;
  final String flag;
  final PsValueHolder valueHolder;
  final googlemap.GoogleMapController googleMapController;
  final Function updateMapController;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng _latlng;
  googlemap.CameraPosition _kLake;
  final List<Asset> imagesList = <Asset>[];
  String flag, itemId;
  String isFeatured, isPromotion;
  bool isFirstTime = true;
  googlemap.CameraPosition kGooglePlex;

  @override
  Widget build(BuildContext context) {
    flag ??= widget.flag;
    itemId = widget.item.id;

    if (isFirstTime) {
      if (widget.isFeatured == null && widget.isPromotion == null) {
        isFeatured = '0';
        isPromotion = '0';
      } else {
        isFeatured = widget.isFeatured;
        isPromotion = widget.isPromotion;
      }
    }
    if (isFeatured == '1') {
      widget.provider.isFeaturedCheckBoxSelect = true;
    }
    if (isPromotion == '1') {
      widget.provider.isPromotionCheckBoxSelect = true;
    }
    if (isPromotion == '0') {
      widget.provider.isPromotionCheckBoxSelect = false;
    }
    if (isFeatured == '0') {
      widget.provider.isFeaturedCheckBoxSelect = false;
    }

    _latlng ??= widget.latLng;
    kGooglePlex = googlemap.CameraPosition(
        target: googlemap.LatLng(_latlng.latitude, _latlng.longitude),
        zoom: widget.zoom,
      );
    ((widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text ==
                    widget.provider.psValueHolder.cityName) ||
            (widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text.isEmpty))
        ? widget.locationController.text =
            widget.provider.psValueHolder.cityName
        : Container();
    if (widget.provider.item != null &&
        widget.provider.item.data != null &&
        widget.flag == PsConst.EDIT_ITEM) {
      _latlng = LatLng(double.parse(widget.provider.item.data.lat),
          double.parse(widget.provider.item.data.lng));
      kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(widget.provider.item.data.lat),
              double.parse(widget.provider.item.data.lat)),
          zoom: widget.zoom,
        );
    } else {
      _latlng = _latlng;
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'item_entry__save_btn'),
          onPressed: () async {
            if (widget.userInputItemName.text == null ||
                widget.userInputItemName.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry__need_item_name'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.categoryController.text == null ||
                widget.categoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry__need_category'),
                      onPressed: () {},
                    );
                  });
            } else if (widget.subCategoryController.text == null ||
                widget.subCategoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry__need_subcategory'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context);
              }
              if (flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  id: '',
                  cityId: widget.valueHolder.cityId,
                  catId: widget.provider.categoryId,
                  subCatId: widget.provider.subCategoryId,
                  status: widget.provider.statusId,
                  name: widget.userInputItemName.text,
                  description: widget.userInputItemDescription.text,
                  searchTag: widget.userInputSearchTagsKeyword.text,
                  highlightInformation:
                      widget.userInputItemHighLightInformation.text,
                  isFeatured: widget.provider.isFeatured,
                  userId: widget.valueHolder.loginUserId,
                  lat: widget.userInputLattitude.text,
                  lng: widget.userInputLongitude.text,
                  openingHour: widget.userInputOpenTime.text,
                  closingHour: widget.userInputCloseTime.text,
                  isPromotion: widget.provider.isPromotion,
                  phone1: widget.userInputPhone1.text,
                  phone2: widget.userInputPhone2.text,
                  phone3: widget.userInputPhone3.text,
                  email: widget.userInputEmail.text,
                  address: widget.userInputAddress.text,
                  facebook: widget.userInputFacebook.text,
                  googlePlus: widget.userInputGoogle.text,
                  twitter: widget.userInputTwitter.text,
                  youtube: widget.userInputYoutube.text,
                  instagram: widget.userInputInstagram.text,
                  pinterest: widget.userInputPinterest.text,
                  website: widget.userInputWebsite.text,
                  whatsapp: widget.userInputWhatsappNumber.text,
                  messenger: widget.userInputMessenger.text,
                  timeRemark: widget.userInputTimeRemark.text,
                  terms: widget.userInputTermsAndConditions.text,
                  cancelationPolicy: widget.userInputCancelationPolicy.text,
                  additionalInfo: widget.userInputAdditionalInfo.text,
                );

                final PsResource<Item> itemData = await widget.provider
                    .postItemEntry(itemEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();

                if (itemData.data != null) {
                  itemId = itemData.data.id;
                  widget.galleryProvider.itemId = itemId;
                  flag = PsConst.EDIT_ITEM;
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: Utils.getString(
                              context, 'item_entry_item_uploaded'),
                          onPressed: () async {
                            final dynamic retrunData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.imageUpload,
                                    arguments: ItemEntryImageIntentHolder(
                                        flag: widget.flag,
                                        itemId: itemData.data.id,
                                        provider: widget.galleryProvider));

                            if (retrunData != null &&
                                retrunData is List<Asset>) {
                              setState(() {
                                widget.galleryProvider
                                    .loadImageList(itemData.data.id);
                              });
                            }
                          },
                        );
                      });
                }
              } else {
                // edit item

                itemId = widget.item.id;

                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  id: widget.provider.item.data.id,
                  cityId: widget.valueHolder.cityId,
                  catId: widget.provider.categoryId,
                  subCatId: widget.provider.subCategoryId,
                  status: widget.provider.statusId,
                  name: widget.userInputItemName.text,
                  description: widget.userInputItemDescription.text,
                  searchTag: widget.userInputSearchTagsKeyword.text,
                  highlightInformation:
                      widget.userInputItemHighLightInformation.text,
                  isFeatured: widget.provider.isFeatured,
                  userId: widget.valueHolder.loginUserId,
                  lat: widget.userInputLattitude.text,
                  lng: widget.userInputLongitude.text,
                  openingHour: widget.userInputOpenTime.text,
                  closingHour: widget.userInputCloseTime.text,
                  isPromotion: widget.provider.isPromotion,
                  phone1: widget.userInputPhone1.text,
                  phone2: widget.userInputPhone2.text,
                  phone3: widget.userInputPhone3.text,
                  email: widget.userInputEmail.text,
                  address: widget.userInputAddress.text,
                  facebook: widget.userInputFacebook.text,
                  googlePlus: widget.userInputGoogle.text,
                  twitter: widget.userInputTwitter.text,
                  youtube: widget.userInputYoutube.text,
                  instagram: widget.userInputInstagram.text,
                  pinterest: widget.userInputPinterest.text,
                  website: widget.userInputWebsite.text,
                  whatsapp: widget.userInputWhatsappNumber.text,
                  messenger: widget.userInputMessenger.text,
                  timeRemark: widget.userInputTimeRemark.text,
                  terms: widget.userInputTermsAndConditions.text,
                  cancelationPolicy: widget.userInputCancelationPolicy.text,
                  additionalInfo: widget.userInputAdditionalInfo.text,
                );
                final Item itemData = widget.provider.item.data;
                if (itemData.name != itemEntryParameterHolder.name ||
                    itemData.category.name != widget.categoryController.text ||
                    itemData.subCategory.name !=
                        widget.subCategoryController.text ||
                    itemData.searchTag !=
                        widget.userInputSearchTagsKeyword.text ||
                    itemData.highlightInformation !=
                        widget.userInputItemHighLightInformation.text ||
                    itemData.description !=
                        widget.userInputItemDescription.text ||
                    itemData.transStatus != widget.statusController.text ||
                    itemData.isFeatured != widget.provider.isFeatured ||
                    itemData.isPromotion != widget.provider.isPromotion ||
                    itemData.openingHour != widget.userInputOpenTime.text ||
                    itemData.closingHour != widget.userInputCloseTime.text ||
                    itemData.timeRemark != widget.userInputTimeRemark.text ||
                    itemData.phone1 != widget.userInputPhone1.text ||
                    itemData.phone2 != widget.userInputPhone2.text ||
                    itemData.phone3 != widget.userInputPhone3.text ||
                    itemData.email != widget.userInputEmail.text ||
                    itemData.address != widget.userInputAddress.text ||
                    itemData.facebook != widget.userInputFacebook.text ||
                    itemData.twitter != widget.userInputTwitter.text ||
                    itemData.youtube != widget.userInputYoutube.text ||
                    itemData.googlePlus != widget.userInputGoogle.text ||
                    itemData.instagram != widget.userInputInstagram.text ||
                    itemData.website != widget.userInputWebsite.text ||
                    itemData.pinterest != widget.userInputPinterest.text ||
                    itemData.whatsapp != widget.userInputWhatsappNumber.text ||
                    itemData.messenger != widget.userInputMessenger.text ||
                    itemData.terms != widget.userInputTermsAndConditions.text ||
                    itemData.cancelationPolicy !=
                        widget.userInputCancelationPolicy.text ||
                    itemData.additionalInfo !=
                        widget.userInputAdditionalInfo.text ||
                    itemData.lat != widget.userInputLattitude.text ||
                    itemData.lng != widget.userInputLongitude.text) {
                  final PsResource<Item> itemData = await widget.provider
                      .postItemEntry(itemEntryParameterHolder.toMap());
                  PsProgressDialog.dismissDialog();

                  if (itemData.data != null) {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'item_entry_item_uploaded'),
                            onPressed: () {},
                          );
                        });
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message:
                              Utils.getString(context, 'Item Already Saved'),
                        );
                      });
                }
              }
            }
          },
        ));

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__item_info'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__item_name'),
                  textAboutMe: false,
                  hintText: Utils.getString(context, 'item_entry__item_name'),
                  textEditingController: widget.userInputItemName,
                ),
                PsDropdownBaseWithControllerWidget(
                  title: Utils.getString(context, 'item_entry__category_name'),
                  textEditingController: widget.categoryController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final ItemEntryProvider provider =
                        Provider.of<ItemEntryProvider>(context, listen: false);

                    final dynamic categoryResult = await Navigator.pushNamed(
                        context, RoutePaths.searchCategory,
                        arguments: widget.categoryController.text);

                    if (categoryResult != null && categoryResult is Category) {
                      provider.categoryId = categoryResult.id;
                      widget.categoryController.text = categoryResult.name;
                      provider.subCategoryId = '';

                      setState(() {
                        widget.categoryController.text = categoryResult.name;
                        widget.subCategoryController.text = '';
                      });
                    }
                  },
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(
                        context, 'item_entry__sub_category_name'),
                    textEditingController: widget.subCategoryController,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      if (provider.categoryId != '') {
                        final dynamic subCategoryResult =
                            await Navigator.pushNamed(
                                context, RoutePaths.searchSubCategory,
                                arguments: SubCategoryIntentHolder(
                                    categoryId: provider.categoryId,
                                    subCategoryName:
                                        widget.subCategoryController.text));
                        if (subCategoryResult != null &&
                            subCategoryResult is SubCategory) {
                          provider.subCategoryId = subCategoryResult.id;

                          widget.subCategoryController.text =
                              subCategoryResult.name;
                        }
                      } else {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message: Utils.getString(context,
                                    'home_search__choose_category_first'),
                              );
                            });
                        const ErrorDialog(message: 'Choose Category first');
                      }
                    }),
                PsTextFieldWidget(
                  titleText: Utils.getString(
                      context, 'item_entry__search_tags_keyword'),
                  textAboutMe: false,
                  textEditingController: widget.userInputSearchTagsKeyword,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(
                      context, 'item_entry__item_highlight_info'),
                  height: PsDimens.space120,
                  textAboutMe: true,
                  keyboardType: TextInputType.multiline,
                  textEditingController:
                      widget.userInputItemHighLightInformation,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__item_description'),
                  height: PsDimens.space120,
                  textAboutMe: true,
                  keyboardType: TextInputType.multiline,
                  textEditingController: widget.userInputItemDescription,
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__status'),
                    textEditingController: widget.statusController,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);

                      final dynamic statusResult = await Navigator.pushNamed(
                          context, RoutePaths.statusList,
                          arguments: widget.statusController.text);

                      if (statusResult != null && statusResult is Status) {
                        provider.statusId = statusResult.id;
                        widget.statusController.text = statusResult.title;
                        // provider.subCategoryId = '';

                        setState(() {
                          widget.statusController.text = statusResult.title;
                        });
                      }
                    }),
                Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.grey),
                      child: Checkbox(
                        activeColor: PsColors.mainColor,
                        value: widget.provider.isFeaturedCheckBoxSelect,
                        onChanged: (bool value) {
                          setState(() {
                            widget.provider.isFeaturedCheckBoxSelect = value;
                            if (widget.provider.isFeaturedCheckBoxSelect) {
                              widget.provider.isFeatured = '1';
                              isFeatured = '1';
                              isFirstTime = false;
                            } else {
                              widget.provider.isFeatured = '0';
                              isFeatured = '0';
                              isFirstTime = false;
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Text(
                            Utils.getString(context, 'item_entry__is_featured'),
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.grey),
                      child: Checkbox(
                        activeColor: PsColors.mainColor,
                        value: widget.provider.isPromotionCheckBoxSelect,
                        onChanged: (bool value) {
                          setState(() {
                            widget.provider.isPromotionCheckBoxSelect = value;
                            if (widget.provider.isPromotionCheckBoxSelect) {
                              widget.provider.isPromotion = '1';
                              isPromotion = '1';
                              isFirstTime = false;
                            } else {
                              widget.provider.isPromotion = '0';
                              isPromotion = '0';
                              isFirstTime = false;
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Text(
                            Utils.getString(
                                context, 'item_entry__is_promotion'),
                            style: Theme.of(context).textTheme.bodyText1),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PsDimens.space8)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__schedule'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__open_time'),
                  hintText: Utils.getString(context, 'item_entry__open_time'),
                  textEditingController: widget.userInputOpenTime,
                  onTap: () async {
                    print('Hello');
                    FocusScope.of(context).requestFocus(FocusNode());
                    final TimeOfDay timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child,
                        );
                      },
                    );

                    if (timeOfDay != null) {
                      widget.provider.openingHour =
                          Utils.getTimeOfDayformat(timeOfDay);
                      // Utils.getTimeOfDayformat(timeOfDay);
                    }
                    setState(() {
                      widget.userInputOpenTime.text =
                          widget.provider.openingHour;
                    });
                  },
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__close_time'),
                  hintText: Utils.getString(context, 'item_entry__close_time'),
                  textEditingController: widget.userInputCloseTime,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final TimeOfDay timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child,
                        );
                      },
                    );

                    if (timeOfDay != null) {
                      widget.provider.closingHour =
                          Utils.getTimeOfDayformat(timeOfDay);
                      // Utils.getTimeOfDayformat(timeOfDay);
                    }
                    setState(() {
                      widget.userInputCloseTime.text =
                          widget.provider.closingHour;
                    });
                  },
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__time_remark'),
                  height: PsDimens.space120,
                  hintText: Utils.getString(context, 'item_entry__time_remark'),
                  textAboutMe: true,
                  textEditingController: widget.userInputTimeRemark,
                ),
                const SizedBox(height: PsDimens.space8)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__contact'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__phone_1'),
                  keyboardType: TextInputType.phone,
                  hintText: Utils.getString(context, 'item_entry__phone_1'),
                  textEditingController: widget.userInputPhone1,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__phone_2'),
                  keyboardType: TextInputType.phone,
                  hintText: Utils.getString(context, 'item_entry__phone_2'),
                  textEditingController: widget.userInputPhone2,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__phone_3'),
                  keyboardType: TextInputType.phone,
                  hintText: Utils.getString(context, 'item_entry__phone_3'),
                  textEditingController: widget.userInputPhone3,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__email'),
                  keyboardType: TextInputType.emailAddress,
                  hintText: Utils.getString(context, 'item_entry__email'),
                  textEditingController: widget.userInputEmail,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__address'),
                  keyboardType: TextInputType.number,
                  height: PsDimens.space120,
                  hintText: Utils.getString(context, 'item_entry__address'),
                  textAboutMe: true,
                  textEditingController: widget.userInputAddress,
                ),
                const SizedBox(height: PsDimens.space8)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__social_info'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__facebook'),
                  hintText: Utils.getString(context, 'item_entry__facebook'),
                  textEditingController: widget.userInputFacebook,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__twitter'),
                  hintText: Utils.getString(context, 'item_entry__twitter'),
                  textEditingController: widget.userInputTwitter,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__youtube'),
                  hintText: Utils.getString(context, 'item_entry__youtube'),
                  textEditingController: widget.userInputYoutube,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__google'),
                  hintText: Utils.getString(context, 'item_entry__google'),
                  textEditingController: widget.userInputGoogle,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__instagram'),
                  hintText: Utils.getString(context, 'item_entry__instagram'),
                  textEditingController: widget.userInputInstagram,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__website'),
                  hintText: Utils.getString(context, 'item_entry__website'),
                  textEditingController: widget.userInputWebsite,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__pinterest'),
                  hintText: Utils.getString(context, 'item_entry__pinterest'),
                  textEditingController: widget.userInputPinterest,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__whatsapp_number'),
                  hintText:
                      Utils.getString(context, 'item_entry__whatsapp_number'),
                  textEditingController: widget.userInputWhatsappNumber,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__messenger'),
                  hintText: Utils.getString(context, 'item_entry__messenger'),
                  textEditingController: widget.userInputMessenger,
                ),
                const SizedBox(height: PsDimens.space8)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__policy'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                PsTextFieldWidget(
                  titleText: Utils.getString(
                      context, 'item_entry__terms_and_conditions'),
                  height: PsDimens.space120,
                  hintText: Utils.getString(
                      context, 'item_entry__terms_and_conditions'),
                  textEditingController: widget.userInputTermsAndConditions,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(
                      context, 'item_entry__cancelation_policy'),
                  height: PsDimens.space120,
                  hintText: Utils.getString(
                      context, 'item_entry__cancelation_policy'),
                  textEditingController: widget.userInputCancelationPolicy,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__additional_info'),
                  height: PsDimens.space120,
                  hintText:
                      Utils.getString(context, 'item_entry__additional_info'),
                  // textAboutMe: true,
                  textEditingController: widget.userInputAdditionalInfo,
                ),
                const SizedBox(height: PsDimens.space8)
              ],
            ),
          ),
          if (flag == PsConst.ADD_NEW_ITEM)
            Container()
          else
            Container(
              child: Column(
                children: <Widget>[
                  if (widget.galleryProvider.galleryList.data.isNotEmpty)
                    _ImageGridWidget(
                      galleryProvider: widget.galleryProvider,
                      itemId: itemId,
                    )
                  else
                    Text(
                      Utils.getString(context, 'item_entry__no_image_uploaded'),
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.blue),
                    ),
                  _UploadImgeButtonWidget(
                    itemId: itemId,
                    galleryProvider: widget.galleryProvider,
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                bottom: PsDimens.space8,
                top: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__pin_location'),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(PsDimens.space16)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                  if (!PsConfig.isUseGoogleMap)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: Container(
                      height: 250,
                      child: FlutterMap(
                        mapController: widget.mapController,
                        options: MapOptions(
                            center: widget
                                .latLng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                            zoom: widget.zoom, //10.0,
                            onTap: (LatLng latLngr) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _handleTap(_latlng, widget.mapController);
                            }),
                        layers: <LayerOptions>[
                          TileLayerOptions(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayerOptions(markers: <Marker>[
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _latlng,
                              builder: (BuildContext ctx) => Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: PsColors.mainColor,
                                  ),
                                  iconSize: 45,
                                  onPressed: () async {
                                    final dynamic itemLocationResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.mapPin,
                                            arguments: MapPinIntentHolder(
                                                flag: PsConst.PIN_MAP,
                                                mapLat:
                                                    widget.valueHolder.cityLat,
                                                mapLng:
                                                    widget.valueHolder.cityLng));

                                    if (itemLocationResult != null &&
                                        itemLocationResult
                                            is MapPinCallBackHolder) {
                                      //
                                      setState(() {
                                        _latlng = itemLocationResult.latLng;

                                        widget.mapController
                                            .move(_latlng, widget.zoom);

                                        widget.userInputLattitude.text =
                                            itemLocationResult.latLng.latitude
                                                .toString();
                                        widget.userInputLongitude.text =
                                            itemLocationResult.latLng.longitude
                                                .toString();

                                        widget.valueHolder.cityLat =
                                            widget.userInputLattitude.text;
                                        widget.valueHolder.cityLng =
                                            widget.userInputLongitude.text;
                                      });
                                    }
                                  },
                                ),
                              ),
                            )
                          ])
                        ],
                      ),
                    ),
                  ) else 
                   Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Container(
                      height: 250,
                      child: googlemap.GoogleMap(
                          onMapCreated: widget.updateMapController,
                          initialCameraPosition: kGooglePlex,
                          circles: <googlemap.Circle>{}..add(googlemap.Circle(
                              circleId: googlemap.CircleId(
                                  widget.userInputAddress.toString()),
                              center: googlemap.LatLng(
                                  _latlng.latitude, _latlng.longitude),
                              radius: 50,
                              fillColor: Colors.blue.withOpacity(0.7),
                              strokeWidth: 3,
                              strokeColor: Colors.redAccent,
                            )
                          ),
                        onTap: (googlemap.LatLng latLngr) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _handleGoogleMapTap(_latlng, widget.googleMapController);
                      }
                    ),
                  ),
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__latitude'),
                  textAboutMe: false,
                  textEditingController: widget.userInputLattitude,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__longitude'),
                  textAboutMe: false,
                  textEditingController: widget.userInputLongitude,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                const SizedBox(height: PsDimens.space8),
              ],
            ),
          ),

          _uploadItemWidget
          // ])
        ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString(),
            item: widget.item));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        mapController.move(_latlng, widget.zoom);
        widget.userInputAddress.text = result.address;
        // tappedPoints = <LatLng>[];
        // tappedPoints.add(latlng);
      });
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }

  dynamic _handleGoogleMapTap(
      LatLng latLng, googlemap.GoogleMapController googleMapController) async {
    print('Handling map');
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString(),
          item: widget.item
        ));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng.latitude, result.latLng.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng.latitude, _latlng.longitude),
            zoom: widget.zoom);
        if (_kLake != null) {
          googleMapController
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake));
          widget.userInputAddress.text = result.address;
          widget.userInputAddress.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }
}

class _UploadImgeButtonWidget extends StatefulWidget {
  const _UploadImgeButtonWidget(
      {Key key, @required this.itemId, @required this.galleryProvider})
      : super(key: key);
  final String itemId;
  final GalleryProvider galleryProvider;
  @override
  __UploadImgeButtonWidgetState createState() =>
      __UploadImgeButtonWidgetState();
}

class __UploadImgeButtonWidgetState extends State<_UploadImgeButtonWidget> {
  String _itemId;
  @override
  Widget build(BuildContext context) {
    if (widget.itemId == null || widget.itemId.isEmpty) {
      _itemId = widget.galleryProvider.itemId;
    } else {
      _itemId = widget.itemId;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space16,
                bottom: PsDimens.space28),
            width: MediaQuery.of(context).size.width / 2.5,
            child: PSButtonWidget(
                hasShadow: true,
                width: MediaQuery.of(context).size.width / 2.5,
                titleText:
                    Utils.getString(context, 'item_entry__specification_btn'),
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.specificationList,
                      arguments: _itemId);
                })),
        Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space16,
                bottom: PsDimens.space28),
            width: MediaQuery.of(context).size.width / 2.5,
            child: PSButtonWidget(
                hasShadow: true,
                width: MediaQuery.of(context).size.width / 2,
                titleText:
                    Utils.getString(context, 'item_entry__upload_image_btn'),
                onPressed: () async {
                  final dynamic retrunData = await Navigator.pushNamed(
                      context, RoutePaths.imageUpload,
                      arguments: ItemEntryImageIntentHolder(
                          flag: '',
                          itemId: _itemId,
                          provider: widget.galleryProvider));

                  if (retrunData != null && retrunData is List<Asset>) {
                    widget.galleryProvider.loadImageList(_itemId);
                    setState(() {});
                  }
                })),
      ],
    );
  }
}

class _ImageGridWidget extends StatefulWidget {
  const _ImageGridWidget({
    Key key,
    @required this.galleryProvider,
    @required this.itemId,
  }) : super(key: key);
  final GalleryProvider galleryProvider;
  final String itemId;
  @override
  __ImageGridWidgetState createState() => __ImageGridWidgetState();
}

class __ImageGridWidgetState extends State<_ImageGridWidget> {
  String _itemId;
  @override
  Widget build(BuildContext context) {
    if (widget.itemId == null || widget.itemId.isEmpty) {
      _itemId = widget.galleryProvider.itemId;
    } else {
      _itemId = widget.itemId;
    }
    return Container(
      margin: const EdgeInsets.all(PsDimens.space16),
      child: Column(
        children: <Widget>[
          _MyHeaderWidget(
            headerName: Utils.getString(context, 'item_entry__header_name'),
            galleryProvider: widget.galleryProvider,
            itemId: _itemId,
          ),
          CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.8,
                      mainAxisSpacing: 0.9),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return _ImageGridItem(
                        image: widget.galleryProvider.galleryList.data[index],
                        onTap: () async {
                          final dynamic retrunData = await Navigator.pushNamed(
                              context, RoutePaths.imageUpload,
                              arguments: ItemEntryImageIntentHolder(
                                  flag: '',
                                  itemId: _itemId,
                                  image: widget
                                      .galleryProvider.galleryList.data[index],
                                  provider: widget.galleryProvider));

                          if (retrunData != null && retrunData is List<Asset>) {
                            widget.galleryProvider.loadImageList(_itemId);
                            setState(() {});
                          }
                        },
                        deleteIconTap: () async {
                          if (await Utils.checkInternetConnectivity()) {
                            final DeleteImageParameterHolder
                                deleteImageParameterHolder =
                                DeleteImageParameterHolder(
                              itemId: _itemId,
                              imgId: widget.galleryProvider.galleryList
                                  .data[index].imgId,
                            );

                            final PsResource<ApiStatus> _apiStatus =
                                await widget.galleryProvider.postDeleteImage(
                                    deleteImageParameterHolder.toMap());

                            if (_apiStatus.data != null) {
                              print(_apiStatus.data.message);
                              await widget.galleryProvider
                                  .loadImageList(_itemId);
                              print(widget
                                  .galleryProvider.galleryList.data.length
                                  .toString());
                              setState(() {});
                            }
                          }
                        },
                      );
                    },
                    childCount:
                        widget.galleryProvider.galleryList.data.length > 6
                            ? 6
                            : widget.galleryProvider.galleryList.data.length,
                  ),
                ),
              ]),
        ],
      ),
    );
    // });
  }
}

class _ImageGridItem extends StatelessWidget {
  const _ImageGridItem(
      {Key key,
      @required this.image,
      @required this.deleteIconTap,
      @required this.onTap})
      : super(key: key);
  final DefaultPhoto image;
  final Function deleteIconTap;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PsNetworkImage(
          defaultPhoto: image,
          width: 100,
          height: 100,
          photoKey: '',
          onTap: onTap,
        ),
        Positioned(
          right: PsDimens.space12,
          bottom: PsDimens.space12,
          child: InkWell(
            onTap: deleteIconTap,
            child: Icon(
              Icons.delete,
              size: PsDimens.space32,
              color: PsColors.mainColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    @required this.galleryProvider,
    @required this.itemId,
  }) : super(key: key);

  final String headerName;
  final String itemId;
  final GalleryProvider galleryProvider;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  String _itemId;
  @override
  Widget build(BuildContext context) {
    if (widget.itemId == null || widget.itemId.isEmpty) {
      _itemId = widget.galleryProvider.itemId;
    } else {
      _itemId = widget.itemId;
    }
    return InkWell(
      onTap: () {
        final dynamic returnData =
            Navigator.pushNamed(context, RoutePaths.galleryList,
                arguments: GalleryListIntentHolder(
                  itemId: _itemId,
                  galleryProvider: widget.galleryProvider,
                ));
        if (returnData != null && returnData) {
          print(returnData);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'item_entry__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
