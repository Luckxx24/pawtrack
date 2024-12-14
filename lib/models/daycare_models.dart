import 'package:intl/intl.dart';

class Daycare {
  final String nama;
  final String id;
  final String durasi;
  final String deskripsi;
  final double harga;
  final DateTime jadwal;
  final String status;
  final String jenis;

  Daycare ({
    required this.nama,
    required this.id,
    required this.jadwal,
    required this.deskripsi,
    required this.harga,
    required this.durasi,
    required this.status,
    required this.jenis
  });

  // Convert Firebase document to model
  factory Daycare.fromMap(Map<String, dynamic> map) {
    return Daycare(
      nama: map['nama'] ?? '',
      id: map['id'] ?? '',
      jadwal: map['jadwal'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      harga: map['harga']?.toDouble() ?? 0.0,
      durasi: map['durasi']?? '',
      status: map['status']?? '',
      jenis: map['jenis']?? '',
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'nama_servis': nama,
      'id': id,
      'jadwal': jadwal,
      'deskripsi': deskripsi,
      'harga':harga,
      'durasi': durasi,
      'status': status,
      'jenis': jenis,
    };
  }
}