import '../models/booking_model.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => _bookings;

  void initializeBookings() {
    _bookings = [
      // Upcoming Bookings - Multiple Arenas
      BookingModel(
        id: '1',
        venueName: 'Elite Sports Arena',
        location: 'Los Angeles, CA',
        rating: 4.8,
        bookingId: '26384624',
        status: BookingStatus.waiting,
        coach: CoachInfo(
          name: 'Elijah Scott',
          email: 'Elijahscott@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Court 1',
          slots: 3,
          date: 'Thu, Apr 24, 2025',
          time: '08:30 - 10:30',
        ),
        reservedBy: 'Members Sports Academy',
        sportType: 'Basketball',
        bookingAs: 'Owner',
        coachRequestStatus: CoachRequestStatus.pending,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '2',
        venueName: 'Golden State Sports Complex',
        location: 'San Francisco, CA',
        rating: 4.6,
        bookingId: '26384625',
        status: BookingStatus.waitListConfirmed,
        coach: CoachInfo(
          name: 'Marcus Johnson',
          email: 'MarcusJohnson@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Tennis Court A',
          slots: 2,
          date: 'Fri, Apr 25, 2025',
          time: '14:00 - 16:00',
        ),
        reservedBy: 'Golden State Academy',
        sportType: 'Tennis',
        bookingAs: 'Tennis',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '3',
        venueName: 'Miami Beach Sports Center',
        location: 'Miami, FL',
        rating: 4.9,
        bookingId: '26384626',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'Sarah Williams',
          email: 'SarahWilliams@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Beach Volleyball Court',
          slots: 1,
          date: 'Sat, Apr 26, 2025',
          time: '10:00 - 12:00',
        ),
        reservedBy: 'Miami Sports Club',
        sportType: 'Volleyball',
        bookingAs: 'Coach Request',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '4',
        venueName: 'Chicago Athletic Club',
        location: 'Chicago, IL',
        rating: 4.7,
        bookingId: '26384630',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'David Chen',
          email: 'DavidChen@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Squash Court 1',
          slots: 2,
          date: 'Sun, Apr 27, 2025',
          time: '16:00 - 18:00',
        ),
        reservedBy: 'Chicago Sports Academy',
        sportType: 'Squash',
        bookingAs: 'Squash',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '5',
        venueName: 'Texas Sports Complex',
        location: 'Houston, TX',
        rating: 4.5,
        bookingId: '26384631',
        status: BookingStatus.waiting,
        coach: CoachInfo(
          name: 'Michael Rodriguez',
          email: 'MichaelRodriguez@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
          PlayerInfo(name: 'Player 5', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Football Field',
          slots: 4,
          date: 'Mon, Apr 28, 2025',
          time: '18:00 - 20:00',
        ),
        reservedBy: 'Texas Sports Academy',
        sportType: 'Football',
        bookingAs: 'Football',
        coachRequestStatus: CoachRequestStatus.pending,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '6',
        venueName: 'Seattle Sports Hub',
        location: 'Seattle, WA',
        rating: 4.8,
        bookingId: '26384632',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'Jennifer Lee',
          email: 'JenniferLee@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Badminton Court 2',
          slots: 3,
          date: 'Tue, Apr 29, 2025',
          time: '12:00 - 14:00',
        ),
        reservedBy: 'Seattle Sports Club',
        sportType: 'Badminton',
        bookingAs: 'Badminton',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      // Archived Bookings - Newly Created Bookings (Past Dates)
      BookingModel(
        id: '7',
        venueName: 'New York Sports Complex',
        location: 'New York, NY',
        rating: 4.9,
        bookingId: '26384633',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'Alex Thompson',
          email: 'AlexThompson@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Basketball Court 1',
          slots: 3,
          date: 'Mon, Dec 15, 2024',
          time: '18:00 - 20:00',
        ),
        reservedBy: 'New York Sports Academy',
        sportType: 'Basketball',
        bookingAs: 'Owner',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '8',
        venueName: 'Boston Athletic Center',
        location: 'Boston, MA',
        rating: 4.7,
        bookingId: '26384634',
        status: BookingStatus.cancelled,
        coach: CoachInfo(
          name: 'Emma Davis',
          email: 'EmmaDavis@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Tennis Court 2',
          slots: 4,
          date: 'Wed, Dec 10, 2024',
          time: '16:00 - 18:00',
        ),
        reservedBy: 'Boston Sports Club',
        sportType: 'Tennis',
        bookingAs: 'Tennis',
        coachRequestStatus: CoachRequestStatus.rejected,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '9',
        venueName: 'Denver Sports Arena',
        location: 'Denver, CO',
        rating: 4.6,
        bookingId: '26384635',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'James Wilson',
          email: 'JamesWilson@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
          PlayerInfo(name: 'Player 5', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Volleyball Court',
          slots: 5,
          date: 'Fri, Dec 5, 2024',
          time: '14:00 - 16:00',
        ),
        reservedBy: 'Denver Sports Academy',
        sportType: 'Volleyball',
        bookingAs: 'Coach Request',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '10',
        venueName: 'Phoenix Sports Complex',
        location: 'Phoenix, AZ',
        rating: 4.8,
        bookingId: '26384636',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'Lisa Anderson',
          email: 'LisaAnderson@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Swimming Pool',
          slots: 2,
          date: 'Tue, Dec 3, 2024',
          time: '10:00 - 12:00',
        ),
        reservedBy: 'Phoenix Sports Club',
        sportType: 'Swimming',
        bookingAs: 'Swimming',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '11',
        venueName: 'Atlanta Sports Center',
        location: 'Atlanta, GA',
        rating: 4.5,
        bookingId: '26384637',
        status: BookingStatus.waiting,
        coach: CoachInfo(
          name: 'Robert Taylor',
          email: 'RobertTaylor@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Cricket Ground',
          slots: 3,
          date: 'Sun, Dec 1, 2024',
          time: '12:00 - 14:00',
        ),
        reservedBy: 'Atlanta Sports Academy',
        sportType: 'Cricket',
        bookingAs: 'Cricket',
        coachRequestStatus: CoachRequestStatus.pending,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
      BookingModel(
        id: '12',
        venueName: 'Portland Sports Hub',
        location: 'Portland, OR',
        rating: 4.7,
        bookingId: '26384638',
        status: BookingStatus.confirmed,
        coach: CoachInfo(
          name: 'Maria Garcia',
          email: 'MariaGarcia@Gmail.Com',
          imageUrl: '',
        ),
        players: [
          PlayerInfo(name: 'Player 1', imageUrl: ''),
          PlayerInfo(name: 'Player 2', imageUrl: ''),
          PlayerInfo(name: 'Player 3', imageUrl: ''),
          PlayerInfo(name: 'Player 4', imageUrl: ''),
        ],
        schedule: BookingSchedule(
          court: 'Gymnasium',
          slots: 4,
          date: 'Thu, Nov 28, 2024',
          time: '08:00 - 10:00',
        ),
        reservedBy: 'Portland Sports Club',
        sportType: 'Gym',
        bookingAs: 'Gym',
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
    ];
  }

  void addBooking(BookingModel booking) {
    _bookings.insert(0, booking); // Add to the beginning of the list
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final index = _bookings.indexWhere(
      (booking) => booking.bookingId == bookingId,
    );
    if (index != -1) {
      final booking = _bookings[index];
      _bookings[index] = BookingModel(
        id: booking.id,
        venueName: booking.venueName,
        location: booking.location,
        rating: booking.rating,
        bookingId: booking.bookingId,
        status: newStatus,
        coach: booking.coach,
        players: booking.players,
        schedule: booking.schedule,
        reservedBy: booking.reservedBy,
        sportType: booking.sportType,
        bookingAs: booking.bookingAs,
        coachRequestStatus: booking.coachRequestStatus,
        equipmentActions: booking.equipmentActions,
      );
    }
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((booking) => booking.bookingId == bookingId);
  }

  List<BookingModel> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  List<BookingModel> getBookingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _bookings.where((booking) {
      // This is a simplified date parsing - in a real app, you'd want more robust date handling
      return true; // For now, return all bookings
    }).toList();
  }
}
