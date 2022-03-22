import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'quotation_details_controller.dart';

bool comingFromNotificationsScreenToQuotationRequestDetailsPage = false;

class QuotationRequestDetailsPage extends StatefulWidget {
  const QuotationRequestDetailsPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<QuotationRequestDetailsPage> {
  final QuotationRequestDetailsController controller = Get.find();

  final int requestId = Get.arguments as int;

  @override
  void initState() {
    controller.init(true);
    controller.getRequestDetails(requestId);
    super.initState();
  }

  @override
  void dispose() {
    comingFromNotificationsScreenToQuotationRequestDetailsPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuotationRequestDetailsController>(
      builder: (_) {
        return SafeAreaManager(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CommonAppBar(),
            body: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        children: [
          const VerticalSpacing(22),
          Row(
            children: [
              _buildRequestCode(),
              const Spacer(),
              _buildRequestStatus(controller.requestStatus)
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpacing(16),
                      _buildInformationsSummary(),
                    ],
                  ),
                ),
                comingFromNotificationsScreenToQuotationRequestDetailsPage
                    ? Column(
                        children: [
                          const Spacer(),
                          CommonButton(
                            title: 'Liste des demandes de cotation',
                            iconOnTheLeft: false,
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                            onPressed: () {
                              {
                                Get.offAllNamed(
                                    AppRoutes.quotationRequestsList);
                              }
                            },
                          ),
                          const VerticalSpacing(15),
                        ],
                      )
                    : const CommonBackButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  CommonTitle _buildRequestCode() {
    return CommonTitle(title: 'Demande N° ${controller.requestCode}');
  }

  Widget _buildRequestStatus(int status) {
    if (status == -1) return const VerticalSpacing(41);
    String statusText = '';
    Color indicatorColor;
    switch (status) {
      case 0:
        statusText = 'Créé';
        indicatorColor = AppColors.lighterGreen;
        break;
      case 1:
        statusText = 'Soumis';
        indicatorColor = AppColors.blue;
        break;
      case 2:
        statusText = "À l'étude";
        indicatorColor = AppColors.darkerBlue;
        break;
      case 3:
        statusText = "À l'étude";
        indicatorColor = AppColors.darkerBlue;
        break;
      case 4:
        statusText = 'Traité';
        indicatorColor = AppColors.green;
        break;
      case 5:
        statusText = 'Annulé';
        indicatorColor = AppColors.red;
        break;

      default:
        statusText = 'Créé';
        indicatorColor = AppColors.lighterGreen;
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            StatusIndicator(
              widht: 10,
              height: 10,
              statusColor: indicatorColor,
            ),
            const HorizontalSpacing(6),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.context.width * 0.25),
              child: Text(
                statusText,
                style: AppStyles.semiBoldBlue11,
              ),
            )
          ],
        ),
      ),
    );
  }

  Card _buildInformationsSummary() {
    final bool _oldCar = controller.oldCar;
    final bool _newCar = controller.newCar;
    final bool _materialOrEquipement = controller.materialOrEquipement;
    final bool _landOrLocals = controller.landOrLocals;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTitleRow(
          title: 'Demande de cotation',
        ),
        const CustomDivider(1, AppColors.dividerGrey),
        const VerticalSpacing(18),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            UsefullMethods.getEquivalentFundingTypeFromInteger(
              controller.fundingType,
            ),
            style: AppStyles.boldBlack13,
          ),
        ),
        const VerticalSpacing(12),
        Padding(
          padding: const EdgeInsets.only(left: 26, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InformationField(
                parameter: 'Neuf',
                value: controller.neuf ? 'Oui' : 'Non',
                visible: _oldCar || _newCar,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Age du véhicule (en mois)',
                value: controller.carAgeText,
                visible: _oldCar,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Objet',
                value: controller.objectText,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Fournisseur',
                value: controller.providerText,
                visible: _materialOrEquipement,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Vendeur',
                value: controller.sellerText,
                visible: _landOrLocals,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Titre de propriété',
                value: controller.propertyTitle ? 'Oui' : 'Non',
                visible: _landOrLocals,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Prix total (DT)',
                value: controller.totalPriceText.isNotEmpty
                    ? controller.totalPriceText + " DT"
                    : "-",
                visible: _oldCar,
              ),
              InformationField(
                parameter: 'Prix HT (DT)',
                value: controller.htPriceText.isNotEmpty
                    ? controller.htPriceText + " DT"
                    : "-",
                visible: !_oldCar,
              ),
              InformationField(
                parameter: 'TVA (DT)',
                value: controller.tvaText.isNotEmpty
                    ? controller.tvaText + " DT"
                    : "-",
                visible: !_oldCar,
              ),
              InformationField(
                parameter: 'Prix T.T.C (DT)',
                value: controller.ttcPriceText + " DT",
                visible: !_oldCar,
              ),
              InformationField(
                parameter: 'Autofinancement T.T.C (DT)',
                value: controller.selfFinancingText + " DT",
              ),
              InformationField(
                parameter: 'Autofinancement en %',
                value: controller.percentageText.removeAllWhitespace,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Durée (en mois)',
                value: controller.durationText,
                shouldFormatValue: false,
              ),
              InformationField(
                parameter: 'Revenus/Chiffres d’affaires',
                value: controller.turnoverIncomeText,
              ),
              InformationField(
                parameter: 'Revenus Nets/Bénéfice',
                value: controller.netIncomeText,
              ),
            ],
          ),
        ),
        const VerticalSpacing(17),
      ]),
    );
  }

  Container _buildTitleRow({String title}) {
    return Container(
      color: AppColors.lightestGrey,
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            child: Center(child: Text(title, style: AppStyles.boldBlack12)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
