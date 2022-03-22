import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:get/get.dart';

class NewAttachmentDialog extends StatefulWidget {
  const NewAttachmentDialog({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NewAttachmentDialog> {
  final RequestComplementController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return CreationDialog(
      title: 'Document demandé',
      mainButtonTitle: 'Enregistrer',
      creationContent: newAttachmentContent(),
      formKey: controller.documentNameFormKey,
      onSubmitPressed: controller.addComplement,
      showSubmitButton: true,
    );
  }

  InputTextField newAttachmentContent() {
    return InputTextField(
      labelText: 'Intitulé du document*',
      controller: controller.documentNameTEC,
      focusNode: controller.documentNameFocusNode,
      validator: UsefullMethods.validateNotNullOrEmpty,
      inputType: InputType.alphaNumeric,
    );
  }
}
