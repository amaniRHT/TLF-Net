class RepaymentFilteringParameters {
  RepaymentFilteringParameters({
    this.contract_code,
    this.column,
    this.order,
    this.limit,
    this.page,
    this.startDate,
    this.endDate,
  });

  String contract_code;
  String column;
  String order;
  int limit;
  int page;
  String startDate;
  String endDate;
}
