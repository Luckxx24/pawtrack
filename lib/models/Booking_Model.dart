
import 'package:cloud_firestore/cloud_firestore.dart';

class BookNow {
  final String id;
  final String serviceName;
  final String customerName;
  final String status;
  final DateTime bookingDate;

  BookNow({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.status,
    required this.bookingDate,
  });

  // Convert BookNow object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'customerName': customerName,
      'status': status,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }

  // Create BookNow object from Map
  factory BookNow.fromMap(Map<String, dynamic> map) {
    return BookNow(
      id: map['id'],
      serviceName: map['serviceName'],
      customerName: map['customerName'],
      status: map['status'],
      bookingDate: DateTime.parse(map['bookingDate']),
    );
  }
}