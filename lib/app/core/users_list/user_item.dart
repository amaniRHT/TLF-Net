import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/user_details/user_details_dialog.dart';
import 'package:e_loan_mobile/config/images/app_images.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItem extends StatelessWidget {
  UserItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final UsersListController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersListController>(
      builder: (_) {
        return CommonListItem(
          listCardType: ListCardType.user,
          index: index,
          title: '${controller.usersList[index]?.firstName ?? ''} ${controller.usersList[index]?.lastName ?? ''}',
          avatarVisible: true,
          statusText: UsefullMethods.getEquivalentSingleUserStatusFromInteger(controller.usersList[index]?.status ?? 0),
          statusColor: UsefullMethods.getUserStatusColorFromInteger(controller.usersList[index]?.status ?? 0),
          itemContent: _buildItemContent(),
          detailTextButton: 'Voir plus',
          showEditionButton: controller.usersList[index].status == 0,
          showDeleteButton: controller.usersList[index].status == 0,
          showDetailsButton: true,
          showActivateButton: controller.usersList[index].status != 0,
          activateButtonImage: controller.usersList[index].status == 1 ? AppImages.deactivate : AppImages.activate,
          onEditPressed: () {
            Get.offAllNamed(
              AppRoutes.userCreation,
              arguments: <String, dynamic>{
                'creationMode': false,
                'shouldLoadWS': true,
                'data': controller.usersList[index],
              },
            );
          },
          deleteButtonAlertMessage: 'Êtes-vous sûr de vouloir supprimer cet utilisateur ?',
          onDeletePressed: () {
            controller.deleteRequest(
              userId: controller.usersList[index].id,
              accountUserName: '${controller.usersList[index].firstName ?? ''} ${controller.usersList[index].lastName ?? ''}',
            );
            Get.back();
          },
          activateDesactivateButtonAlertMessage: 'Êtes-vous sûr de vouloir ${controller.usersList[index].status == 1 ? 'désactiver' : 'activer'} cet utilisateur ?',
          onActivatePressed: () {
            controller.updateUserStatus(user: controller.usersList[index]);
            Get.back();
          },
          onDetailPressed: () {
            presentDialog(
              () => UserDetailsDialog(
                userAccount: controller.usersList[index],
              ),
            );
          },
          coloredIndicatorHeight: 40,
          colordIndicatorTopPadding: 80,
        );
      },
    );
  }

  Column _buildItemContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonParameterRow(
          parameter: 'E-mail',
          value: controller.usersList[index]?.email ?? '',
        ),
        CommonParameterRow(
          parameter: 'Fonction',
          value: controller.usersList[index]?.job ?? '',
        ),
        CommonParameterRow(
          parameter: 'Téléphone',
          value: UsefullMethods.formatStringWithSpaceEach2Characters(controller.usersList[index]?.phone ?? ''),
        ),
      ],
    );
  }
}
