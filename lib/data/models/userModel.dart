class UserModel {
  String? id;
  String? firstName;
  String? email;
  String? mobileNo;
  String? vname;
  String? vnumber;
  String? empCode;

  UserModel(
      {this.id,
        this.firstName,
        this.email,
        this.mobileNo,
        this.vname,
        this.vnumber,
        this.empCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    vname = json['vname'];
    vnumber = json['vnumber'];
    empCode = json['emp_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['vname'] = vname;
    data['vnumber'] = vnumber;
    data['emp_code'] = empCode;
    return data;
  }
}
