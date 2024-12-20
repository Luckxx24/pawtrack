class Adopt {
  final String deskripsi;
  final String id;
  // final String image;
  final String jenis;
  final String nama;
  final String status;
  final double usia;
  final String user;

  Adopt({
    required this.deskripsi,
    required this.id,
    // required this.image,
    required this.jenis,
    required this.nama,
    required this.status,
    required this.usia,
    required this.user,
  });

  // Convert Firebase document to model
  factory Adopt.fromMap(Map<String, dynamic> map) {
    return Adopt(
        deskripsi: map['deskripsi'] ?? '',
        id: map['id'] ?? '',
        // image: map['image'] ?? '',
        jenis: map['jenis'] ?? '',
        nama: map['nama'] ?? '',
        status: map['status'] ?? '',
        usia: map['usia']?.toDouble() ?? 0.0,
        user: map['user'] ?? '',
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'deskripsi': deskripsi,
      'id': id,
      // 'image': image,
      'jenis': jenis,
      'nama': nama,
      'status': status,
      'usia': usia,
      'user': user,
    };
  }
}