class Branch {
  late String branchId;
  late String branchName;
  late String branchAddress;
  late String branchPhone;
  late String branchOpen;
  late String branchBin;

  Branch.fromJson(Map<String, dynamic> json) {
    branchId = json['branchId'];
    branchName = json['branchName'];
    branchAddress = json['branchAddress'];
    branchPhone = json['branchPhone'];
    branchOpen = json['branchOpen'];
    branchBin = json['branchBin'];
  }

}