class Todomodel {
  int? id;
  String name;
  bool isdone;
  Todomodel({this.id,required this.name, required this.isdone});
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'isdone': isdone ? 1 : 0,
  //   };
  // }
}
