import 'package:get/get.dart';

enum ControllerStates { loading, success, noData, error }

abstract class BaseController extends GetxController {
  ControllerStates state = ControllerStates.loading;

  void loadingState() {
    state = ControllerStates.loading;
  }

  void noDataState() {
    state = ControllerStates.noData;
  }

  void successState() {
    state = ControllerStates.success;
  }
}
