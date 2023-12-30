import '../../presentation/screens/bookinghistory/bookingController.dart';

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
  LocationModel? location;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_cmpny_id'] = parentCmpnyId;
    data['company_id'] = companyId;
    data['emp_id'] = empId;
    data['to_add_comp_id'] = toAddCompId;
    data['jobcard'] = jobcard;
    data['priority'] = priority;
    data['date'] = date;
    data['timestampp'] = timestampp;
    data['companyname'] = companyname;
    data['notes'] = notes;
    data['status'] = status;
    data['from_address'] = fromAddress;
    data['to_address'] = toAddress;
    data['userid'] = userid;
    data['duetime'] = duetime;
    data['pricing'] = pricing;
    data['driver'] = driver;
    return data;
  }
}
