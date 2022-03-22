import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/controllers.dart';

class QuotationRequestDetailsController extends CommonRequestDetailsController {
  @override
  void init(bool isQuotation) {
    super.init(isQuotation);
  }

  String turnoverIncomeText = '';
  String netIncomeText = '';

  void getRequestDetails(int requestId) {
    this.requestId = requestId;
    fundingRequestService.getRequestDetails(requestId: requestId).then((Request request) {
      if (request != null) {
        currentRequest = request;

        fundingType = request.type ?? 1;
        requestStatus = request.status ?? 0;
        requestCode = request.code ?? '';
        turnoverIncomeText = request.revenus?.toString() ?? '';
        netIncomeText = request.benefice?.toString() ?? '';
        objectText = request.objet ?? '';
        sellerText = request.fournisseur ?? '';
        providerText = request.fournisseur ?? '';
        propertyTitle = request.titrePropriete == null
            ? false
            : request.titrePropriete.toLowerCase() == 'oui'
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
