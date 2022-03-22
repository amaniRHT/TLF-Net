import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/password_editing/password_editing_controller.dart';
import 'package:e_loan_mobile/app/core/quotation_creation/quotation_creation_controller.dart';
import 'package:e_loan_mobile/app/core/unpaid_bills/unpaid_bills_controller.dart';
import 'package:get/get.dart';

import '../app/controllers.dart';

class LoginPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class SignupPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());
  }
}

class PasswordSettingPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordSettingController());
  }
}

class PasswordResetPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordResetController());
  }
}

class ProfilePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}

class VerificationPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerificationController());
  }
}

class RequestCreationPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestCreationController());
  }
}

class QuotationCreationPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationCreationController());
  }
}

class RequestDetailsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestDetailsController());
  }
}

class UsersListPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersListController());
    Get.lazyPut(() => UserDetailsController());
  }
}

class RequestComplementPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestComplementController());
  }
}

class UserCreationPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserCreationController());
  }
}

class QuotationRequestDetailsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuotationRequestDetailsController());
  }
}

class RDVsListPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RDVsListController());
    Get.lazyPut(() => RDVCreationController());
  }
}

class AccountTrackingPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountTrackingController());
  }
}

class RepaymentSchedulePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RepaymentScheduleController());
  }
}

class InForceContractsePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InForceContractsController());
  }
}

class InvalidContractsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvalidContractsController());
  }
}

class BeingImplementedContractsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BeingImplementedContractsController());
  }
}

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class AccountMovementsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountMovementsController());
  }
}

class UpaidBillsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnpaidBillsController());
  }
}

class FundingRequestsListPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FundingRequestsListController());
  }
}

class QuotationsRequestsListPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(QuotationRequestsListController());
  }
}

class PasswordEditingPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordEditingController());
  }
}
