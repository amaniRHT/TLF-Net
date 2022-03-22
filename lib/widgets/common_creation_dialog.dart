import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class CreationDialog extends StatelessWidget {
  const CreationDialog({
    Key key,
    @required this.title,
    @required this.mainButtonTitle,
    this.formKey,
    @required this.creationContent,
    this.onSubmitPressed,
    this.showSubmitButton = true,
  }) : super(key: key);

  final String title;
  final String mainButtonTitle;
  final GlobalKey<FormState> formKey;
  final Widget creationContent;
  final void Function() onSubmitPressed;
  final bool showSubmitButton;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: KeyboardDismissOnTap(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.isTablet ? 150 : 30),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppConstants.regularBorderRadius,
      ),
      child: Column(
        children: [
          _buildTitle(),
          const VerticalSpacing(25),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                creationContent,
                const VerticalSpacing(33),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCancelButton(),
                    const HorizontalSpacing(6),
                    _buildCreateButton(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildTitle() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: AppConstants.regularRadius,
          topRight: AppConstants.regularRadius,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.darkestBlue),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.boldBlue14.copyWith(color: AppColors.darkestBlue),
            ),
          ),
          CustomIconButton(
            width: 30,
            height: 30,
            color: AppColors.darkestBlue,
            image: AppImages.close,
            onTap: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }

  Visibility _buildCreateButton() {
    return Visibility(
      visible: showSubmitButton,
      child: Expanded(
        child: CommonButton(
          title: mainButtonTitle,
          enabledColor: AppColors.orange,
          onPressed: onSubmitPressed,
        ),
      ),
    );
  }

  Expanded _buildCancelButton() {
    return Expanded(
      child: CommonButton(
        title: 'Annuler',
        enabledColor: AppColors.lightBlue,
        titleColor: AppColors.darkestBlue,
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
