class User {
  int id;
  String name;
  String password;
  String username;
  String email;
  String rol;
  String identification;
  String type;
  String identificationType;
  int active;
  String? phone;
  String? address;
  String? state;
  String? image;
  String createdAt;
  String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.username,
    required this.email,
    required this.rol,
    required this.identification,
    required this.type,
    required this.identificationType,
    required this.active,
    this.phone,
    this.address,
    this.state,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        username: json['username'],
        email: json['email'],
        rol: json['rol'],
        identification: json['identification'],
        type: json['type'],
        identificationType: json['identification_type'],
        active: json['active'],
        phone: json['phone'],
        address: json['address'],
        state: json['state'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['password'] = password;
    data['username'] = username;
    data['email'] = email;
    data['rol'] = rol;
    data['identification'] = identification;
    data['type'] = type;
    data['identification_type'] = identificationType;
    data['active'] = active;
    data['phone'] = phone;
    data['address'] = address;
    data['state'] = state;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
