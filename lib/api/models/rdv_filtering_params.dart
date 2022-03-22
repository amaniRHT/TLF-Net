class RDVsFilteringParameters {
  RDVsFilteringParameters({
    this.startDate,
    this.endDate,
    this.object,
    this.status,
  });

  String startDate;
  String endDate;
  String object;
  String status;

  bool isNull() {
    return startDate == null && endDate == null && object == null && status == null;
  }
}
