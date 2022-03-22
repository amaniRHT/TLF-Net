import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentsTabView extends StatefulWidget {
  const AttachmentsTabView({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<AttachmentsTabView> {
  final RequestCreationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        children: [
          _buildStepping(),
          const VerticalSpacing(25),
          Expanded(
            child: Stack(
              children: [
                _buildDocumentsListCard(),
                _buildIndicatorAndButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //

  Widget _buildDocumentsListCard() {
    if (!controller.fundingTypeSelected)
      return const Center(
        child: Text(
          "Aucun type de bien n'est sélectionné !",
          style: AppStyles.mediumDarkGrey12,
        ),
      );
    else if (controller.noDocumentsRequired)
      return const Center(
        child: Text(
          "Aucun document n'est demandé",
          style: AppStyles.mediumDarkGrey12,
        ),
      );
    else
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: _buildDocumentsCategoriesList(),
            ),
            const VerticalSpacing(80),
          ],
        ),
      );
  }

  ListView _buildDocumentsCategoriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.requiredDouments.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 10, 8),
              child: Column(
                children: [
                  _buildDocument(index),
                  if (controller.requiredDouments[index].files.isNotEmpty) _buildDocumentFiles(index),
                ],
              ),
            ),
            const DocumentsSeparator()
          ],
        );
      },
    );
  }

  Widget _buildDocument(int index) {
    if (index >= controller.requiredDouments.length) return const SizedBox();

    final DocsManagement requiredDocument = controller.requiredDouments[index];

    return PickableDocumentName(
      requiredDocument: requiredDocument,
      controller: controller,
      mounted: mounted,
      index: index,
      pickable: true,
      operation: controller.creationMode ? Operation.creation : Operation.edition,
    );
  }

  Widget _buildDocumentFiles(int documentIndex) {
    if (documentIndex >= controller.requiredDouments.length) return const SizedBox();

    final DocsManagement requiredDocument = controller.requiredDouments[documentIndex];

    return FilesListView(
      requiredDocument: requiredDocument,
      documentIndex: documentIndex,
      controller: controller,
      removeEnabled: true,
    );
  }

  Column _buildStepping() {
    return Column(
      children: const <Widget>[
        ProgressiveStepper(
          done: true,
          stepNumber: 1,
          stepLabel: 'Bien à financer',
        ),
        ProgressiveStepper(
          activeStep: true,
          stepNumber: 2,
          stepLabel: 'Jointure des documents',
        ),
        ProgressiveStepper(
          stepNumber: 3,
          stepLabel: 'Envoyer la demande !',
          isLastStep: true,
        ),
      ],
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
                  controller.tabController.animateTo(0);
                },
              ),
            ),
            const HorizontalSpacing(6),
            Expanded(
              child: CommonButton(
                title: 'Suivant',
                iconOnTheLeft: false,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 17,
                ),
                onPressed: () {
                  controller.tabController.animateTo(2);
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
