import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/users_service.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListController extends BaseController {
  final UsersService _usersAccountsService = UsersService();

  TextEditingController emailTEC = TextEditingController();
  TextEditingController userNamesTEC = TextEditingController();
  TextEditingController userStatusTEC = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();

  List<Users> allUsers = <Users>[];
  List<Users> usersList = <Users>[];

  int totalResults = 0;
  int filterCount = 0;
  List<Tag> tags = <Tag>[];

  Set<String> selectedUsersNamesList = <String>{};
  Set<String> selectedUserStatusList = <String>{};
  Set<String> savedSelectedUserStatusList = <String>{};
  Set<String> savedSelectedUsersNamesList = <String>{};

  String userNameText = '';
  String userStatusText = '';
  String emailText = '';
  String listOrderText = '';

  bool initialState = true;

  List<String> userFullNames = <String>[];

  String userName;

  final List<String> userStatusList = <String>['En attente', 'Actif', "Inactif"];
  String userStatus;
  bool userStatusSelected = false;

  void setSelectedUsersNames() {
    userNamesTEC?.text = '';
    if (userNamesTEC?.text != null) {
      for (final item in selectedUsersNamesList)
        userNamesTEC.text.isEmpty ? userNamesTEC?.text = item : userNamesTEC?.text = '${userNamesTEC.text} - $item';
    }
    Get.back();
    update();
  }

  void setSelectedUserStatus() {
    userStatusTEC?.text = '';
    if (userStatusTEC?.text != null) {
      for (final item in selectedUserStatusList)
        userStatusTEC.text.isEmpty ? userStatusTEC?.text = item : userStatusTEC?.text = '${userStatusTEC.text} - $item';
    }
    Get.back();
    update();
  }

  void resetTECs() {
    emailTEC.text = '';
    userNamesTEC.text = '';
    userStatusTEC.text = '';
    selectedUsersNamesList.clear();
    selectedUserStatusList.clear();
    userStatusSelected = false;
    update();
  }

  void initialiseTECs() {
    emailTEC.text = emailText;
    userNamesTEC.text = userNameText;
    userStatusTEC.text = userStatusText;
    selectedUserStatusList.clear();
    selectedUserStatusList.addAll(savedSelectedUserStatusList);
    selectedUsersNamesList.clear();
    selectedUsersNamesList.addAll(savedSelectedUsersNamesList);
    update();
  }

  void setFilterData() {
    emailText = emailTEC.text;
    userNameText = userNamesTEC.text;
    userStatusText = userStatusTEC.text;
    savedSelectedUserStatusList.clear();
    savedSelectedUserStatusList.addAll(selectedUserStatusList);
    savedSelectedUsersNamesList.clear();
    savedSelectedUsersNamesList.addAll(selectedUsersNamesList);
    update();
  }

  void addTag() {
    tags = <Tag>[
      Tag(
        key: 1,
        value: userNameText.isNotEmpty ? userNameText : '',
      ),
      Tag(
        key: 2,
        value: emailText.isNotEmpty ? emailText : '',
      ),
      Tag(
        key: 3,
        value: userStatusText.isNotEmpty ? userStatusText : '',
      ),
      Tag(
        key: 4,
        value: listOrderText.isNotEmpty ? listOrderText : '',
      ),
    ];
    getFilterCount();
    update();
  }

  void getFilterCount() {
    filterCount = 0;
    tags.forEach((element) {
      if (element.value.isNotEmpty) filterCount++;
    });
    update();
  }

  bool isLoading = false;

  String prepareUsersIdsList() {
    if (selectedUsersNamesList.isEmpty || allUsers.isEmpty) return null;

    List<int> usersIdsListString = [];

    selectedUsersNamesList.forEach((String userString) {
      usersIdsListString.add(
        allUsers
                .where(
                  (Users user) => '${user.firstName ?? ''}  ${user.lastName ?? ''}' == userString,
                )
                .first
                .id ??
            null,
      );
    });

    return usersIdsListString.join(', ');
  }

  void getUsersAccounts() {
    final UsersFilteringParameters usersFilteringParameters = UsersFilteringParameters(
      userIds: prepareUsersIdsList(),
      email: emailText.isNotEmpty ? emailText : null,
      status: selectedUserStatusList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(UsefullMethods.buildUserStatusCodesList(selectedUserStatusList))
          : null,
      order: listOrderText.isNotEmpty ? listOrderText : null,
    );
    isLoading = true;
    update();
    _usersAccountsService.getUsersAccounts(parameters: usersFilteringParameters).then((UsersResponse usersResponse) {
      if (usersResponse != null && usersResponse.users != null && usersResponse.users.isNotEmpty) {
        totalResults = usersResponse.totalItems;

        usersList = usersResponse.users;

        if (usersFilteringParameters.isNull()) {
          allUsers = usersList;
          userFullNames = usersList.map((Users user) => '${user.firstName ?? ''}  ${user.lastName ?? ''}').toList();
        }
      } else {
        totalResults = 0;
        usersList = <Users>[];
      }
      isLoading = false;
      update();
    }).onError((dynamic error, StackTrace stackTrace) {
      isLoading = false;
    }).whenComplete(() => isLoading = false);
  }

  void deleteRequest({
    int userId,
    String accountUserName,
  }) {
    _usersAccountsService.deleteUserAccount(userId: userId).then(
      (bool success) {
        if (success) {
          showCustomToast(
            padding: 65,
            contentText: "L'utilisateur $accountUserName a été supprimé avec succès",
            blurEffectEnabled: false,
          );
          usersList.removeWhere((item) => item.id == userId);
          totalResults -= 1;
          update();
        } else {
          showCustomToast(
            padding: 65,
            toastType: ToastTypes.error,
            contentText: "La suppression de l'utilisateur a échoué",
            blurEffectEnabled: false,
          );
        }
      },
    );
  }

  void updateUserStatus({Users user}) {
    _usersAccountsService.updateUserStatus(userId: user.id, status: user.status == 1 ? 2 : 1).then(
      (bool success) {
        if (success) {
          showCustomToast(
            padding: 65,
            contentText:
                "L'utilisateur ${user.firstName ?? ''} ${user.lastName ?? ''} a été ${user.status == 2 ? 'activé' : 'désactivé'} avec succès",
            blurEffectEnabled: false,
          );
          user.status = user.status == 1 ? 2 : 1;
          update();
        } else {
          showCustomToast(
            padding: 65,
            toastType: ToastTypes.error,
            contentText: "${user.status == 2 ? 'L\'activation' : 'La désactivation'} de l'utilisateur a échoué",
            blurEffectEnabled: false,
          );
        }
      },
    );
  }
}
