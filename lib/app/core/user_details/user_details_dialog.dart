import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../controllers.dart';

class UserDetailsDialog extends StatefulWidget {
  const UserDetailsDialog({Key key, this.userAccount}) : super(key: key);

  final Users userAccount;

  @override
  _State createState() => _State();
}

class _State extends State<UserDetailsDialog> {
  final UserDetailsController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final int userId = Get.arguments as int;

  @override
  void initState() {
    controller.currentUserAccount = widget.userAccount;
    controller.fillFieldsWithUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailsController>(
      builder: (_) {
        return Center(
          child: KeyboardDismissOnTap(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildFields() {
    const double _betweenTextFieldsSpacing = 11;
    return Column(
      children: <Widget>[
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          capitalize: true,
          labelText: 'Votre prénom*',
          controller: controller.firstnameTEC,
          onChanged: (String postalCode) {},
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          capitalize: true,
          labelText: 'Votre nom*',
          controller: controller.lastnameTEC,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        DropDownTextFormField(
          enabled: false,
          value: controller.function,
          values: controller.functions,
          controller: controller.functionTEC,
          labelText: 'Votre fonction*',
          validator: UsefullMethods.validateNotNullOrEmpty,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          labelText: 'Téléphone*',
          controller: controller.phoneTEC,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          labelText: 'Mobile',
          controller: controller.mobileTEC,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          labelText: 'Email*',
          controller: controller.emailTEC,
          validator: UsefullMethods.validEmail,
          keyboardType: TextInputType.emailAddress,
          fillColor: AppColors.lightestGrey,
        ),
      ],
    );
  }

  Wrap _buildContent() {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              _buildTitleAndStatus(),
              const VerticalSpacing(10),
              Padding(
                padding: const EdgeInsets.only(left: 23, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFields(),
                    const VerticalSpacing(33),
                    _buildBackButton(),
                    const VerticalSpacing(14),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Container _buildTitleAndStatus() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
            ),
          ]),
      padding: const EdgeInsets.only(left: 22, right: 19, top: 17, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 20,
            child: _buildTitle(),
          ),
          Expanded(
            flex: 7,
            child: _buildStatusRow(),
          ),
        ],
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppImages.person,
          height: 18,
        ),
        const HorizontalSpacing(5),
        Flexible(
          child: Text(
            '${_buildGender()} ${controller.currentUserAccount?.firstName ?? ''} ${controller.currentUserAccount?.lastName ?? ''}',
            style: AppStyles.boldBlue13,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _buildGender() {
    if (controller.currentUserAccount.gender.toLowerCase() == 'mr')
      return 'Mr';
    else
      return 'Mme';
  }

  Row _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StatusIndicator(
          widht: 8,
          height: 8,
          statusColor: UsefullMethods.getUserStatusColorFromInteger(controller.currentUserAccount?.status ?? 0),
        ),
        const HorizontalSpacing(6),
        Flexible(
          child: Text(UsefullMethods.getEquivalentSingleUserStatusFromInteger(controller.currentUserAccount?.status ?? 0),
              style: AppStyles.semiBoldBlue11),
        )
      ],
    );
  }

  CommonButton _buildBackButton() {
    return CommonButton(
      title: 'Retour',
      enabledColor: AppColors.orange,
      onPressed: () {
        Get.back();
      },
    );
  }
}
