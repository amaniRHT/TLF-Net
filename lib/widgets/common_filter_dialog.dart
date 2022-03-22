import 'package:flutter/material.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({
    Key key,
    this.formKey,
    @required this.filterContent,
    this.onSearchPressed,
    this.onResetPressed,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final Widget filterContent;
  final void Function() onSearchPressed;
  final void Function() onResetPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: KeyboardDismissOnTap(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Wrap _buildContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 14,
            bottom: 20,
            left: 17,
            right: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.darkerBlue, width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              _buildTitle(),
              const VerticalSpacing(25),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    filterContent,
                    const VerticalSpacing(33),
                    _buildFilterActionButton(),
                    const VerticalSpacing(10),
                    _buildResetActionButton()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filtrer votre recherche',
          style: AppStyles.semiBoldBlue13,
        ),
        CustomIconButton(
          width: 30,
          height: 30,
          color: Colors.black,
          image: AppImages.close,
          onTap: () {
            Get.back();
          },
        )
      ],
    );
  }

  CommonButton _buildFilterActionButton() {
    return CommonButton(
      title: 'Rechercher',
      enabledColor: AppColors.blue,
      onPressed: onSearchPressed,
    );
  }

  CommonButton _buildResetActionButton() {
    return CommonButton(
      title: 'Réinitialiser',
      enabledColor: AppColors.lightBlue,
      titleColor: AppColors.darkestBlue,
      onPressed: onResetPressed,
    );
  }
}
