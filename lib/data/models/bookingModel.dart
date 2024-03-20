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
  String? from_lat ;
  String?  from_long ;
  String? to_lat ;
  String?  to_long ;
  String? suburbs;

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
        this.driver,this.suburbs,this.to_long,this.to_lat,this.from_long,this.from_lat});

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
    from_lat = json['from_lat'];
    from_long = json['from_long'];
    to_lat = json['to_lat'];
    to_long = json['to_long'];
    suburbs = json['suburbs'];
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

    data['from_lat'] = from_lat;
    data['from_long'] = from_long;
    data['to_lat'] = to_lat;
    data['to_long'] = to_long;
    data['suburbs'] = suburbs;
    return data;
  }

  // Getter for location using from_lat and from_long
  LocationModel get locationFrom {
    return LocationModel(
       double.parse(from_lat ?? "0"),
      double.parse(from_long ?? "0"),
    );
  }

  // Getter for toLocation using to_lat and to_long
  LocationModel get toLocation {
    return LocationModel(
      double.parse(to_lat ?? "0"),
      double.parse(to_long ?? "0")
    );
  }
}
