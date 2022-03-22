import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/common_request_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({
    Key key,
    @required this.requiredDocument,
    @required this.documentIndex,
    this.controller,
    this.removeEnabled = true,
  }) : super(key: key);

  final DocsManagement requiredDocument;
  final CommonRequestController controller;
  final int documentIndex;
  final bool removeEnabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 5, 20, 5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requiredDocument.files.length,
      itemBuilder: (BuildContext context, int fileIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  UsefullMethods.preview(
                    path: requiredDocument.files[fileIndex].path,
                    existant: requiredDocument.files[fileIndex].exists,
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.context.width * (removeEnabled ? 0.62 : 0.70),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: AppConstants.largeBorderRadius,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.darkestBlue.withOpacity(0.3),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Text(
                      requiredDocument.files[fileIndex].originalname,
                      style:
                          AppStyles.mediumBlue10.copyWith(color: Colors.black),
                      maxLines: 10,
                    ),
                  ),
                ),
              ),
              if (removeEnabled)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashColor: AppColors.orange.withOpacity(.1),
                    icon: Image.asset(AppImages.close,
                        height: 8, color: Colors.black),
                    onPressed: () {
                      controller.deleteFile(documentIndex, fileIndex);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
