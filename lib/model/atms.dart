class ATMs {
  late String atmId;
  late String atmName;
  late String atmAddress;
  late String atmBin;
  late String atmProp;

  ATMs.fromJson(Map<String, dynamic> json) {
    atmId = json['atmId'];
    atmName = json['atmName'];
    atmAddress = json['atmAddress'];
    atmBin = json['atmBin'];
    atmProp = json['atmProp'];
  }
}
