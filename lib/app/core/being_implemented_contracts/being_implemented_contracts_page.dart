import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/being_implemented_contracts/being_implemented_contract_item.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeingImplementedContractsPage extends StatefulWidget {
  const BeingImplementedContractsPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<BeingImplementedContractsPage> {
  final BeingImplementedContractsController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reinitialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeingImplementedContractsController>(
      builder: (_) {
        return SafeAreaManager(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CommonAppBar(),
            body: _buildContent(),
            floatingActionButton: _buildFloatingAction(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
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
          const CommonTitle(title: 'Contrats en cours de mise en place'),
          const VerticalSpacing(16.0),
          _buildTotalResult(
            '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _inForceContractsList()
        ],
      ),
    );
  }

  Future<void> _refreshcontractstList() async {
    controller.getBeingImplementedContracts(fromBeginnig: true);
  }

  Padding _buildTotalResult(String title) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(title, style: AppStyles.mediumBlue10),
      );

  Flexible _inForceContractsList() {
    return Flexible(
      child: controller.totalResults == 0 && !controller.isLoading
          ? NoDataPlaceholder(
              placeholderText:
                  controller.isLoading ? '' : AppConstants.NO_RESULTS,
              onPressed: _refreshcontractstList,
            )
          : RefreshIndicator(
              onRefresh: _refreshcontractstList,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(top: 5, bottom: 80),
                itemCount: controller.beingImplementedContractsList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return (index ==
                          controller.beingImplementedContractsList.length)
                      ? PagingIndicator(
                          visiblityCondition: !controller.noMorePages &&
                              !controller.beingImplementedContractsList.isEmpty)
                      : (index <
                              controller.beingImplementedContractsList.length)
                          ? BeingImplementedContractItem(index: index)
                          : const SizedBox();
                },
                controller: controller.scrollController,
              ),
            ),
    );
  }

  FloatActions _buildFloatingAction() {
    return FloatActions(
      toolTip: 'Imprimer la liste des contrats en cours de mise en place',
      iconData: Icons.print,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        controller.downloadBeingImplementedContractsList();
      },
      downloadButtonEnabled: true,
      showSearchButton: false,
      showTextInfo: true,
      onFilterPressed: () async {},
    );
  }
}
