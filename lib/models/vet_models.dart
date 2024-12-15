class Vet {
  final String id;
  final String nama;
  final String deskripsi;
  final Map<String, List<String>> jadwal;
  final double harga;

  Vet({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.jadwal,
    required this.harga,
  });

  factory Vet.fromMap(Map<String, dynamic> map) {
    return Vet(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      jadwal: Map<String, List<String>>.from(
        (map['jadwal'] ?? {}).map(
              (key, value) => MapEntry(
            key,
            (value as List).map((e) => e.toString()).toList(),
          ),
        ),
      ),
      harga: (map['harga'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'jadwal': jadwal,
      'harga': harga,
    };
  }
}