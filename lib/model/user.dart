class User {
  final int? id;
  final String name;
  final String phone;
  final String gmail;
  User({this.id, required this.name, required this.phone, required this.gmail});
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "phone": phone, "gmail": gmail};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      gmail: map['gmail'],
    );
  }
}
