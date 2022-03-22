class AppRoutes {
  AppRoutes._();

  //! Splash
  static const String splash = 'splash';

  //! Authentication
  static const String login = 'login';
  static const String signup = 'signup';
  static const String passwordSetting = 'passwordSetting';
  static const String passwordReset = 'passwordReset';
  static const String codeVerification = 'passwordResetVerification';

  //!Password editing
  static const String passwordEditing = 'passwordEditing';

  //! Home
  static const String home = 'home';

  //! Profile
  static const String profile = 'profile';
  static const String profilePage = '/() => ProfilePage';

  //! Funding request
  static const String requestsList = 'requestsList';
  static const String requestCreation = 'requestCreation';
  static const String requestCreationSuccess = 'requestCreationsuccess';
  static const String requestDetails = 'requestDetails';
  static const String requestComplement = 'requestComplement';

  //! Quotation request
  static const String quotationRequestsList = 'quotationRequestsList';
  static const String quotationRequestCreation = 'quotationRequestCreation';
  static const String quotationRequestDetails = 'quotationRequestDetails';

  //! Quotation request
  static const String rdvsList = 'rdvsList';
  static const String rdvCreation = 'rdvCreation';
  static const String rdvDetails = 'rdvDetails';

  //! User
  static const String usersList = 'usersList';
  static const String userCreation = 'userCreation';
  static const String userDetails = 'userDetails';

  //! Account tracking
  static const String accountTracking = 'accountTracking';

  //! Repayment schedule
  static const String repaymentSchedule = 'repaymentSchedule';

  //! In force contract
  static const String inForceContracts = 'inForceContracts';

  //! Invalid contract
  static const String invalidContracts = 'invalidContracts';

  //! Being implemented contract
  static const String beingImplementedContracts = 'beingImplementedContracts';

  //! Account movements
  static const String accountMovements = 'accountMovments';

  //! Unpaid bills
  static const String unpaidBills = 'unpaidBills';

  //! Notifications
  static const String notifications = 'notifications';
  static const String notificationsPage = '/() => NotificationsListPage';

  //! Agency Details
  static const String agencyDialog = 'agencyDialog';

  static const List<String> initialRoutes = const <String>[
    profilePage,
    login,
    passwordSetting,
    home,
    profile,
    requestsList,
    requestCreation,
    usersList,
    userCreation,
    quotationRequestsList,
    quotationRequestCreation,
    rdvsList,
    accountTracking,
    notificationsPage,
    passwordEditing
  ];

  static const List<String> accountTrackingChildRoutes = const <String>[
    repaymentSchedule,
    inForceContracts,
    invalidContracts,
    beingImplementedContracts,
    accountMovements,
    unpaidBills,
  ];
}
