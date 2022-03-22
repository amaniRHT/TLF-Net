import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/rdv_creation/rdv_creation_dialog.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RDVItem extends StatelessWidget {
  RDVItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final RDVsListController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RDVsListController>(
      builder: (_) {
        return CommonListItem(
          index: index,
          listCardType: ListCardType.rdv,
          title: '${controller.rdvsList[index]?.code ?? ''}',
          avatarVisible: false,
          statusText: UsefullMethods.getEquivalentRDVStatusFromInteger(
              controller.rdvsList[index]?.status ?? 0),
          statusColor: UsefullMethods.getRDVStatusColorFromInteger(
              controller.rdvsList[index]?.status ?? 0),
          itemContent: _buildItemContent(),
          detailTextButton: 'Voir plus',
          showEditionButton: controller.rdvsList[index].status == 0,
          showDeleteButton: controller.rdvsList[index].status == 0,
          onEditPressed: () {
            presentDialog(() => RDVCreationDialog(
                  creationMode: false,
                  detailsMode: false,
                  rendezVous: controller.rdvsList[index],
                ));
          },
          deleteButtonAlertMessage:
              'Êtes-vous sûr de vouloir supprimer la demande n° ${controller.rdvsList[index].code ?? ''} ?',
          onDeletePressed: () {
            controller.deleteRDV(
              rdvId: controller.rdvsList[index].id,
              rdvCode: '${controller.rdvsList[index].code ?? ''}',
            );
            Get.back();
          },
          onDetailPressed: () {
            presentDialog(() => RDVCreationDialog(
                  creationMode: false,
                  detailsMode: true,
                  rendezVous: controller.rdvsList[index],
                ));
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
          parameter: 'Date de création',
          value: controller.rdvsList[index].createdAt != null
              ? UsefullMethods.dateFormat.format(
                  DateTime.parse(
                      controller.rdvsList[index]?.createdAt.substring(0, 10)),
                )
              : '',
        ),
        CommonParameterRow(
          parameter: 'Objet du RDV',
          value: controller.rdvsList[index]?.object ?? '',
        ),
      ],
    );
  }
}
