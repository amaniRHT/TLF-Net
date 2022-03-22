import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/required_documents.dart';
import 'package:e_loan_mobile/app/common_request_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PickableDocumentName extends StatelessWidget {
  const PickableDocumentName({
    Key key,
    @required this.requiredDocument,
    this.controller,
    @required this.mounted,
    @required this.index,
    this.pickable = false,
    @required this.operation,
  }) : super(key: key);

  final DocsManagement requiredDocument;
  final CommonRequestController controller;
  final bool mounted;
  final int index;
  final bool pickable;
  final Operation operation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: indicatorColor(),
            shape: BoxShape.circle,
          ),
          child: requiredDocument.files.isEmpty
              ? const SizedBox()
              : const Icon(
                  Icons.check,
                  size: 9,
                  color: Colors.white,
                ),
        ),
        const HorizontalSpacing(8),
        Expanded(
          flex: 100,
          child: Text(
            requiredDocument.title ?? '',
            style: AppStyles.boldBlue12.copyWith(
              color: Colors.black,
            ),
            maxLines: 2,
          ),
        ),
        const Spacer(),
        if (pickable)
          SizedBox(
            width: 30,
            height: 28,
            child: IconButton(
              padding: EdgeInsets.zero,
              splashColor: AppColors.orange.withOpacity(.1),
              icon: Image.asset(
                AppImages.upload,
                height: 20,
                color: uploadButtonColor(),
              ),
              onPressed: handlePressGesture,
            ),
          ),
      ],
    );
  }

  // ignore: missing_return
  Color indicatorColor() {
    switch (operation) {
      case Operation.creation:
        if (requiredDocument.files.isEmpty)
          return AppColors.lightGrey;
        else
          return AppColors.green;
        break;

      case Operation.edition:
        if (requiredDocument.files.isEmpty)
          return AppColors.lightGrey;
        else
          return AppColors.green;
        break;

      case Operation.previewing:
        if (requiredDocument.validDocument) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.lightGrey;
            else
              return AppColors.green;
          } else {
            return AppColors.lightGrey;
          }
        } else if (requiredDocument.invalidDocument) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.orange;
            else
              return AppColors.green;
          } else {
            return AppColors.orange;
          }
        } else if (requiredDocument.validComplement) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.lightGrey;
            else
              return AppColors.green;
          } else {
            return AppColors.lightGrey;
          }
        } else if (requiredDocument.invalidComplement) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.red;
            else
              return AppColors.green;
          } else {
            return AppColors.red;
          }
        }
        break;

      case Operation.complementing:
        if (requiredDocument.validDocument) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.lightGrey;
            else
              return AppColors.green;
          } else {
            return AppColors.lightGrey;
          }
        } else if (requiredDocument.invalidDocument) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.orange;
            else
              return AppColors.green;
          } else {
            return AppColors.orange;
          }
        } else if (requiredDocument.validComplement) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.lightGrey;
            else
              return AppColors.green;
          } else {
            return AppColors.lightGrey;
          }
        } else if (requiredDocument.invalidComplement) {
          if (requiredDocument.hasBeenUpdated) {
            if (requiredDocument.files.isEmpty)
              return AppColors.red;
            else
              return AppColors.green;
          } else {
            return AppColors.red;
          }
        }
        break;
    }
  }

  Color uploadButtonColor() {
    if (requiredDocument.moreThenOneFile || !requiredDocument.filled)
      return AppColors.orange;
    else
      return AppColors.lightGrey;
  }

  void handlePressGesture() {
    if (requiredDocument.moreThenOneFile || !requiredDocument.filled)
      controller.pickFile(mounted, index);
  }
}
