import 'package:flutter/foundation.dart';

class RDVParameters {
  String object;
  String additionalInformation;
  int status;

  RDVParameters({
    @required this.object,
    @required this.additionalInformation,
    this.status = 0,
  });
}
