import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/core/users_list/user_item.dart';
import 'package:e_loan_mobile/app/core/users_list/users_filter_dialog.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'users_list_controller.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<UsersListPage> {
  final UsersListController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsersAccounts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersListController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: _buildContent(),
              floatingActionButton: _buildFloatingButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ),
        );
      },
    );
  }

  FloatActions _buildFloatingButton() {
    return FloatActions(
      visible: true,
      iconData: Icons.person_add,
      filterCount: controller.filterCount.toString(),
      onAddPressed: () {
        if (controller.usersList
                .where((Users user) => user.status == 1)
                .length >=
            10)
          showCommonModal(
            modalType: ModalTypes.alert,
            message: 'Vous avez 10 utilisateurs actif !',
            buttonTitle: 'Compris',
            onPressed: () {
              Get.back(closeOverlays: true);
            },
          );
        else
          Get.offAllNamed(
            AppRoutes.userCreation,
            arguments: <String, dynamic>{
              'creationMode': true,
              'shouldLoadWS': false,
              'data': null,
            },
          );
      },
      onFilterPressed: () => {
        controller.initialiseTECs(),
        presentDialog(
          () => const UsersFilterDialog(),
        )
      },
    );
  }

  Future<void> _refreshUsersList() async {
    controller.getUsersAccounts();
  }

  Flexible _usersList() {
    return Flexible(
      child: InteractiveLister(
        isPaginated: false,
        listPadding: const EdgeInsets.only(top: 5, bottom: 80),
        placeholderCondition:
            controller.totalResults == 0 && !controller.isLoading,
        placeholderText: controller.isLoading ? '' : 'Aucune donnée à afficher',
        placeholderRefreshFunction: _refreshUsersList,
        onRefresh: _refreshUsersList,
        dataSource: controller.usersList,
        itemBuilder: (BuildContext _, int index) => UserItem(index: index),
        childAspectRatioMultiplyer: 1.5,
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
          const CommonTitle(title: 'Gestion des utilisateurs'),
          const VerticalSpacing(16.0),
          TotalResult(
            title: '${controller.totalResults} résultats obtenus',
          ),
          const VerticalSpacing(14),
          _usersList()
        ],
      ),
    );
  }
}
