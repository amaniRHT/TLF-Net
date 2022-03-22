import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:get/get.dart';

class RDVCreationDialog extends StatefulWidget {
  const RDVCreationDialog({
    Key key,
    this.creationMode,
    this.detailsMode,
    this.rendezVous,
  }) : super(key: key);

  final bool creationMode;
  final bool detailsMode;
  final RendezVous rendezVous;
  @override
  _State createState() => _State();
}

class _State extends State<RDVCreationDialog> {
  final RDVCreationController controller = Get.find();

  @override
  void initState() {
    controller.resetTECs();
    controller.creationMode = widget.creationMode;
    controller.detailsMode = widget.detailsMode;
    if (!controller.creationMode) {
      controller.currentRDV = widget.rendezVous;
      controller.fillFieldsWithRDVDetails();
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return GetBuilder<RDVCreationController>(
      builder: (_) {
        return CreationDialog(
          title: controller.creationMode
              ? 'Demande de RDV'
              : 'RDV N° ${controller.currentRDV.code}',
          mainButtonTitle: 'Soumettre',
          creationContent: creationContent(),
          formKey: controller.rdvCreationFormKey,
          onSubmitPressed: () {
            UsefullMethods.unfocus(KeysStorage.mainNavigatorKey.currentContext);
            bool validInputs =
                controller.rdvCreationFormKey.currentState.validate();
            if (validInputs)
              controller.creationMode
                  ? controller.createRDV()
                  : controller.updateRDV();
          },
          showSubmitButton: !controller.detailsMode,
        );
      },
    );
  }

  Column creationContent() {
    return Column(
      children: [
        InputTextField(
          enabled: !controller.detailsMode,
          labelText: 'Objet du RDV*',
          controller: controller.rdvObjectTEC,
          focusNode: controller.rdvObjectFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          maxLines: 3,
          maxLength: 100,
          inputType: InputType.alphaNumeric,
          fillColor:
              controller.detailsMode ? AppColors.lightestGrey : Colors.white,
        ),
        const VerticalSpacing(16),
        InputTextField(
          enabled: !controller.detailsMode,
          labelText: 'Informations complémentaires',
          controller: controller.additionalInformationsTEC,
          focusNode: controller.additionalInformationsFocusNode,
          inputType: InputType.alphaNumeric,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          maxLength: 150,
          fillColor:
              controller.detailsMode ? AppColors.lightestGrey : Colors.white,
        ),
      ],
    );
  }
}
