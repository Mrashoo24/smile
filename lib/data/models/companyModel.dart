import 'dart:convert';

List<Company> companyFromJson(String str) =>
    List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  String companyName;
  String address;
  String companyId;

  Company({
    required this.companyName,
    required this.address,
    required this.companyId,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    companyName: json["companyname"],
    address: json["address"],
    companyId: json["parent_cmpny_id"],
  );

  Map<String, dynamic> toJson() => {
    "companyname": companyName,
    "address": address,
    "parent_cmpny_id": companyId,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Company &&
        other.companyName == companyName &&
        other.address == address &&
        other.companyId == companyId;
  }

  @override
  int get hashCode => companyName.hashCode ^ address.hashCode ^ companyId.hashCode;
}
