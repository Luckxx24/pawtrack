class Grooming {
  final String id_servis;
  final String order;
  final String status;
  final String tipe_servis;
  final String user_id;
  final String id;

  Grooming({
    required this.id_servis,
    required this.order,
    required this.status,
    required this.tipe_servis,
    required this.user_id,
    required this.id,
  });

  // Convert Firebase document to model
  factory Grooming.fromMap(Map<String, dynamic> map) {
    return Grooming(
      id_servis: map['id_servis'] ?? '',
      order: map['order'] ?? '',
      status: map['status'] ?? '',
      tipe_servis: map['tipe_servis'] ?? '',
      user_id: map['user_id'] ?? '',
      id: map['id'] ?? '',
    );
  }

  // Convert model to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'id_servis': id_servis,
      'order': order,
      'status': status,
      'tipe_servis': tipe_servis,
      'user_id': user_id,
      'id': id,
    };
  }
}