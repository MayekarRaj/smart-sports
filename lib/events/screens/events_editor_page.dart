import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_models.dart';
import '../widgets/event_header_card.dart';

class EventsEditorPage extends StatefulWidget {
  const EventsEditorPage({super.key});

  @override
  State<EventsEditorPage> createState() => _EventsEditorPageState();
}

class _EventsEditorPageState extends State<EventsEditorPage> {
  EventDraft draft = EventDraft.sample();

  final TextEditingController _organizerCtrl = TextEditingController();
  final TextEditingController _clubAddressCtrl = TextEditingController();
  final TextEditingController _eventAddressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _organizerCtrl.text = draft.organizerName;
    _clubAddressCtrl.text = draft.clubAddress;
    _eventAddressCtrl.text = draft.eventAddress ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          // Header card similar to Booking card concept
          EventHeaderCard(
            info: EventInfo.sample(),
            onConnectOrganiser: () => _showSnack('Opening organiser profile...'),
            onSubscribe: _openSubscribeSheet,
          ),
          const SizedBox(height: 12),
          _section(
            title: 'Organizer',
            child: _organizerSection(),
          ),
          _section(
            title: 'Event Location',
            child: _locationSection(),
          ),
          _section(
            title: 'Sponsorship',
            child: _sponsorshipSection(),
          ),
          _section(
            title: 'Subscription Fees',
            child: _subscriptionsSection(),
          ),
          _section(
            title: 'Rewards',
            child: _rewardsSection(),
          ),
          _section(
            title: 'Schedule',
            child: _scheduleSection(),
          ),
          _section(
            title: 'Teams',
            child: _teamsSection(),
          ),
          _section(
            title: 'Tournament Equipment Orders',
            child: _equipmentSection(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _showSnack('Event saved as draft'),
            child: const Text('Save Draft'),
          )
        ],
      ),
    );
  }

  void _openSubscribeSheet() async {
    SubscriptionRole role = SubscriptionRole.player;
    final notesCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subscribe to Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            DropdownButtonFormField<SubscriptionRole>(
              value: role,
              items: SubscriptionRole.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(_roleLabel(r))))
                  .toList(),
              onChanged: (v) => role = v ?? role,
              decoration: const InputDecoration(labelText: 'Subscription As'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showSnack('Subscription requested as ${_roleLabel(role)}');
              },
              child: const Text('Submit Request'),
            )
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  // 1. Organizer
  Widget _organizerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Organizer is logged in'),
          value: draft.isOrganizerLoggedIn,
          onChanged: (v) => setState(() => draft = draft.copyWith(isOrganizerLoggedIn: v)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _organizerCtrl,
          decoration: const InputDecoration(labelText: 'Organizer Name'),
          onChanged: (v) => draft = draft.copyWith(organizerName: v),
        ),
      ],
    );
  }

  // 2. Location
  Widget _locationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _clubAddressCtrl,
          decoration: const InputDecoration(labelText: 'Club Address'),
          onChanged: (v) => draft = draft.copyWith(clubAddress: v),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Event location same as club address'),
          value: draft.locationSameAsClub,
          onChanged: (v) => setState(() => draft = draft.copyWith(locationSameAsClub: v)),
        ),
        if (!draft.locationSameAsClub) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _eventAddressCtrl,
            decoration: const InputDecoration(labelText: 'Event Address'),
            onChanged: (v) => draft = draft.copyWith(eventAddress: v),
          ),
        ]
      ],
    );
  }

  // 3. Sponsorship
  Widget _sponsorshipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Sponsorship Applicable'),
          value: draft.sponsorshipApplicable,
          onChanged: (v) => setState(() => draft = draft.copyWith(sponsorshipApplicable: v)),
        ),
        if (draft.sponsorshipApplicable) ...[
          Wrap(
            spacing: 8,
            children: SponsorshipParty.values.map((p) {
              final selected = draft.sponsorshipParties.contains(p);
              return FilterChip(
                label: Text(_partyLabel(p)),
                selected: selected,
                onSelected: (s) {
                  final list = [...draft.sponsorshipParties];
                  if (s && !selected) list.add(p);
                  if (!s && selected) list.remove(p);
                  setState(() => draft = draft.copyWith(sponsorshipParties: list));
                },
              );
            }).toList(),
          ),
        ]
      ],
    );
  }

  String _partyLabel(SponsorshipParty p) => p == SponsorshipParty.merchandiser ? 'Merchandiser' : 'Corporate';

  // 4. Subscriptions
  Widget _subscriptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: draft.subscriptions
              .map((s) => Chip(
                    label: Text('${_roleLabel(s.role)}: ${s.currency} ${s.price.toStringAsFixed(0)}'),
                    onDeleted: () {
                      setState(() => draft = draft.copyWith(subscriptions: draft.subscriptions.where((e) => e != s).toList()));
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _addSubscriptionSheet,
            icon: const Icon(Icons.add),
            label: const Text('Add Subscription'),
          ),
        )
      ],
    );
  }

  void _addSubscriptionSheet() async {
    SubscriptionRole role = SubscriptionRole.player;
    final priceCtrl = TextEditingController(text: '0');
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Subscription', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            DropdownButtonFormField<SubscriptionRole>(
              value: role,
              items: SubscriptionRole.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(_roleLabel(r))))
                  .toList(),
              onChanged: (v) => role = v ?? role,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price (USD)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
                setState(() => draft = draft.copyWith(
                      subscriptions: [...draft.subscriptions, SubscriptionPlan(role: role, price: price)],
                    ));
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }

  String _roleLabel(SubscriptionRole r) {
    switch (r) {
      case SubscriptionRole.coach:
        return 'Coach';
      case SubscriptionRole.corporate:
        return 'Corporate';
      case SubscriptionRole.player:
        return 'Player';
      case SubscriptionRole.guest:
        return 'Guest Viewer';
    }
  }

  // 5. Rewards
  Widget _rewardsSection() {
    final ctrlLabel = TextEditingController();
    final ctrlDesc = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: draft.rewards
              .map((r) => Chip(
                    label: Text('${r.label}: ${r.description}'),
                    onDeleted: () => setState(() => draft = draft.copyWith(rewards: draft.rewards.where((e) => e != r).toList())),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: ctrlLabel, decoration: const InputDecoration(labelText: 'Prize Label (e.g., 1st Prize)'))),
          const SizedBox(width: 8),
          Expanded(child: TextField(controller: ctrlDesc, decoration: const InputDecoration(labelText: 'Description'))),
        ]),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () {
              if (ctrlLabel.text.trim().isEmpty) return;
              setState(() => draft = draft.copyWith(rewards: [...draft.rewards, RewardTier(ctrlLabel.text.trim(), ctrlDesc.text.trim())]));
              ctrlLabel.clear();
              ctrlDesc.clear();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Prize'),
          ),
        ),
      ],
    );
  }

  // 6. Schedule
  Widget _scheduleSection() {
    final dateFmt = DateFormat('EEE, MMM d, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Same location for all days'),
          value: draft.sameLocationForAllDays,
          onChanged: (v) => setState(() => draft = draft.copyWith(sameLocationForAllDays: v)),
        ),
        const SizedBox(height: 8),
        ...draft.schedule.map((d) => _scheduleTile(d, dateFmt)).toList(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _addScheduleSheet,
            icon: const Icon(Icons.add),
            label: const Text('Add Day'),
          ),
        )
      ],
    );
  }

  Widget _scheduleTile(EventDaySchedule s, DateFormat f) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Day ${s.dayNumber}: ${s.sportType}'),
      subtitle: Text('${f.format(s.date)} • ${s.start.format(context)} - ${s.end.format(context)}\nVenue: ${s.venue}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => setState(() => draft = draft.copyWith(schedule: draft.schedule.where((e) => e != s).toList())),
      ),
    );
  }

  void _addScheduleSheet() async {
    final date = ValueNotifier<DateTime>(DateTime.now());
    final sportCtrl = TextEditingController(text: 'Cricket');
    TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 11, minute: 0);
    final venueCtrl = TextEditingController(text: draft.clubAddress);

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setM) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Schedule Day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ValueListenableBuilder<DateTime>(
                valueListenable: date,
                builder: (_, d, __) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(DateFormat('EEE, MMM d, yyyy').format(d)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    onPressed: () async {
                      final res = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: d);
                      if (res != null) date.value = res;
                    },
                  ),
                ),
              ),
              TextField(controller: sportCtrl, decoration: const InputDecoration(labelText: 'Sport Type')),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final res = await showTimePicker(context: context, initialTime: start);
                      if (res != null) setM(() => start = res);
                    },
                    icon: const Icon(Icons.schedule),
                    label: Text('Start: ${start.format(context)}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final res = await showTimePicker(context: context, initialTime: end);
                      if (res != null) setM(() => end = res);
                    },
                    icon: const Icon(Icons.schedule),
                    label: Text('End: ${end.format(context)}'),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              TextField(controller: venueCtrl, decoration: const InputDecoration(labelText: 'Venue')),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final next = EventDaySchedule(
                    dayNumber: draft.schedule.length + 1,
                    date: date.value,
                    sportType: sportCtrl.text.trim(),
                    start: start,
                    end: end,
                    venue: venueCtrl.text.trim(),
                  );
                  setState(() => draft = draft.copyWith(schedule: [...draft.schedule, next]));
                  Navigator.pop(ctx);
                },
                child: const Text('Add Day'),
              )
            ],
          ),
        );
      }),
    );
  }

  // 7. Teams
  Widget _teamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...draft.teams.map((t) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.name),
              subtitle: Text('Coach: ${t.coach} • Max Players: ${t.maxPlayers} • Max Guests: ${t.maxGuests}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => setState(() => draft = draft.copyWith(teams: draft.teams.where((e) => e != t).toList())),
              ),
            )),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _addTeamSheet,
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('Add Team'),
          ),
        ),
      ],
    );
  }

  void _addTeamSheet() async {
    final nameCtrl = TextEditingController();
    final coachCtrl = TextEditingController();
    int players = 11;
    int guests = 50;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setM) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Team', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Team Name')),
              const SizedBox(height: 8),
              TextField(controller: coachCtrl, decoration: const InputDecoration(labelText: 'Coach')),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: Slider(
                    value: players.toDouble(),
                    min: 5,
                    max: 30,
                    divisions: 25,
                    label: 'Players: $players',
                    onChanged: (v) => setM(() => players = v.round()),
                  ),
                ),
              ]),
              Row(children: [
                Expanded(
                  child: Slider(
                    value: guests.toDouble(),
                    min: 10,
                    max: 200,
                    divisions: 19,
                    label: 'Guests: $guests',
                    onChanged: (v) => setM(() => guests = v.round()),
                  ),
                ),
              ]),
              FilledButton(
                onPressed: () {
                  setState(() => draft = draft.copyWith(
                        teams: [...draft.teams, TeamConfig(name: nameCtrl.text.trim(), coach: coachCtrl.text.trim(), maxPlayers: players, maxGuests: guests)],
                      ));
                  Navigator.pop(ctx);
                },
                child: const Text('Add Team'),
              )
            ],
          ),
        );
      }),
    );
  }

  // 8. Equipment Orders
  Widget _equipmentSection() {
    final dateFmt = DateFormat('EEE, MMM d');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...draft.equipment.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${e.name} × ${e.qty}'),
              subtitle: Text('Expected: ${dateFmt.format(e.expectedDelivery)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => setState(() => draft = draft.copyWith(equipment: draft.equipment.where((x) => x != e).toList())),
              ),
            )),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _addEquipmentSheet,
            icon: const Icon(Icons.add_shopping_cart_outlined),
            label: const Text('Add Equipment'),
          ),
        ),
        const SizedBox(height: 8),
        Text('After placing order, it will be sent as a bidding order to merchandisers/freelancers based on selected sport. Vendors can accept/reject and quote.', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        const SizedBox(height: 8),
        FilledButton.tonal(onPressed: () => _showSnack('Order placed. Awaiting bids...'), child: const Text('Place Bidding Order')),
      ],
    );
  }

  void _addEquipmentSheet() async {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    DateTime delivery = DateTime.now().add(const Duration(days: 7));
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, setM) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Equipment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Item Name')),
              const SizedBox(height: 8),
              TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Expected Delivery'),
                subtitle: Text(DateFormat('EEE, MMM d, yyyy').format(delivery)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () async {
                    final res = await showDatePicker(context: context, initialDate: delivery, firstDate: DateTime(2020), lastDate: DateTime(2100));
                    if (res != null) setM(() => delivery = res);
                  },
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  final qty = int.tryParse(qtyCtrl.text.trim()) ?? 1;
                  setState(() => draft = draft.copyWith(equipment: [...draft.equipment, EquipmentItem(name: nameCtrl.text.trim(), qty: qty, expectedDelivery: delivery)]));
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              )
            ],
          ),
        );
      }),
    );
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
