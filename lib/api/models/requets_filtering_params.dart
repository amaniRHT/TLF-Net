class RequestsFilteringParameters {
  RequestsFilteringParameters({
    this.startDate,
    this.endDate,
    this.maxAmount,
    this.minAmount,
    this.type,
    this.status,
    this.limit,
    this.page,
  });

  DateTime startDate;
  DateTime endDate;
  double maxAmount;
  double minAmount;
  String type;
  String status;
  int limit;
  int page;
}
