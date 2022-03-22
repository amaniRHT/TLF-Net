import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/controllers.dart';

class RequestDetailsController extends CommonRequestDetailsController {
  @override
  void init(bool isQuotation) {
    super.init(isQuotation);
  }

  List<DocsManagement> requiredDouments = <DocsManagement>[];

  void getRequestDetails(int requestId) {
    this.requestId = requestId;
    fundingRequestService.getRequestDetails(requestId: requestId).then((Request request) {
      if (request != null) {
        currentRequest = request;
        if (request.demDocMan != null)
          for (int i = 0; i < request.demDocMan.length; i++) {
            final DemDocMan document = request.demDocMan[i];
            final DocsManagement formattedDocument = DocsManagement(
              id: document.docMan.id,
              title: document.docMan.title,
              isRequired: document.docMan.isRequired,
              status: document.status == 1,
              validDocument: document.status == 0 && !document.isComplement,
              invalidDocument: document.status == 1 && !document.isComplement,
              validComplement: document.status == 0 && document.isComplement,
              invalidComplement: document.status == 1 && document.isComplement,
              moreThenOneFile: document.docMan.moreThenOneFile,
              filled: document.files.where((CategoryFiles files) => files.path.isNotEmpty).isNotEmpty,
              files: document.files,
              isComplement: false,
            );
            requiredDouments.add(formattedDocument);
          }
        if (request.demComplement != null)
          for (int i = 0; i < request.demComplement.length; i++) {
            final DemDocMan document = request.demComplement[i];
            final DocsManagement formattedDocument = DocsManagement(
              id: document.docMan.id,
              title: document.docMan.title,
              isRequired: document.docMan.isRequired,
              validDocument: document.status == 0 && !document.isComplement,
              invalidDocument: document.status == 1 && !document.isComplement,
              validComplement: document.status == 0 && document.isComplement,
              invalidComplement: document.status == 1 && document.isComplement,
              moreThenOneFile: document.docMan.moreThenOneFile,
              filled: document.files.where((CategoryFiles files) => files.path.isNotEmpty).isNotEmpty,
              files: document.files,
              isComplement: true,
            );
            requiredDouments.add(formattedDocument);
          }

        fundingType = request.type ?? 1;
        requestStatus = request.status ?? 0;
        requestCode = request.code ?? '';
        objectText = request.objet ?? '';
        sellerText = request.fournisseur ?? '';
        providerText = request.fournisseur ?? '';
        propertyTitle = request.titrePropriete == null
            ? false
            : request.titrePropriete.toLowerCase() == 'true'
                ? true
                : false;
        carAgeText = request.ageVehicule?.toString() ?? '';
        htPriceText = request.prixHT?.toString() ?? '';
        tvaText = request.tva?.toString() ?? '';
        ttcPriceText = request.prixTTC?.toString() ?? '';
        totalPriceText = request.prixTotal?.toString() ?? '';
        durationText = request.duree?.toString() ?? '';
        selfFinancingText = request.autofinancement?.toString() ?? '';
        percentageText = request.autofinancementpourcentage?.toStringAsFixed(2) ?? '';
        neuf = request.neuf ?? true;
        oldCar = fundingType == 0 && !neuf;
        newCar = fundingType == 0 && neuf;
        materialOrEquipement = fundingType == 1;
        landOrLocals = fundingType == 2;
        update();
      }
    });
  }
}
