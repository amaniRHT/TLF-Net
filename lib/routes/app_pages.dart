import 'package:e_loan_mobile/app/Authentication/password_reset/password_reset.dart';
import 'package:e_loan_mobile/app/core/password_editing/password_editing_page.dart';
import 'package:e_loan_mobile/app/pages.dart';
import 'package:e_loan_mobile/routes/app_bindings.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginPageBindings(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: SignupPageBindings(),
    ),
    GetPage(
      name: AppRoutes.passwordSetting,
      page: () => const PasswordSettingPage(),
      binding: PasswordSettingPageBindings(),
    ),
    GetPage(
      name: AppRoutes.passwordReset,
      page: () => const PasswordResetPage(),
      binding: PasswordResetPageBindings(),
    ),
    GetPage(
      name: AppRoutes.codeVerification,
      page: () => const VerificationPage(),
      binding: VerificationPageBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomePageBindings(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfilePageBindings(),
    ),
    GetPage(
      name: AppRoutes.requestCreation,
      page: () => const RequestCreationPage(),
      binding: RequestCreationPageBindings(),
    ),
    GetPage(
      name: AppRoutes.requestsList,
      page: () => const RequestsListPage(),
      binding: FundingRequestsListPageBindings(),
    ),
    GetPage(
      name: AppRoutes.requestCreationSuccess,
      page: () => const SuccessPage(),
    ),
    GetPage(
      name: AppRoutes.requestDetails,
      page: () => const RequestDetailsPage(),
      binding: RequestDetailsPageBindings(),
    ),
    GetPage<bool>(
      name: AppRoutes.requestComplement,
      page: () => const RequestComplementPage(),
      binding: RequestComplementPageBindings(),
    ),
    GetPage(
      name: AppRoutes.usersList,
      page: () => const UsersListPage(),
      binding: UsersListPageBindings(),
    ),
    GetPage(
      name: AppRoutes.userCreation,
      page: () => const UserCreationPage(),
      binding: UserCreationPageBindings(),
    ),
    // GetPage(
    //   name: AppRoutes.userDetails,
    //   page: () => const UserDetailsPage(),
    //   binding: UserDetailsPageBindings(),
    // ),
    GetPage(
      name: AppRoutes.quotationRequestsList,
      page: () => const QuotationsListPage(),
      binding: QuotationsRequestsListPageBindings(),
    ),
    GetPage(
      name: AppRoutes.quotationRequestCreation,
      page: () => const QuotationCreationPage(),
      binding: QuotationCreationPageBindings(),
    ),
    GetPage(
      name: AppRoutes.quotationRequestDetails,
      page: () => const QuotationRequestDetailsPage(),
      binding: QuotationRequestDetailsPageBindings(),
    ),
    GetPage(
      name: AppRoutes.rdvsList,
      page: () => const RDVsListPage(),
      binding: RDVsListPageBindings(),
    ),
    GetPage(
      name: AppRoutes.accountTracking,
      page: () => const AccountTrackingPage(),
      binding: AccountTrackingPageBindings(),
    ),
    GetPage(
      name: AppRoutes.repaymentSchedule,
      page: () => const RepaymentSchedulePage(),
      binding: RepaymentSchedulePageBindings(),
    ),
    GetPage(
      name: AppRoutes.inForceContracts,
      page: () => const InForceContractsPage(),
      binding: InForceContractsePageBindings(),
    ),
    GetPage(
      name: AppRoutes.invalidContracts,
      page: () => const InvalidContractsPage(),
      binding: InvalidContractsPageBindings(),
    ),
    GetPage(
      name: AppRoutes.beingImplementedContracts,
      page: () => const BeingImplementedContractsPage(),
      binding: BeingImplementedContractsPageBindings(),
    ),
    GetPage(
      name: AppRoutes.accountMovements,
      page: () => const AccountMovementsPage(),
      binding: AccountMovementsPageBindings(),
    ),
    GetPage(
      name: AppRoutes.unpaidBills,
      page: () => const UnpaidBillsPage(),
      binding: UpaidBillsPageBindings(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsListPage(),
    ),
    GetPage(
      name: AppRoutes.passwordEditing,
      page: () => const PasswordEditingPage(),
      binding: PasswordEditingPageBindings(),
    ),
  ];
}
