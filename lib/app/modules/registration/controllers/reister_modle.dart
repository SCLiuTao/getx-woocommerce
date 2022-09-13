class RegisterModle {
  String? name;
  String? email;
  String? password;
  int? gender;
  String? birthday;
  String? phone;
  String? address;

  RegisterModle({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.birthday,
    this.phone,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "gender": gender,
        "birthday": birthday,
        'phone': phone,
        'address': address
      };
}
