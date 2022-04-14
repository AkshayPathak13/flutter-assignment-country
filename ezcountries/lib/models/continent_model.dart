class ContinentModel {
  String? name, code;
  ContinentModel({this.name, this.code});
  ContinentModel.fromJson(Map<String, dynamic>? json) {
    code = json?['code'];
    name = json?['name'];
  }
}
