import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/core/request_creation/request_creation_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryTabView extends StatefulWidget {
  const SummaryTabView({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SummaryTabView> {
  final RequestCreationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        children: [
          _buildStepping(),
          const VerticalSpacing(30),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildInformationsSummary(),
                      const VerticalSpacing(22),
                      _buildAttachmentsSummary(),
                      const VerticalSpacing(80)
                    ],
                  ),
                ),
                _buildIndicatorAndButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card _buildInformationsSummary() {
    final bool _oldCar = controller.selectedFundingType == FundingTypes.oldCar;
    final bool _newCar = controller.selectedFundingType == FundingTypes.newCar;
    final bool _materialOrEquipement = controller.selectedFundingType == FundingTypes.materialOrEquipement;
    final bool _landOrLocals = controller.selectedFundingType == FundingTypes.landOrLocals;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTitleRow(
          title: 'Bien à financer',
          onTap: () {
            controller.tabController.animateTo(0);
          },
        ),
        const CustomDivider(1, AppColors.dividerGrey),
        const VerticalSpacing(18),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: (controller.fundingTypeSelected)
              ? Text(
                  UsefullMethods.getEquivalentSingleFundingTypeFromString(
                    controller.fundingTypeTEC.text,
                  ),
                  style: AppStyles.boldBlack13,
                )
              : Center(
                  child: Text(
                    "Aucun type de bien n'est sélectionné",
                    style: AppStyles.mediumDarkGrey12,
                  ),
                ),
        ),
        if (controller.fundingTypeSelected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const VerticalSpacing(12),
                InformationField(
                  parameter: 'Neuf',
                  value: _newCar ? 'Oui' : 'Non',
                  visible: _oldCar || _newCar,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Age du véhicule (en mois)',
                  value: controller.carAgeTEC.text,
                  visible: _oldCar,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Objet',
                  value: controller.objectTEC.text,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Fournisseur',
                  value: controller.providerTEC.text,
                  visible: _materialOrEquipement,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Vendeur',
                  value: controller.sellerTEC.text,
                  visible: _landOrLocals,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Titre de propriété',
                  value: controller.propertyTitle == Answers.yes ? 'Oui' : 'Non',
                  visible: _landOrLocals,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Prix total (DT)',
                  value: controller.totalPriceTEC.text,
                  visible: _oldCar,
                ),
                InformationField(
                  parameter: 'Prix HT (DT)',
                  value: controller.htPriceTEC.text,
                  visible: !_oldCar,
                ),
                InformationField(
                  parameter: 'TVA (DT)',
                  value: controller.tvaTEC.text,
                  visible: !_oldCar,
                ),
                InformationField(
                  parameter: 'Prix T.T.C (DT)',
                  value: controller.ttcPriceTEC.text,
                  visible: !_oldCar,
                ),
                InformationField(
                  parameter: 'Autofinancement en %',
                  value: controller.percentageTEC.text,
                  shouldFormatValue: false,
                ),
                InformationField(
                  parameter: 'Autofinancement T.T.C (DT)',
                  value: controller.selfFinancingTEC.text,
                ),
                InformationField(
                  parameter: 'Durée (en mois)',
                  value: controller.durationTEC.text,
                  shouldFormatValue: false,
                ),
              ],
            ),
          ),
        const VerticalSpacing(17),
      ]),
    );
  }

  Card _buildAttachmentsSummary() {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(
            title: 'Pièces justificatives',
            onTap: () {
              controller.tabController.animateTo(1);
            },
          ),
          const CustomDivider(1, AppColors.dividerGrey),
          _buildDocumentsCategoriesList(),
        ],
      ),
    );
  }

  Widget _buildDocumentsCategoriesList() {
    if (controller.requiredDouments.isEmpty)
      return const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'Aucune pièce jointe',
            style: AppStyles.mediumDarkGrey12,
          ),
        ),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.requiredDouments.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 10, 15),
              child: Column(
                children: [
                  _buildRequiredDocument(index),
                  if (controller.requiredDouments[index].files.isNotEmpty) _buildFilesList(index),
                ],
              ),
            ),
            const DocumentsSeparator()
          ],
        );
      },
    );
  }

  Widget _buildRequiredDocument(int index) {
    if (index >= controller.requiredDouments.length) return const SizedBox();

    final DocsManagement requiredDocument = controller.requiredDouments[index];

    return PickableDocumentName(
      requiredDocument: requiredDocument,
      mounted: mounted,
      index: index,
      pickable: false,
      operation: Operation.previewing,
    );
  }

  Widget _buildFilesList(int documentIndex) {
    if (documentIndex >= controller.requiredDouments.length) return const SizedBox();
    final DocsManagement requiredDocument = controller.requiredDouments[documentIndex];

    return FilesListView(
      requiredDocument: requiredDocument,
      documentIndex: documentIndex,
      removeEnabled: false,
    );
  }

  Column _buildStepping() {
    return Column(
      children: const <ProgressiveStepper>[
        ProgressiveStepper(
          done: true,
          stepNumber: 1,
          stepLabel: 'Bien à financer',
        ),
        ProgressiveStepper(
          done: true,
          stepNumber: 2,
          stepLabel: 'Jointure des documents',
        ),
        ProgressiveStepper(
          activeStep: true,
          stepNumber: 3,
          stepLabel: 'Envoyer la demande !',
          isLastStep: true,
        ),
      ],
    );
  }

  Container _buildTitleRow({String title, void Function() onTap}) {
    return Container(
      color: AppColors.lightestGrey,
      padding: const EdgeInsets.only(
        left: 14,
        right: 7,
        top: 7,
        bottom: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.boldBlack12),
          CustomIconButton(
            width: 40,
            height: 45,
            color: AppColors.orange,
            image: AppImages.fileEdit,
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Column _buildIndicatorAndButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: CommonButton(
                title: 'Précédent',
                titleColor: AppColors.darkestBlue,
                enabledColor: AppColors.lightBlue,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 17,
                  color: AppColors.darkestBlue,
                ),
                onPressed: () {
                  controller.tabController.animateTo(1);
                },
              ),
            ),
            const HorizontalSpacing(6),
            Expanded(
              child: CommonButton(
                title: 'Soumettre',
                iconOnTheLeft: false,
                onPressed: () {
                  if (fakeData) {
                    Get.offAllNamed(
                      AppRoutes.requestCreationSuccess,
                      arguments: 999,
                    );
                    return;
                  }
                  if (controller.firstTabIsValid) {
                    controller.creationMode ? controller.createRequest() : controller.updateRequest(withCreatedStatus: false);
                  } else {
                    controller.tabController.animateTo(0);
                    controller.shouldValidateForms = true;
                    controller.update();
                  }
                },
              ),
            ),
          ],
        ),
        const VerticalSpacing(12),
      ],
    );
  }
}
