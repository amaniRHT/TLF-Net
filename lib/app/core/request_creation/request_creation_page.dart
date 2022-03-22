import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'tabs.dart';

class RequestCreationPage extends StatefulWidget {
  const RequestCreationPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<RequestCreationPage>
    with AutomaticKeepAliveClientMixin<RequestCreationPage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final RequestCreationController controller = Get.find();

  final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    _fundingTypePreselection();
    _setupControllerMode();
    _configureTabbarController();
    super.initState();
    _moveToSecondTabIfNeeded();
  }

  void _setupControllerMode() {
    if (arguments['quotationRequest'] as Request != null) {
      controller.creationMode = true;
      controller.currentRequest = arguments['quotationRequest'] as Request;
      controller.fillFieldsWithRequestDetails(forQuotationPurpose: false);
    } else {
      controller.creationMode = arguments['creationMode'] as bool;
      if (!controller.creationMode) {
        controller.currentRequest = arguments['data'] as Request;

        if (arguments['shouldLoadWS'] as bool)
          controller.getRequestDetails(controller.currentRequest.id);
        else
          controller.fillFieldsWithRequestDetails();
      }
    }
  }

  void _configureTabbarController() {
    controller.tabController = TabController(vsync: this, length: 3);

    controller.tabController.addListener(() {
      controller.selectedTab = controller.tabController.index;
      controller.update();
    });
  }

  void _moveToSecondTabIfNeeded() {
    if (arguments['onFirstTab'] as bool == false)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.tabController.animateTo(1);
      });
  }

  void _fundingTypePreselection() {
    if (arguments['selectedFundingType'] == null) return;
    final preselectedFundingType = arguments['selectedFundingType'] as int;
    final fundingType = UsefullMethods.getEquivalentFundingTypeFromInteger(preselectedFundingType);
    if (preselectedFundingType != -1) {
      controller.fundingType = fundingType;
      controller.fundingTypeTEC?.text = fundingType;
      controller.fundingTypeSelected = true;

      if (fundingType == controller.fundingTypes[0]) {
        controller.selectedFundingType = FundingTypes.newCar;
      } else if (fundingType == controller.fundingTypes[1]) {
        controller.selectedFundingType = FundingTypes.materialOrEquipement;
      } else {
        controller.selectedFundingType = FundingTypes.landOrLocals;
      }
      // _resetTECsAndValidations();
      controller.update();
      controller.getDocumentsforType();
    }
  }

  @override
  void dispose() {
    controller.tabController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<RequestCreationController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: Column(
                children: [
                  const VerticalSpacing(25),
                  _buildTitle(),
                  const VerticalSpacing(15),
                  Expanded(
                    child: DefaultTabController(
                      key: GlobalKey(),
                      length: 2,
                      child: TabBarView(
                        controller: controller.tabController,
                        children: const <Widget>[
                          InformationsTabView(),
                          AttachmentsTabView(),
                          SummaryTabView(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildTitle() {
    final bool deletableRequest = !controller.creationMode && controller.currentRequest.status == 0;
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Row(
        children: [
          CommonTitle(
            title: controller.creationMode ? "Création d'une demande" : 'Modification de la demande',
          ),
          const Spacer(),
          Container(
            width: deletableRequest ? 100 : 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppConstants.largeBorderRadius,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.darkestBlue.withOpacity(0.3),
                  blurRadius: 5,
                )
              ],
            ),
            child: controller.creationMode
                ? SaveWidget(
                    onTap: _onSavePressed,
                  )
                : deletableRequest
                    ? SaveOrDeleteWidget(
                        onSaveTapped: _onSavePressed,
                        onDeleteTapped: () {
                          _onDeleteTapped(
                            requestId: controller.currentRequest.id,
                            requestCode: controller.currentRequest.code,
                          );
                        },
                      )
                    : SaveWidget(
                        onTap: _onSavePressed,
                      ),
          ),
        ],
      ),
    );
  }

  void _onSavePressed() async {
    UsefullMethods.unfocus(context);
    await 0.25.delay();
    if (controller.fundingTypeSelected)
      controller.creationMode
          ? controller.createRequest(withCreatedStatus: true)
          : controller.updateRequest(withCreatedStatus: true);
    else {
      controller.tabController.animateTo(0);
      controller.shouldValidateForms = true;
      controller.update();
      showCustomToast(
        toastType: ToastTypes.error,
        contentText: 'Vous devez choisir le type du bien',
        onTheTop: false,
        blurEffectEnabled: false,
        padding: 65,
      );
    }
  }

  void _onDeleteTapped({int requestId, String requestCode}) async {
    UsefullMethods.unfocus(context);
    await 0.25.delay();
    showCommonModal(
      modalType: ModalTypes.alert,
      message: 'Êtes-vous sûr de vouloir supprimer cette demande ?',
      buttonTitle: 'Confirmer',
      onPressed: () {
        Get.back(closeOverlays: true);

        controller.deleteRequest(
          requestId: requestId,
          requestCode: requestCode,
        );
      },
      withCancelButton: true,
    );
  }
}
