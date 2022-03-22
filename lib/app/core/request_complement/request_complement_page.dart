import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/request_complement/new_attachment_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestComplementPage extends StatefulWidget {
  const RequestComplementPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<RequestComplementPage> {
  final RequestComplementController controller = Get.find();

  final int requestId = Get.arguments as int;

  @override
  void initState() {
    controller.getRequestDetails(requestId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestComplementController>(
      builder: (_) {
        return SafeAreaManager(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CommonAppBar(),
            body: _buildContent(),
            floatingActionButton: _buildManualDocumentAddingFloatingButton(),
          ),
        );
      },
    );
  }

  Padding _buildManualDocumentAddingFloatingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        tooltip: 'Ajouter un document complémentenaire',
        onPressed: () {
          presentDialog(() => const NewAttachmentDialog());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacing(22),
          const CommonTitle(title: 'Jointure de documents'),
          const VerticalSpacing(5),
          Row(
            children: [
              _buildRequestCode(),
              const Spacer(),
              _buildRequestStatus(controller.requestStatus),
            ],
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpacing(16),
                      _buildAttachmentsSummary(),
                      const VerticalSpacing(40),
                      if (controller.state == ControllerStates.success)
                        _buildColorsIndicator(),
                      const VerticalSpacing(125),
                    ],
                  ),
                ),
                _buildButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildColorsIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'Échelle de couleurs',
            style: AppStyles.boldBlue13,
          ),
          VerticalSpacing(16),
          ColorizedIndicator(
            title: 'Un document ou un complément validé',
            color: AppColors.grey,
          ),
          VerticalSpacing(10),
          ColorizedIndicator(
            title: 'Un document à modifier',
            color: AppColors.orange,
          ),
          VerticalSpacing(10),
          ColorizedIndicator(
            title: 'Un nouveau document demandé',
            color: AppColors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        const Spacer(),
        SizedBox(
          height: 60,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      title: 'Retour',
                      titleColor: AppColors.darkestBlue,
                      enabledColor: AppColors.lightBlue,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 17,
                        color: AppColors.darkestBlue,
                      ),
                      onPressed: () {
                        showCommonModal(
                          modalType: ModalTypes.alert,
                          message:
                              'Êtes-vous sûr de vouloir annuler la jointure de documents ?',
                          buttonTitle: 'Confirmer',
                          onPressed: () {
                            Get.back(closeOverlays: true);
                            Get.back<bool>(result: false);
                          },
                          withCancelButton: true,
                        );
                      },
                    ),
                  ),
                  const HorizontalSpacing(6),
                  Expanded(
                    child: CommonButton(
                      title: 'Soumettre',
                      iconOnTheLeft: false,
                      onPressed: controller.updateRequestDocuments,
                    ),
                  ),
                  const VerticalSpacing(12),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text _buildRequestCode() {
    return Text(
      'Demande N° ${controller.requestCode}',
      style: AppStyles.boldBlue13,
    );
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
        statusText = "En attente d'un complément";
        indicatorColor = AppColors.lighterOrange;
        break;
      case 4:
        statusText = 'Favorable';
        indicatorColor = AppColors.lighterRed;
        break;
      case 5:
        statusText = 'Défavorable';
        indicatorColor = AppColors.lighterRed;
        break;
      case 6:
        statusText = 'Annulé';
        indicatorColor = AppColors.blue;
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

  Card _buildAttachmentsSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: _buildDocumentsCategoriesList(),
    );
  }

  Widget _buildDocumentsCategoriesList() {
    final List<DocsManagement> requiredDouments =
        controller.requiredDouments ?? const <DemDocMan>[];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requiredDouments.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 10, 15),
              child: Column(
                children: [
                  _buildDocument(index),
                  if (requiredDouments[index]?.files?.isNotEmpty ?? false)
                    _buildDocumentFiles(index),
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

    final DocsManagement requiredDocument =
        controller.requiredDouments[index] ?? DocsManagement();

    return PickableDocumentName(
      requiredDocument: requiredDocument,
      controller: controller,
      mounted: mounted,
      index: index,
      pickable: true,
      operation: Operation.complementing,
    );
  }

  Widget _buildDocumentFiles(int documentIndex) {
    if (documentIndex >= controller.requiredDouments.length)
      return const SizedBox();

    final DocsManagement requiredDocument =
        controller.requiredDouments[documentIndex];

    return FilesListView(
      requiredDocument: requiredDocument,
      documentIndex: documentIndex,
      controller: controller,
      removeEnabled: true,
    );
  }
}

class ColorizedIndicator extends StatelessWidget {
  const ColorizedIndicator({
    Key key,
    this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const HorizontalSpacing(12),
            Text(
              title,
              style: AppStyles.boldBlack12,
            ),
          ],
        )
      ],
    );
  }
}
