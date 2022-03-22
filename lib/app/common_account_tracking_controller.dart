import 'dart:io';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CommonAccountTrackingController extends BaseController {
  void handleDownloadState({
    @required List<int> binaryFile,
    @required String fileName,
  }) async {
    void errorToast() {
      showCustomToast(
        toastType: ToastTypes.error,
        padding: 65,
        contentText: 'Le téléchargement du document pdf a échoué',
        blurEffectEnabled: false,
      );
    }

    final String _savedFileName =
        '${fileName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    if (binaryFile == null) {
      errorToast();
      return;
    }

    final _path = GetPlatform.isIOS
        ? '${await getApplicationDocumentsDirectory()}/$_savedFileName'
        : '${AppConstants.androidDefaultDownloadDirectory}/$_savedFileName';

    File(_path).writeAsBytes(binaryFile).then((File createdFile) {
      if (createdFile == null)
        errorToast();
      else
        showCustomToast(
          padding: 65,
          contentText: 'Le document pdf a été téléchargé avec succès',
          blurEffectEnabled: false,
        );
    });
  }
}
