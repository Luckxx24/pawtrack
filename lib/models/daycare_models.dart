class Daycare {
  final String nama;
  final String id;
  final String jadwal;
  final String deskripsi;
  final double harga;

  Daycare ({
    required this.nama,
    required this.id,
    required this.jadwal,
    required this.deskripsi,
    required this.harga,
  });

  // Convert Firebase document to model
  factory Daycare.fromMap(Map<String, dynamic> map) {
    return Daycare(
      nama: map['nama'] ?? '',
      id: map['id'] ?? '',
      jadwal: map['jadwal'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      harga: map['harga']?.toDouble() ?? 0.0,
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'nama_servis': nama,
      'id': id,
      'jadwal': jadwal,
      'deskripsi': deskripsi,
      'harga':harga
    };
  }
}