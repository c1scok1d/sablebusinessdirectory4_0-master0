import 'package:businesslistingapi/config/ps_colors.dart';
import 'package:businesslistingapi/constant/ps_dimens.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:flutter/material.dart';

class PsDropdownBaseWithControllerWidget extends StatelessWidget {
  const PsDropdownBaseWithControllerWidget(
      {Key key,
      @required this.title,
      @required this.onTap,
      this.textEditingController,
      this.isMandatory = false})
      : super(key: key);

  final String title;
  final TextEditingController textEditingController;
  final Function onTap;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(title, style: Theme.of(context).textTheme.bodyText1);
    final Widget _productTextWithStarWidget = Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.bodyText1),
        Text(' *',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: PsColors.mainColor))
      ],
    );

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              top: PsDimens.space4,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              if (isMandatory) _productTextWithStarWidget,
              if (!isMandatory) _productTextWidget,
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Container(
              margin: const EdgeInsets.all(PsDimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      textEditingController.text == ''
                          ? Utils.getString(context, 'home_search__not_set')
                          : textEditingController.text,
                      style: textEditingController.text == ''
                          ? Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: PsColors.textPrimaryLightColor)
                          : Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
