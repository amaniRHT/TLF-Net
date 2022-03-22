import 'package:e_loan_mobile/app/core/quotations_list/quotation_list_controller.dart';
import 'package:e_loan_mobile/app/core/requests_list/request_item.dart';
import 'package:e_loan_mobile/app/core/requests_list/requests_filter_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class QuotationsListPage extends StatefulWidget {
  const QuotationsListPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<QuotationsListPage> {
  final QuotationRequestsListController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuotationRequestsListController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: _buildContent(),
              floatingActionButton: _buildFloatingAction(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ),
        );
      },
    );
  }

  FloatActions _buildFloatingAction() {
    return FloatActions(
      toolTip: 'Créer une nouvelle demande',
      iconData: Icons.create_new_folder_outlined,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        Get.offAllNamed(
          AppRoutes.quotationRequestCreation,
          arguments: <String, dynamic>{
            'creationMode': true,
          },
        );
      },
      onFilterPressed: () => {
        controller.initialiseTECs(),
        presentDialog(
          () => RequestsFilterDialog<QuotationRequestsListController>(),
        )
      },
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacing(27),
          const CommonTitle(title: 'Demandes de cotation'),
          const VerticalSpacing(16.0),
          _buildTotalResult(
            '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _requestsList()
        ],
      ),
    );
  }

  Padding _buildTotalResult(String title) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(title, style: AppStyles.mediumBlue10),
      );

  Flexible _requestsList() {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: _refreshQuotationList,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: const AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(top: 5, bottom: 90),
          itemCount: 2,
          controller: controller.scrollController,
          itemBuilder: (BuildContext _, int index) {
            return (index == 0)
                ? InteractiveLister(
                    placeholderCondition:
                        controller.totalResults == 0 && !controller.isLoading,
                    placeholderText:
                        controller.isLoading ? '' : 'Aucune demande trouvée',
                    placeholderRefreshFunction: _refreshQuotationList,
                    dataSource: controller.requestList,
                    itemBuilder: (BuildContext _, int index) => RequestItem(
                          index: index,
                          isQuotation: true,
                          controller: controller,
                        ))
                : PagingIndicator(
                    topPadding: 10,
                    visiblityCondition: !controller.noMorePages &&
                        !controller.requestList.isEmpty,
                  );
          },
        ),
      ),
    );
  }

  Future<void> _refreshQuotationList() async {
    controller.getRequests(fromBeginnig: true);
  }
}
