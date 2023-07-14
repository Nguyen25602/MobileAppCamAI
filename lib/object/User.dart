class User {
  final String _id;
  final String _name;
  final String _gmail;
  User({required String id, required String name, required String gmail})
      : _id = id,
        _name = name,
        _gmail = gmail;

  String get id => _id;
  String get name => _name;
  String get gmail => _gmail;
}
