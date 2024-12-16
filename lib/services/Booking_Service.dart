import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Booking_Model.dart';


class BookNowService {
  final List<BookNow> _bookings = [];

  List<BookNow> getBookings() => _bookings;

  void createBooking(BookNow booking) {
    _bookings.add(booking);
  }

  void updateBookingStatus(String id, String newStatus) {
    final index = _bookings.indexWhere((booking) => booking.id == id);
    if (index != -1) {
      _bookings[index] = BookNow(
        id: _bookings[index].id,
        serviceName: _bookings[index].serviceName,
        customerName: _bookings[index].customerName,
        status: newStatus,
        bookingDate: _bookings[index].bookingDate,
      );
    }
  }
}
