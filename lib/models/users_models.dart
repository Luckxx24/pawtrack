class Users {
  final String nama;
  final String id;
  final String profile_picture;
  final String role;
  final String email;
  final String password;

  Users({
    required this.nama,
    required this.id,
    required this.profile_picture,
    required this.role,
    required this.email,
    required this.password,
  });

  // Convert Firebase document to model
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      profile_picture: map['profile_picture'] ?? '',
      role: map['role']?? '',
      password:  map['password']
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'id':id,
      'profile_picture':profile_picture,
      'role': role,
      'password': password,
    };
  }
}