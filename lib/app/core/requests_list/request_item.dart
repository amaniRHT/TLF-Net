import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestItem extends StatelessWidget {
  RequestItem({
    Key key,
    @required this.index,
    @required this.isQuotation,
    @required this.controller,
  }) : super(key: key);

  final dynamic controller;
  final bool isQuotation;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool _oldCar = controller.requestList[index].type == 0 &&
        !controller.requestList[index].neuf;

    return CommonListItem(
      index: index,
      title: controller.requestList[index]?.code ?? '',
      avatarVisible: false,
      statusText: isQuotation
          ? UsefullMethods.getQuotationRequestStateFromInteger(
              controller.requestList[index]?.status ?? 0)
          : UsefullMethods.getRequestStateFromInteger(
              controller.requestList[index]?.status ?? 0),
      statusColor: isQuotation
          ? UsefullMethods.getQuotationgRequestStatusColorFromInteger(
              controller.requestList[index]?.status ?? 0)
          : UsefullMethods.getFundingRequestStatusColorFromInteger(
              controller.requestList[index]?.status ?? 0),
      itemContent: _buildItemContent(_oldCar),
      showEditionButton: controller.requestList[index].status == 0,
      showDeleteButton: controller.requestList[index].status == 0,
      showDetailsButton: true,
      detailTextButton: 'Voir plus',
      onDetailPressed: () {
        isQuotation
            ? Get.toNamed(
                AppRoutes.quotationRequestDetails,
                arguments: controller.requestList[index].id,
              )
            : Get.toNamed(
                AppRoutes.requestDetails,
                arguments: controller.requestList[index].id,
              );
      },
      onEditPressed: () {
        isQuotation
            ? Get.offAllNamed(
                AppRoutes.quotationRequestCreation,
                arguments: <String, dynamic>{
                  'creationMode': false,
                  'shouldLoadWS': true,
                  'data': controller.requestList[index],
                },
              )
            : Get.offAllNamed(
                AppRoutes.requestCreation,
                arguments: <String, dynamic>{
                  'creationMode': false,
                  'shouldLoadWS': true,
                  'data': controller.requestList[index],
                  'onFirstTab': true
                },
              );
      },
      deleteButtonAlertMessage:
          'Êtes-vous sûr de vouloir supprimer cette demande ?',
      onDeletePressed: () {
        controller.deleteRequest(
          requestId: controller.requestList[index].id,
          requestCode: controller.requestList[index].code ?? '???',
        );
        Get.back();
      },
      showAddComplementButton: !isQuotation &&
          (controller.requestList[index].status == 1 ||
              controller.requestList[index].status == 2 ||
              controller.requestList[index].status == 3),
      complementButtonImage: AppImages.attach,
      onAddComplementPressed: () {
        Get.toNamed(
          AppRoutes.requestComplement,
          arguments: controller.requestList[index].id,
        ).then((shouldReload) {
          print(shouldReload);
          if (shouldReload != null && shouldReload) {
            controller.requestList[index].status = 1;
            controller.update();
          }
        });
      },
      showCreateFundingRequestButton:
          isQuotation && controller.requestList[index].status == 4,
      onCreateFundingRequestPressed: () {
        Get.find<MenuController>().selectedIndex.value = 11;
        Get.offAllNamed(
          AppRoutes.requestCreation,
          arguments: <String, dynamic>{
            'quotationRequest': controller.requestList[index],
            'selectedFundingType': controller.requestList[index].type,
            'onFirstTab': true
          },
        );
      },
      coloredIndicatorHeight: 80,
      colordIndicatorTopPadding: 92,
    );
  }

  Column _buildItemContent(bool oldCar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonParameterRow(
          parameter: 'Type de biens',
          value: UsefullMethods.getEquivalentFundingTypeFromInteger(
                controller.requestList[index]?.type ?? 0,
              ) +
              (controller.requestList[index]?.type == 0 && Get.context.isTablet
                  ? '\n'
                  : ''),
          isMultiline: true,
        ),
        CommonParameterRow(
          parameter: 'Objet',
          value: controller.requestList[index]?.objet ?? '',
        ),
        if (oldCar)
          CommonParameterRow(
            parameter: 'Prix total (DT)',
            value: controller.requestList[index]?.prixTotal != null
                ? UsefullMethods.formatIntegerWithSpaceEach3Characters(
                        controller.requestList[index]?.prixTotal ?? 0) +
                    " DT"
                : '',
          )
        else
          CommonParameterRow(
            parameter: 'Montant (HT)',
            value: controller.requestList[index]?.prixHT != null
                ? UsefullMethods.formatIntegerWithSpaceEach3Characters(
                            controller.requestList[index]?.prixHT ?? 0) +
                        " DT" ??
                    ''
                : '',
          ),
        CommonParameterRow(
          parameter: 'Durée',
          value: controller.requestList[index]?.duree?.toString() ?? '',
        ),
        CommonParameterRow(
          parameter: 'Date de création',
          value: controller.requestList[index].createdAt != null
              ? UsefullMethods.dateFormat.format(
                  DateTime.parse(controller.requestList[index]?.createdAt
                      .substring(0, 10)),
                )
              : '',
        ),
      ],
    );
  }
}
