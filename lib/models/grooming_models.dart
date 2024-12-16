class Grooming {
  final String deskripsi;
  final String durasi;
  final String nama;
  final double harga;
  final String jadwal;
  final String id;
  final String user;
  final String status;

  Grooming({
    required this.deskripsi,
    required this.durasi,
    required this.nama,
    required this.harga,
    required this.jadwal,
    required this.id,
    required this.user,
    required this.status
  });

  // Convert Firebase document to model
  factory Grooming.fromMap(Map<String, dynamic> map) {
    return Grooming(
      deskripsi: map['deskripsi'] ?? '',
      durasi: map['durasi'] ?? '',
      nama: map['servis_nama'] ?? '',
      harga: map['harga']?.toDouble() ?? 0.0,
      jadwal: map['jadwal_waktu'] ?? '',
      id: map['studentID'] ?? '',
      user: map['user'] ?? '',
      status: map['status'] ?? '',
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'deskripsi': deskripsi,
      'durasi': durasi,
      'servis_nama': nama,
      'harga': harga,
      'jadwal_waktu': jadwal,
      'studentID': id,
      'user': user,
      'status': status
    };
  }
}