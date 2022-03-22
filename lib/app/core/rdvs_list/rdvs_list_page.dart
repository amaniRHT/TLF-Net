import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/core/rdv_creation/rdv_creation_dialog.dart';
import 'package:e_loan_mobile/app/core/rdvs_list/rdv_item.dart';
import 'package:e_loan_mobile/app/core/rdvs_list/rdvs_filter_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'rdvs_list_controller.dart';

bool comingFromNotificationsScreenToRDVsListPage = false;

class RDVsListPage extends StatefulWidget {
  const RDVsListPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<RDVsListPage> {
  final RDVsListController controller = Get.find();

  final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRDVs().then((bool success) {
        if (success && arguments != null) _handleArguments();
      });
    });
  }

  @override
  void dispose() {
    comingFromNotificationsScreenToRDVsListPage = false;
    super.dispose();
  }

  void _handleArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (arguments['shouldOpenRdvCreationModal'] as bool != null)
        presentDialog(
          () => const RDVCreationDialog(
            creationMode: true,
            detailsMode: false,
          ),
        );
      else if (arguments['shouldOpenRdvDetailsModal'] as bool != null) {
        final List<RendezVous> currentRdv = controller.rdvsList
            .where((RendezVous rdv) => rdv.id == arguments['rdvId'])
            .toList();
        if (currentRdv.isEmpty || currentRdv.first == null) {
          showCustomToast(
            toastType: ToastTypes.warning,
            padding: 65,
            contentText:
                "La demande de rendez-vous recherchée n'est plus disponible",
            blurEffectEnabled: false,
          );
          return;
        }
        presentDialog(
          () => RDVCreationDialog(
            creationMode: false,
            detailsMode: true,
            rendezVous: currentRdv.first,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RDVsListController>(
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
      visible: true,
      iconData: Icons.create_new_folder_outlined,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        presentDialog(
          () => const RDVCreationDialog(
            creationMode: true,
            detailsMode: false,
          ),
        );
      },
      onFilterPressed: () => {
        controller.initialiseTECs(),
        presentDialog(
          () => const RDVsFilterDialog(),
        )
      },
    );
  }

  Future<void> _refreshRDVsList() async {
    controller.getRDVs();
  }

  Flexible _rdvsList() {
    return Flexible(
      child: InteractiveLister(
        isPaginated: false,
        listPadding: const EdgeInsets.only(top: 5, bottom: 80),
        placeholderCondition:
            controller.totalResults == 0 && !controller.isLoading,
        placeholderText: controller.isLoading ? '' : 'Aucune donnée à afficher',
        placeholderRefreshFunction: _refreshRDVsList,
        onRefresh: _refreshRDVsList,
        dataSource: controller.rdvsList,
        itemBuilder: (BuildContext _, int index) => RDVItem(index: index),
        childAspectRatioMultiplyer: 1.6,
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacing(27),
          const CommonTitle(title: 'Demandes de rendez-vous'),
          const VerticalSpacing(16),
          TotalResult(
            title: '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _rdvsList()
        ],
      ),
    );
  }
}
