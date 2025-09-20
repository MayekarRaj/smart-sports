import 'package:flutter/material.dart';

enum SponsorshipParty { merchandiser, corporate }

/// Lightweight info used by the mobile header card
class EventInfo {
  final String title;
  final String venue;
  final String location;
  final double rating;
  final List<String> sports;
  final DateTime eventStart;
  final DateTime eventEnd;
  final DateTime registrationLastDate;
  final String organiserName;
  final String organiserEmail;
  final String imageUrl;

  const EventInfo({
    required this.title,
    required this.venue,
    required this.location,
    required this.rating,
    required this.sports,
    required this.eventStart,
    required this.eventEnd,
    required this.registrationLastDate,
    required this.organiserName,
    required this.organiserEmail,
    required this.imageUrl,
  });

  static EventInfo sample() => EventInfo(
        title: 'Brown Country Tournament',
        venue: 'Elite Sports Arena',
        location: 'Los Angeles, CA',
        rating: 4.8,
        sports: const ['Cricket', 'Tennis', 'Basketball', 'Softball'],
        eventStart: DateTime.now().add(const Duration(days: 28)),
        eventEnd: DateTime.now().add(const Duration(days: 30)),
        registrationLastDate: DateTime.now().add(const Duration(days: 27)),
        organiserName: 'Miles King',
        organiserEmail: 'elijahscott@gmail.com',
        imageUrl: 'https://images.unsplash.com/photo-1521417531172-0783fe5c7f26?q=80&w=1200&auto=format&fit=crop',
      );
}

enum SubscriptionRole { coach, corporate, player, guest }

class SubscriptionPlan {
  final SubscriptionRole role;
  final String currency;
  final double price;
  const SubscriptionPlan({required this.role, this.currency = 'USD', required this.price});
}

class RewardTier {
  final String label;
  final String description;
  const RewardTier(this.label, this.description);
}

class EventDaySchedule {
  final int dayNumber;
  final DateTime date;
  final String sportType;
  final TimeOfDay start;
  final TimeOfDay end;
  final String venue;
  const EventDaySchedule({
    required this.dayNumber,
    required this.date,
    required this.sportType,
    required this.start,
    required this.end,
    required this.venue,
  });
}

class TeamConfig {
  final String name;
  final String coach;
  final int maxPlayers;
  final int maxGuests;
  const TeamConfig({required this.name, required this.coach, required this.maxPlayers, required this.maxGuests});
}

class EquipmentItem {
  final String name;
  final int qty;
  final DateTime expectedDelivery;
  const EquipmentItem({required this.name, required this.qty, required this.expectedDelivery});
}

class EventDraft {
  // Organizer
  final String organizerName;
  final bool isOrganizerLoggedIn;
  // Location
  final String clubAddress;
  final bool locationSameAsClub;
  final String? eventAddress;
  // Sponsorship
  final bool sponsorshipApplicable;
  final List<SponsorshipParty> sponsorshipParties;
  // Subscriptions
  final List<SubscriptionPlan> subscriptions;
  // Rewards
  final List<RewardTier> rewards;
  // Schedule
  final List<EventDaySchedule> schedule;
  final bool sameLocationForAllDays;
  // Teams
  final List<TeamConfig> teams;
  // Equipment orders
  final List<EquipmentItem> equipment;

  const EventDraft({
    required this.organizerName,
    required this.isOrganizerLoggedIn,
    required this.clubAddress,
    required this.locationSameAsClub,
    this.eventAddress,
    required this.sponsorshipApplicable,
    required this.sponsorshipParties,
    required this.subscriptions,
    required this.rewards,
    required this.schedule,
    required this.sameLocationForAllDays,
    required this.teams,
    required this.equipment,
  });

  EventDraft copyWith({
    String? organizerName,
    bool? isOrganizerLoggedIn,
    String? clubAddress,
    bool? locationSameAsClub,
    String? eventAddress,
    bool? sponsorshipApplicable,
    List<SponsorshipParty>? sponsorshipParties,
    List<SubscriptionPlan>? subscriptions,
    List<RewardTier>? rewards,
    List<EventDaySchedule>? schedule,
    bool? sameLocationForAllDays,
    List<TeamConfig>? teams,
    List<EquipmentItem>? equipment,
  }) {
    return EventDraft(
      organizerName: organizerName ?? this.organizerName,
      isOrganizerLoggedIn: isOrganizerLoggedIn ?? this.isOrganizerLoggedIn,
      clubAddress: clubAddress ?? this.clubAddress,
      locationSameAsClub: locationSameAsClub ?? this.locationSameAsClub,
      eventAddress: eventAddress ?? this.eventAddress,
      sponsorshipApplicable: sponsorshipApplicable ?? this.sponsorshipApplicable,
      sponsorshipParties: sponsorshipParties ?? this.sponsorshipParties,
      subscriptions: subscriptions ?? this.subscriptions,
      rewards: rewards ?? this.rewards,
      schedule: schedule ?? this.schedule,
      sameLocationForAllDays: sameLocationForAllDays ?? this.sameLocationForAllDays,
      teams: teams ?? this.teams,
      equipment: equipment ?? this.equipment,
    );
  }

  static EventDraft sample() => EventDraft(
        organizerName: 'Elite Sports Arena',
        isOrganizerLoggedIn: true,
        clubAddress: 'Los Angeles, CA',
        locationSameAsClub: true,
        eventAddress: null,
        sponsorshipApplicable: false,
        sponsorshipParties: const [],
        subscriptions: const [
          SubscriptionPlan(role: SubscriptionRole.player, price: 50),
          SubscriptionPlan(role: SubscriptionRole.coach, price: 0),
        ],
        rewards: const [
          RewardTier('1st Prize', 'Gold Trophy'),
          RewardTier('2nd Prize', 'Silver Trophy'),
        ],
        schedule: const [],
        sameLocationForAllDays: true,
        teams: const [],
        equipment: const [],
      );
}
