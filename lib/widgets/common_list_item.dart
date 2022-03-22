import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/horizontal_spacing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum ListCardType { standard, rdv, user }

class CommonListItem extends StatelessWidget {
  const CommonListItem({
    Key key,
    @required this.index,
    this.listCardType = ListCardType.standard,
    this.statusColor,
    this.statusText,
    this.title,
    this.avatarVisible = false,
    this.itemContent,
    this.detailTextButton,
    this.showEditionButton = false,
    this.showDeleteButton = false,
    this.showDetailsButton = true,
    this.showActivateButton = false,
    this.showAddComplementButton = false,
    this.showCreateFundingRequestButton = false,
    this.activateButtonImage,
    this.complementButtonImage,
    this.deleteButtonAlertMessage,
    this.activateDesactivateButtonAlertMessage,
    this.onDeletePressed,
    this.onEditPressed,
    this.onDetailPressed,
    this.onActivatePressed,
    this.onCreateFundingRequestPressed,
    this.onAddComplementPressed,
    this.coloredIndicatorHeight,
    this.colordIndicatorTopPadding,
  }) : super(key: key);

  final int index;
  final ListCardType listCardType;

  final Color statusColor;
  final String statusText;
  final String title;
  final bool avatarVisible;
  final Widget itemContent;
  final String detailTextButton;
  final bool showEditionButton;
  final bool showDeleteButton;
  final bool showDetailsButton;
  final bool showActivateButton;
  final bool showAddComplementButton;
  final bool showCreateFundingRequestButton;

  final String activateButtonImage;
  final String complementButtonImage;
  final String deleteButtonAlertMessage;
  final String activateDesactivateButtonAlertMessage;
  final void Function() onDeletePressed;
  final void Function() onEditPressed;
  final void Function() onDetailPressed;
  final void Function() onActivatePressed;
  final void Function() onAddComplementPressed;
  final void Function() onCreateFundingRequestPressed;
  final double coloredIndicatorHeight;
  final double colordIndicatorTopPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listCardType == ListCardType.standard
          ? 252
          : listCardType == ListCardType.rdv
              ? 175
              : 185,
      child: _contentView(),
    );
  }

  Widget _contentView() => Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleAndStatus(),
                const CustomDivider(1, AppColors.dividerGrey),
                const Spacer(),
                itemContent,
                const Spacer(),
                _buildActionsButtons(),
              ],
            ),
          ),
          _buildVerticalColoredIndicator()
        ],
      );

  Positioned _buildVerticalColoredIndicator() {
    return Positioned(
      top: 0,
      bottom: 0,
      child: Column(
        children: [
          const Spacer(
            flex: 70,
          ),
          Container(
            width: 4,
            height: coloredIndicatorHeight,
            color: statusColor,
          ),
          const Spacer(
            flex: 51,
          ),
        ],
      ),
    );
  }

  Row _buildActionsButtons() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 16, top: 6, bottom: 7),
          child: Row(
            children: [
              _buildEditButton(),
              _buildDeleteButton(),
              _buildActivateButton(),
              _buildAddComplementButton(),
              _buildCreateFundingRequestButton(),
            ],
          ),
        ),
        const VerticalSpacing(44),
        const Spacer(),
        _buildDetailsButton(),
        const HorizontalSpacing(16),
      ],
    );
  }

  Visibility _buildEditButton() {
    return Visibility(
      visible: showEditionButton,
      child: CustomIconButton(
        width: AppConstants.cardButtonsSize,
        height: AppConstants.cardButtonsSize,
        color: AppColors.blue,
        image: AppImages.pen,
        onTap: onEditPressed,
      ),
    );
  }

  Visibility _buildDeleteButton() {
    return Visibility(
      visible: showDeleteButton,
      child: Row(
        children: [
          const CustomVerticalDivider(1, 10, AppColors.blue),
          CustomIconButton(
            width: AppConstants.cardButtonsSize,
            height: AppConstants.cardButtonsSize,
            color: AppColors.blue,
            image: AppImages.delete,
            onTap: () {
              showCommonModal(
                modalType: ModalTypes.alert,
                message: deleteButtonAlertMessage,
                buttonTitle: 'Confirmer',
                onPressed: onDeletePressed,
                withCancelButton: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Visibility _buildActivateButton() {
    return Visibility(
      visible: showActivateButton,
      child: CustomIconButton(
        width: AppConstants.cardButtonsSize,
        height: AppConstants.cardButtonsSize,
        color: AppColors.blue,
        image: activateButtonImage,
        onTap: () {
          showCommonModal(
            modalType: ModalTypes.alert,
            message: activateDesactivateButtonAlertMessage,
            buttonTitle: 'Confirmer',
            onPressed: onActivatePressed,
            withCancelButton: true,
          );
        },
      ),
    );
  }

  Visibility _buildAddComplementButton() {
    return Visibility(
      visible: showAddComplementButton,
      child: CustomIconButton(
        width: AppConstants.cardButtonsSize,
        height: AppConstants.cardButtonsSize,
        color: AppColors.blue,
        image: complementButtonImage,
        onTap: onAddComplementPressed,
      ),
    );
  }

  Visibility _buildCreateFundingRequestButton() {
    return Visibility(
      visible: showCreateFundingRequestButton,
      child: CustomIconButton(
        width: AppConstants.cardButtonsSize,
        height: AppConstants.cardButtonsSize,
        color: AppColors.blue,
        image: AppImages.convertToFundingRequest,
        onTap: onCreateFundingRequestPressed,
      ),
    );
  }

  Visibility _buildDetailsButton() {
    return Visibility(
      visible: showDetailsButton,
      child: GestureDetector(
        onTap: onDetailPressed,
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.black,
              size: AppConstants.cardButtonsSize * .5,
            ),
            const HorizontalSpacing(5),
            Text(
              detailTextButton,
              style: AppStyles.mediumBlack12.copyWith(fontSize: 13.5),
            )
          ],
        ),
      ),
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
        ),
        padding: const EdgeInsets.only(left: 22, right: 19, top: 17, bottom: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: avatarVisible ? 20 : 4,
              child: _buildTitle(),
            ),
            Expanded(
              flex: 7,
              child: _buildStatusRow(),
            ),
          ],
        ));
  }

  Row _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: avatarVisible,
          child: Image.asset(
            AppImages.person,
            height: 18,
          ),
        ),
        const HorizontalSpacing(5),
        Flexible(
          child: Text(
            title,
            style: AppStyles.boldBlue13,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Row _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StatusIndicator(
          widht: 8,
          height: 8,
          statusColor: statusColor,
        ),
        const HorizontalSpacing(6),
        Flexible(
          child: Text(statusText, style: AppStyles.semiBoldBlue11),
        )
      ],
    );
  }
}
