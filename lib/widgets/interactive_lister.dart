import 'package:e_loan_mobile/widgets/nodata_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InteractiveLister extends StatelessWidget {
  const InteractiveLister({
    Key key,
    this.isPaginated = true,
    @required this.placeholderCondition,
    @required this.placeholderText,
    @required this.placeholderRefreshFunction,
    @required this.dataSource,
    @required this.itemBuilder,
    this.listPhysics = const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
    this.gridPhysics = const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
    this.onRefresh,
    this.listPadding = const EdgeInsets.only(top: 5, bottom: 0),
    this.gridPadding = EdgeInsets.zero,
    this.childAspectRatioMultiplyer = 1.1,
  }) : super(key: key);

  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollPhysics listPhysics;
  final ScrollPhysics gridPhysics;
  final Future<void> Function() onRefresh;
  final List<dynamic> dataSource;
  final EdgeInsetsGeometry listPadding;
  final EdgeInsetsGeometry gridPadding;
  final double childAspectRatioMultiplyer;
  final bool placeholderCondition;
  final String placeholderText;
  final bool isPaginated;
  final void Function() placeholderRefreshFunction;

  Widget build(BuildContext context) => placeholderCondition
      ? NoDataPlaceholder(placeholderText: placeholderText, onPressed: placeholderRefreshFunction)
      : onRefresh == null
          ? _buildInteractiveList()
          : RefreshIndicator(onRefresh: onRefresh, child: _buildInteractiveList());

  Widget _buildInteractiveList() {
    return !Get.context.isTablet
        ? ListView.builder(
            shrinkWrap: true,
            physics: isPaginated ? const NeverScrollableScrollPhysics() : listPhysics,
            padding: listPadding,
            itemCount: dataSource.length,
            itemBuilder: itemBuilder,
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: isPaginated ? const NeverScrollableScrollPhysics() : gridPhysics,
            padding: gridPadding,
            itemCount: dataSource.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (Get.context.height / Get.context.width) * childAspectRatioMultiplyer,
              crossAxisSpacing: 20.0,
            ),
            itemBuilder: itemBuilder,
          );
  }
}
