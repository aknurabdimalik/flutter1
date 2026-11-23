class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    final company = json['company'];
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      city: address is Map<String, dynamic> ? address['city'] as String : '',
      company: company is Map<String, dynamic> ? company['name'] as String : '',
    );
  }

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String city;
  final String company;

  String get phoneDigits =>
      phone.split('x').first.replaceAll(RegExp(r'\D'), '');

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'website': website,
    'address': {'city': city},
    'company': {'name': company},
  };
}
