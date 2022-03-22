typedef AttributedString = String Function({String id});

class AppUrls {
  //! WEBSITE

  //! COOKIES
  static String cookies = 'cookies';

  //! SIGN UP
  static String signup = 'bulletin';

  //! AUTHENTICATION
  static String login = 'authentication/sign-in';
  static String setupPassword = 'authentication/set-password';
  static String forgotPassword = 'authentication/forgot-password';
  static String checkResetCode = 'authentication/check-mobile-token';
  static String resetPassword = 'authentication/set-mobile-password';

  //! EDIT PASSWORD
  static String editPassword = 'authentication/edit-password';

  //! USERS
  static AttributedString updateMyProfile = ({String id}) => 'users/$id';

  //! PROFILE
  static String getUserProfile = 'profile/me';

  //! FUNDING REQUEST LISTING
  static String getRequestsList = 'demande-financement';
  static AttributedString deleteRequest =
      ({String id}) => 'demande-financement/$id';
  static AttributedString getRequestDetails =
      ({String id}) => 'demande-financement/$id';

  //! FUNDING REQUEST CREATION
  static String getDocumentsforType = 'doc-management';
  static String createRequest = 'demande-financement';
  static AttributedString updateRequest =
      ({String id}) => 'demande-financement/$id';
  static String addComplement = 'doc-management/complement-document';

  //! ACCOUNTS
  static String getUsersList = 'users';
  static String createUser = 'users';
  static AttributedString deleteUser = ({String id}) => 'users/$id';
  static AttributedString getUserDetails = ({String id}) => 'users/$id';
  static AttributedString updateUser = ({String id}) => 'users/$id';

  //! TOKENS REFRSHING
  static String rokenRefresh = 'authentication/refresh-token';

  //! Quotation REQUEST LISTING
  static String getQuotationsList = 'demande-cotation';
  static AttributedString deleteQuotation =
      ({String id}) => 'demande-cotation/$id';
  static AttributedString getQuotationDetails =
      ({String id}) => 'demande-cotation/$id';

  //! Quotation REQUEST CREATION
  static String createQuotation = 'demande-cotation';
  static AttributedString updateQuotaion =
      ({String id}) => 'demande-cotation/$id';

  //! RDVs
  static String getRDVsList = 'demande-rdv';
  static String createRDV = 'demande-rdv';
  static AttributedString updateRDV = ({String id}) => 'demande-rdv/$id';
  static AttributedString getRDVDetails = ({String id}) => 'demande-rdv/$id';
  static AttributedString deleteRDV = ({String id}) => 'demande-rdv/$id';

  //! Repayment shedule
  static String getRepaymentList = 'suivi-compte/echeancier';
  static String getContractsList = 'suivi-compte/contrats';
  static String downloadContractsList = 'suivi-compte/echeancier/PDF';

  //! In force contracts
  static String getInForceContractsList = 'suivi-compte/contrats/1';
  static String downloadInforceContractsList = 'suivi-compte/contrats/1/PDF';

  //! Invalid contracts
  static String getInvalidContractsList = 'suivi-compte/contrats/0';
  static String downloadInvalidContractsList = 'suivi-compte/contrats/0/PDF';

  //! Being implemented contracts
  static String getBeingImplementedContractsList =
      'suivi-compte/contrats-en-cours';
  static String downloadBeingImplementedContractsList =
      'suivi-compte/contrats-en-cours/PDF';

  //! Unpaid Bills
  static String unpaidBillsList = 'suivi-compte/factures';
  static String downloadUnpaidBillsList = 'suivi-compte/factures/PDF';

  //! Account mouvements
  static String getAccountMovementsList = 'suivi-compte/mouvement-compte';
  static String downloadAccountMovementsList =
      'suivi-compte/mouvement-compte/PDF';

  //! Notifications
  static String notificationsList = 'notification';
  static String notificationsRequirements = 'users/registration-token';
  static AttributedString readNotification =
      ({String id}) => 'notification/$id';
}
