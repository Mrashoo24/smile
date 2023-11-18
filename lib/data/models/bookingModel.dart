class BookingModel {
  String? id;
  String? parentCmpnyId;
  String? companyId;
  String? empId;
  String? toAddCompId;
  String? jobcard;
  String? priority;
  String? date;
  String? timestampp;
  String? companyname;
  String? notes;
  String? status;
  String? fromAddress;
  String? toAddress;
  String? userid;
  String? duetime;
  String? pricing;
  String? driver;

  BookingModel(
      {this.id,
        this.parentCmpnyId,
        this.companyId,
        this.empId,
        this.toAddCompId,
        this.jobcard,
        this.priority,
        this.date,
        this.timestampp,
        this.companyname,
        this.notes,
        this.status,
        this.fromAddress,
        this.toAddress,
        this.userid,
        this.duetime,
        this.pricing,
        this.driver});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentCmpnyId = json['parent_cmpny_id'];
    companyId = json['company_id'];
    empId = json['emp_id'];
    toAddCompId = json['to_add_comp_id'];
    jobcard = json['jobcard'];
    priority = json['priority'];
    date = json['date'];
    timestampp = json['timestampp'];
    companyname = json['companyname'];
    notes = json['notes'];
    status = json['status'];
    fromAddress = json['from_address'];
    toAddress = json['to_address'];
    userid = json['userid'];
    duetime = json['duetime'];
    pricing = json['pricing'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_cmpny_id'] = this.parentCmpnyId;
    data['company_id'] = this.companyId;
    data['emp_id'] = this.empId;
    data['to_add_comp_id'] = this.toAddCompId;
    data['jobcard'] = this.jobcard;
    data['priority'] = this.priority;
    data['date'] = this.date;
    data['timestampp'] = this.timestampp;
    data['companyname'] = this.companyname;
    data['notes'] = this.notes;
    data['status'] = this.status;
    data['from_address'] = this.fromAddress;
    data['to_address'] = this.toAddress;
    data['userid'] = this.userid;
    data['duetime'] = this.duetime;
    data['pricing'] = this.pricing;
    data['driver'] = this.driver;
    return data;
  }
}
