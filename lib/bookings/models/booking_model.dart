import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart'; // Generated file

enum BookingStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('wait_list_confirmed')
  waitListConfirmed,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('cancelled')
  cancelled,
}

enum CoachRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
}

@JsonSerializable()
class BookingModel {
  final String id;
  
  @JsonKey(name: 'venue_name')
  final String venueName;
  
  final String location;
  final double rating;
  
  @JsonKey(name: 'booking_id')
  final String bookingId;
  
  final BookingStatus status;
  final CoachInfo coach;
  final List<PlayerInfo> players;
  final BookingSchedule schedule;
  
  @JsonKey(name: 'reserved_by')
  final String reservedBy;
  
  @JsonKey(name: 'sport_type')
  final String sportType;
  
  @JsonKey(name: 'booking_as')
  final String bookingAs;
  
  @JsonKey(name: 'coach_request_status')
  final CoachRequestStatus coachRequestStatus;
  
  @JsonKey(name: 'equipment_actions')
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

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}

@JsonSerializable()
class CoachInfo {
  final String name;
  final String email;
  
  @JsonKey(name: 'image_url')
  final String imageUrl;

  CoachInfo({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory CoachInfo.fromJson(Map<String, dynamic> json) =>
      _$CoachInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CoachInfoToJson(this);
}

@JsonSerializable()
class PlayerInfo {
  final String name;
  
  @JsonKey(name: 'image_url')
  final String imageUrl;

  PlayerInfo({
    required this.name,
    required this.imageUrl,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}

@JsonSerializable()
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

  factory BookingSchedule.fromJson(Map<String, dynamic> json) =>
      _$BookingScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$BookingScheduleToJson(this);
}

@JsonSerializable()
class EquipmentAction {
  final String type;
  final String label;

  EquipmentAction({
    required this.type,
    required this.label,
  });

  factory EquipmentAction.fromJson(Map<String, dynamic> json) =>
      _$EquipmentActionFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentActionToJson(this);
}

// Mock data - kept for backward compatibility during migration
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
