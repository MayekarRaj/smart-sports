import 'package:flutter/material.dart';

enum BookingStatus { upcoming, waiting, paid, archived, cancelled }
enum PaymentStatus { pending, paid, refunded }
enum SportType { tennis, basketball, cricket, football }
enum BookingRole { owner, participant }

class Booking {
  final String id;
  final String clubName;
  final String location;
  final double rating;
  final String coachName;
  final List<String> players;
  final String court;
  final int slots;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final SportType sportType;
  final BookingRole role;
  final String imageUrl;
  final bool waitListConfirmed;

  const Booking({
    required this.id,
    required this.clubName,
    required this.location,
    required this.rating,
    required this.coachName,
    required this.players,
    required this.court,
    required this.slots,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.status,
    required this.paymentStatus,
    required this.sportType,
    required this.role,
    required this.imageUrl,
    this.waitListConfirmed = false,
  });
}

extension SportTypeX on SportType {
  String get label => switch (this) {
        SportType.tennis => 'Tennis',
        SportType.basketball => 'Basketball',
        SportType.cricket => 'Cricket',
        SportType.football => 'Football',
      };
}

extension BookingRoleX on BookingRole {
  String get label => switch (this) {
        BookingRole.owner => 'Owner',
        BookingRole.participant => 'Player',
      };
}

extension PaymentStatusX on PaymentStatus {
  String get label => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.refunded => 'Refunded',
      };
  Color get color => switch (this) {
        PaymentStatus.pending => const Color(0xFFFFE08A),
        PaymentStatus.paid => const Color(0xFFB6F0C2),
        PaymentStatus.refunded => const Color(0xFFBFD2E6),
      };
}

extension BookingStatusX on BookingStatus {
  String get label => switch (this) {
        BookingStatus.upcoming => 'Upcoming',
        BookingStatus.waiting => 'Waiting',
        BookingStatus.paid => 'Paid',
        BookingStatus.archived => 'Archived',
        BookingStatus.cancelled => 'Cancelled',
      };
}

List<Booking> mockBookings() {
  final now = DateTime.now();
  return [
    Booking(
      id: 'B-26384624',
      clubName: 'Elite Sports Arena',
      location: 'Los Angeles, CA',
      rating: 4.8,
      coachName: 'Elijah Scott',
      players: ['A', 'B', 'C', 'D'],
      court: 'Court 1',
      slots: 3,
      dateTimeStart: now.add(const Duration(days: 2, hours: 2)),
      dateTimeEnd: now.add(const Duration(days: 2, hours: 3)),
      status: BookingStatus.upcoming,
      paymentStatus: PaymentStatus.pending,
      sportType: SportType.basketball,
      role: BookingRole.owner,
      imageUrl: 'https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=1200',
      waitListConfirmed: false,
    ),
    Booking(
      id: 'B-26384625',
      clubName: 'Members Sports Academy',
      location: 'San Jose, CA',
      rating: 4.6,
      coachName: 'Sophia King',
      players: ['E', 'F', 'G'],
      court: 'Court 3',
      slots: 2,
      dateTimeStart: now.subtract(const Duration(days: 5, hours: 2)),
      dateTimeEnd: now.subtract(const Duration(days: 5, hours: 1)),
      status: BookingStatus.archived,
      paymentStatus: PaymentStatus.paid,
      sportType: SportType.tennis,
      role: BookingRole.owner,
      imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=1200',
      waitListConfirmed: true,
    ),
  ];
}

