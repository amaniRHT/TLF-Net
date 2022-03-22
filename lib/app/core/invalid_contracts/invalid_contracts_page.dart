import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/invalid_contracts/invalid_contract_item.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvalidContractsPage extends StatefulWidget {
  const InvalidContractsPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<InvalidContractsPage> {
  final InvalidContractsController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reinitialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvalidContractsController>(
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
          const CommonTitle(title: 'Contrats échus ou non encore achetés'),
          const VerticalSpacing(16.0),
          _buildTotalResult(
            '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _inValidContractsList()
        ],
      ),
    );
  }

  Future<void> _refreshcontractstList() async {
    controller.getInvalidContracts(fromBeginnig: true);
  }

  Padding _buildTotalResult(String title) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(title, style: AppStyles.mediumBlue10),
      );

  Flexible _inValidContractsList() {
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
                padding: const EdgeInsets.only(top: 5, bottom: 100),
                itemCount: controller.invalidContractsList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return (index == controller.invalidContractsList.length)
                      ? PagingIndicator(
                          visiblityCondition: !controller.noMorePages &&
                              !controller.invalidContractsList.isEmpty)
                      : (index < controller.invalidContractsList.length)
                          ? InValidContractItem(index: index)
                          : const SizedBox();
                },
                controller: controller.scrollController,
              ),
            ),
    );
  }

  FloatActions _buildFloatingAction() {
    return FloatActions(
      toolTip: 'Imprimer la liste des contrat échus',
      iconData: Icons.print,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        controller.downloadInvalidContractsList();
      },
      downloadButtonEnabled: true,
      showSearchButton: false,
      showTextInfo: true,
      onFilterPressed: () async {},
    );
  }
}
