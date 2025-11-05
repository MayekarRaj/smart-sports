class BookingModel {
  final String id;
  final String venueName;
  final String location;
  final double rating;
  final String bookingId;
  final BookingStatus status;
  final CoachInfo coach;
  final List<PlayerInfo> players;
  final BookingSchedule schedule;
  final String reservedBy;
  final String sportType;
  final String bookingAs;
  final CoachRequestStatus coachRequestStatus;
  final List<EquipmentAction> equipmentActions;

  BookingModel({
    required this.id,
    required this.venueName,
    required this.location,
    required this.rating,
    required this.bookingId,
    required this.status,
    required this.coach,
    required this.players,
    required this.schedule,
    required this.reservedBy,
    required this.sportType,
    required this.bookingAs,
    required this.coachRequestStatus,
    required this.equipmentActions,
  });
}

enum BookingStatus { waiting, waitListConfirmed, confirmed, cancelled }

enum CoachRequestStatus { pending, accepted, rejected }

class CoachInfo {
  final String name;
  final String email;
  final String imageUrl;

  CoachInfo({required this.name, required this.email, required this.imageUrl});
}

class PlayerInfo {
  final String name;
  final String imageUrl;

  PlayerInfo({required this.name, required this.imageUrl});
}

class BookingSchedule {
  final String court;
  final int slots;
  final String date;
  final String time;

  BookingSchedule({
    required this.court,
    required this.slots,
    required this.date,
    required this.time,
  });
}

class EquipmentAction {
  final String type;
  final String label;

  EquipmentAction({required this.type, required this.label});
}

// Mock data
class MockBookingData {
  static List<BookingModel> getBookings() {
    return [
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
        venueName: 'Elite Sports Arena',
        location: 'Los Angeles, CA',
        rating: 4.8,
        bookingId: '26384625',
        status: BookingStatus.waitListConfirmed,
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
        id: '3',
        venueName: 'Elite Sports Arena',
        location: 'Los Angeles, CA',
        rating: 4.8,
        bookingId: '26384626',
        status: BookingStatus.confirmed,
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
        coachRequestStatus: CoachRequestStatus.accepted,
        equipmentActions: [
          EquipmentAction(type: 'purchase', label: 'Purchase'),
          EquipmentAction(type: 'repair', label: 'Repair'),
        ],
      ),
    ];
  }
}
