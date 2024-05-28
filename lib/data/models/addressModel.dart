class DentalLab {
  final String labName;
  final String labAddress;
  final String company_id;
  final String to_add_company_id;

  DentalLab({
    required this.labName,
    required this.labAddress,
    required this.company_id,
    required this.to_add_company_id
  });

  factory DentalLab.fromJson(Map<String, dynamic> json) {
    return DentalLab(
      labName: json['labname'],
      labAddress: json['labaddress'],
      company_id: json['company_id'],
        to_add_company_id:json['to_add_company_id']
    );
  }
}
