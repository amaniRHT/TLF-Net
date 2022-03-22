import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/unpaid_bills/unpaid_bills_item.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnpaidBillsPage extends StatefulWidget {
  const UnpaidBillsPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<UnpaidBillsPage> {
  final UnpaidBillsController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reinitialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnpaidBillsController>(
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
          const CommonTitle(title: 'Factures impayées'),
          const VerticalSpacing(16.0),
          _buildTotalResult(
            '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          CommonCardInfo(
            bgColor: AppColors.lighterBlue,
            hasBorder: true,
            title: 'Total',
            borderColor: AppColors.darkerBlue,
            value: '${controller.total ?? '0'} DT',
          ),
          const VerticalSpacing(10),
          CommonCardInfo(
            bgColor: AppColors.lightestOrange,
            hasBorder: true,
            borderColor: AppColors.orange,
            title: 'Mont. règlements non affectés',
            value: '${controller.settlementAmount ?? '0'} DT',
          ),
          _unpaidBillsList()
        ],
      ),
    );
  }

  Future<void> _refreshcontractstList() async {
    controller.getUnpaidBills(fromBeginnig: true);
  }

  Padding _buildTotalResult(String title) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(title, style: AppStyles.mediumBlue10),
      );

  Flexible _unpaidBillsList() {
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
                padding: const EdgeInsets.only(top: 12, bottom: 80),
                itemCount: controller.unpaidBillsList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return (index == controller.unpaidBillsList.length)
                      ? PagingIndicator(
                          visiblityCondition: !controller.noMorePages &&
                              !controller.unpaidBillsList.isEmpty)
                      : (index < controller.unpaidBillsList.length)
                          ? UnpaidBillsItem(index: index)
                          : const SizedBox();
                },
                controller: controller.scrollController,
              ),
            ),
    );
  }

  FloatActions _buildFloatingAction() {
    return FloatActions(
      toolTip: 'Imprimer la liste des factures impayées',
      iconData: Icons.print,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        controller.downloadUnpaidBillsList();
      },
      downloadButtonEnabled: true,
      showSearchButton: false,
      showTextInfo: true,
      showMonthInfo: false,
      paddingTop: 0,
      paddingBottom: 5,
    );
  }
}
