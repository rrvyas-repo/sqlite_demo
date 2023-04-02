class Student {
  int? id;
  String? name;

  Student({this.id, this.name});

  factory Student.fromJson(Map<String, dynamic> json) =>
      Student(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if (id != null) {
      data['id'] = id;
    }
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }
}
