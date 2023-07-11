class User {
  String _id;
  String _name;
  String _gmail;
  User({required String id, required String name, required String gmail}) :
    _id = id,
    _name = name,
    _gmail = gmail;
  
  String get id => _id;
  String get name => _name;
  String get gmail => _gmail;
}