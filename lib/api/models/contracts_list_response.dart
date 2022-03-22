class ContractListModel {
  List<int> contract;

  ContractListModel({this.contract});

  ContractListModel.fromJson(Map<String, dynamic> json) {
    contract = json['contract'].cast<int>();
  }

}
