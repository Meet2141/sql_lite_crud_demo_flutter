class Contact {

  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';

  Contact({this.id,this.name,this.mobile});

  int id;
  String name;
  String mobile;

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colMobile: mobile};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}