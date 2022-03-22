class UsersFilteringParameters {
  UsersFilteringParameters({
    this.userIds,
    this.email,
    this.status,
    this.order,
  });

  String userIds;
  String email;
  String status;
  String order;

  bool isNull() {
    return userIds == null && email == null && status == null && order == null;
  }
}
