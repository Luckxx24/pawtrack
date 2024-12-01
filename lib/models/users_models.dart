class Users {
  final String nama;
  final String id;
  final String profile_picture;
  final double role;
  final String email;

  Users({
    required this.nama,
    required this.id,
    required this.profile_picture,
    required this.role,
    required this.email,
  });

  // Convert Firebase document to model
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      profile_picture: map['profile_picture'] ?? '',
      role: map['role']?? '',
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
    };
  }
}