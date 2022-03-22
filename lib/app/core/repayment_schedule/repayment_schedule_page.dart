import 'package:e_loan_mobile/app/core/repayment_schedule/repayment_filter_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'repayment_schedule_controller.dart';
import 'repayment_schedule_item.dart';

class RepaymentSchedulePage extends StatefulWidget {
  const RepaymentSchedulePage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<RepaymentSchedulePage> {
  final RepaymentScheduleController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reinitialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RepaymentScheduleController>(
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
          const CommonTitle(title: 'Echéancier de remboursement'),
          const VerticalSpacing(16.0),
          _buildTotalResult(
            '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _repaymentSchedulesList()
        ],
      ),
    );
  }

  Padding _buildTotalResult(String title) => Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(title, style: AppStyles.mediumBlue10),
      );

  Future<void> _refreshcontractstList() async {
    controller.getRepayments();
  }

  Flexible _repaymentSchedulesList() {
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
                itemCount: controller.repaymentListMap.length,
                itemBuilder: (BuildContext context, int listTileIndex) {
                  final _childrenCount = controller
                      .repaymentListMap[controller.repaymentListMap.keys
                          .toList()[listTileIndex]]
                      .length;
                  return CommonCollapseItem(
                    staticColor: AppColors.lighterBlue,
                    index: listTileIndex,
                    leftTitleKeyFlex: 10,
                    leftTitle: Row(
                      children: [
                        Text(
                          'Contrat N° ',
                          style: AppStyles.boldBlue13,
                        ),
                        Text(
                            controller.repaymentListMap.keys
                                    .toList()[listTileIndex]
                                    .toString() ??
                                '',
                            style: AppStyles.boldBlack13),
                        Text(
                          '    ( ${_childrenCount} loyer${_childrenCount == 1 ? '' : 's'})',
                          style: AppStyles.boldGrey12,
                        ),
                      ],
                    ),
                    bodyContent: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 6,
                          right: 6,
                        ),
                        itemCount: _childrenCount,
                        itemBuilder: (BuildContext context, int index) {
                          return RepaymentScheduleItem(
                            index: index,
                            repayment: controller.repaymentListMap[controller
                                .repaymentListMap.keys
                                .toList()[listTileIndex]][index],
                          );
                        }),
                  );
                },
              ),
            ),
    );
  }

  FloatActions _buildFloatingAction() {
    return FloatActions(
      toolTip: 'Imprimer la liste des echéances',
      iconData: Icons.print,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        controller.downloadContractsList();
      },
      downloadButtonEnabled: true,
      onFilterPressed: () {
        controller.initialiseLists();
        presentDialog(
          () => const RepaymentScheduleFilterDialog(),
        );
      },
    );
  }
}
