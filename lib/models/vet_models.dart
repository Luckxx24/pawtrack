class Vet {
  final String deskripsi;
  final double harga;
  final Map<String, List<String>> jadwal;  // Map with hari (day) and waktu (time)
  final String nama;
  final String id;

  Vet({
    required this.deskripsi,
    required this.harga,
    required this.jadwal,
    required this.nama,
    required this.id,
  });

  // Convert Firebase document to model
  factory Vet.fromMap(Map<String, dynamic> map) {
    // Handle different numeric types for harga
    double parseHarga(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);
      return 0.0; // default value if parsing fails
    }

    return Vet(
      deskripsi: map['deskripsi'] ?? '',
      harga: parseHarga(map['harga']),
      jadwal: Map<String, List<String>>.from(
        map['jadwal']?.map((key, value) => MapEntry(
          key,
          List<String>.from(value),
        )) ?? {},
      ),
      nama: map['nama_servis'] ?? '',
      id: map['id'] ?? '',
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'deskripsi': deskripsi,
      'harga': harga,
      'jadwal': jadwal,
      'nama_servis': nama,
      'id': id,
    };
  }
}