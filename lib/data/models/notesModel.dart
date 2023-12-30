import 'dart:convert';

class NotesModel {
  String? driver;
  List<dynamic>? image;
  String? note;
String? date;
  NotesModel({this.driver, this.image, this.note,this.date});

  NotesModel.fromJson(Map<String, dynamic> json) {
    driver = json['driver'];

    image = jsonDecode(json['image']).map((e) => e.toString()).toList();
    note = json['note'];
    date = json['date'] ??"2022/12/10";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver'] = driver;
    data['image'] = image;
    data['note'] = note;
    data['date'] = date ?? "2022/12/10";
    return data;
  }
}