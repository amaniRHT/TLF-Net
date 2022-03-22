import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/requests_list/request_item.dart';
import 'package:e_loan_mobile/app/core/requests_list/requests_filter_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RequestsListPage extends StatefulWidget {
  const RequestsListPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<RequestsListPage> {
  final FundingRequestsListController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FundingRequestsListController>(
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
          AppRoutes.requestCreation,
          arguments: <String, dynamic>{
            'creationMode': true,
            'shouldLoadWS': false,
            'data': null,
            'onFirstTab': true
          },
        );
      },
      onFilterPressed: () => {
        controller.initialiseTECs(),
        presentDialog(
          () => RequestsFilterDialog<FundingRequestsListController>(),
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
          const CommonTitle(title: 'Demandes de financement'),
          const VerticalSpacing(16.0),
          _buildTotalResult('${controller.totalResults} résultats obtenus'),
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

  Widget _requestsList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshFundingsList,
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
                    placeholderRefreshFunction: _refreshFundingsList,
                    dataSource: controller.requestList,
                    itemBuilder: (BuildContext _, int index) => RequestItem(
                        index: index,
                        isQuotation: false,
                        controller: controller),
                  )
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

  Future<void> _refreshFundingsList() async {
    controller.getRequests(fromBeginnig: true);
  }
}
