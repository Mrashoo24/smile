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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['vname'] = this.vname;
    data['vnumber'] = this.vnumber;
    data['emp_code'] = this.empCode;
    return data;
  }
}
