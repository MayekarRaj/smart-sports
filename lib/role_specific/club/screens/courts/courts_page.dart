import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/shared/navigation/role_navigation_manager.dart';
import 'courts_list_page.dart';

class ClubCourtsPage extends StatefulWidget {
  const ClubCourtsPage({super.key});

  @override
  State<ClubCourtsPage> createState() => _ClubCourtsPageState();
}

class _ClubCourtsPageState extends State<ClubCourtsPage> {
  bool _showFilters = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showFilters = !_showFilters),
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.club,
            selectedIndex: 2,
            edgeToEdge: true,
            onSelectIndex: (i) => RoleNavigationManager.navigateToScreen(
              context,
              UserRole.club,
              i,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ClubToggle(),
            const SizedBox(height: 12),
            _ShowSearchRow(isWide: isWide),
            const SizedBox(height: 12),
            if (_showFilters) const _FilterStrip(),
            const SizedBox(height: 16),
            _EliteSportsArenaCard(onTap: () => _showAllCourts(context)),
            const SizedBox(height: 20),
            const _CoachListSection(),
            const SizedBox(height: 16),
            const _BillingMethodSection(),
            const SizedBox(height: 16),
            const _GuestSeatingSection(),
            const SizedBox(height: 16),
            const _SponsorshipSection(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAllCourts(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CourtsListPage()));
  }
}

class _EliteSportsArenaCard extends StatelessWidget {
  final VoidCallback onTap;

  const _EliteSportsArenaCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Court Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 120,
                height: 100,
                color: Colors.blue.shade100,
                child: Icon(Icons.sports_tennis, color: Colors.blue, size: 40),
              ),
            ),
            const SizedBox(width: 16),

            // Court Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Elite Sports Arena',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Favourite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Los Angeles, CA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Available Sports
                  const Text(
                    'AVAILABLE SPORTS',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      _buildSportChip('Basketball'),
                      _buildSportChip('Basketball'),
                      _buildSportChip('Basketball'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.sports_tennis,
                          label: 'Coach',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.group,
                          label: 'Players',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right side info
            Column(
              children: [
                // Coach Section
                Column(
                  children: [
                    const Text(
                      'COACH',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.yellow,
                          child: Icon(Icons.person, size: 16),
                        ),
                        Positioned(
                          left: 16,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, size: 16),
                          ),
                        ),
                        Positioned(
                          left: 32,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.person, size: 16),
                          ),
                        ),
                        Positioned(
                          left: 48,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.person, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Branch Section
                Column(
                  children: [
                    const Text(
                      'BRANCH',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Star Icon
                Icon(Icons.star, color: Colors.blue, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportChip(String sport) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        sport,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// UI pieces below

class _ClubToggle extends StatelessWidget {
  const _ClubToggle();
  @override
  Widget build(BuildContext context) {
    Widget pill(String text, bool active) => Container(
      decoration: BoxDecoration(
        color: active ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: active ? Colors.black54 : Colors.black26),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x14000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    return Row(
      children: [
        pill('All Clubs', false),
        const SizedBox(width: 8),
        pill('My Clubs', true),
      ],
    );
  }
}

class _ShowSearchRow extends StatelessWidget {
  final bool isWide;
  const _ShowSearchRow({required this.isWide});
  @override
  Widget build(BuildContext context) {
    final dd = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: 1,
          items: const [
            1,
            5,
            10,
          ].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
          onChanged: (_) {},
        ),
      ),
    );
    final search = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search Here',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show'),
              const SizedBox(width: 8),
              dd,
              const SizedBox(width: 8),
              const Text('Entries'),
            ],
          ),
          const SizedBox(height: 8),
          search,
        ],
      );
    }
    return Row(
      children: [
        const Text('Show'),
        const SizedBox(width: 8),
        dd,
        const SizedBox(width: 8),
        const Text('Entries'),
        const SizedBox(width: 12),
        Expanded(child: search),
      ],
    );
  }
}

class _FilterStrip extends StatefulWidget {
  const _FilterStrip();
  @override
  State<_FilterStrip> createState() => _FilterStripState();
}

class _FilterStripState extends State<_FilterStrip> {
  String _sport = 'Sport';
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _status = 'Any';

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 700;
    String fmtDate(DateTime? d) => d == null
        ? 'Select Date'
        : MaterialLocalizations.of(context).formatFullDate(d);
    String fmtTime(TimeOfDay? t) => t == null ? 'HH:MM' : t.format(context);

    Future<void> pickFromDate() async {
      final res = await showDatePicker(
        context: context,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100),
        initialDate: _fromDate ?? DateTime.now(),
      );
      if (res != null) setState(() => _fromDate = res);
    }

    Future<void> pickToDate() async {
      final res = await showDatePicker(
        context: context,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100),
        initialDate: _toDate ?? (_fromDate ?? DateTime.now()),
      );
      if (res != null) setState(() => _toDate = res);
    }

    Future<void> pickFromTime() async {
      final res = await showTimePicker(
        context: context,
        initialTime: _fromTime ?? TimeOfDay.now(),
      );
      if (res != null) setState(() => _fromTime = res);
    }

    Future<void> pickToTime() async {
      final res = await showTimePicker(
        context: context,
        initialTime: _toTime ?? TimeOfDay.now(),
      );
      if (res != null) setState(() => _toTime = res);
    }

    Widget dateBtn(String label, IconData icon, VoidCallback onTap) =>
        OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFFF7F7F7),
            foregroundColor: Colors.black87,
          ),
        );

    Widget tile(String title, Widget child, {double? width}) => SizedBox(
      width: isNarrow ? double.infinity : (width ?? 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E40AF)),
      ),
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: [
          tile(
            'Filter',
            DropdownButtonFormField<String>(
              value: _sport,
              items: const [
                'Sport',
                'Cricket',
                'Basketball',
                'Tennis',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _sport = v ?? _sport),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            width: 200,
          ),
          tile(
            'Date Range',
            isNarrow
                ? Column(
                    children: [
                      dateBtn(
                        fmtDate(_fromDate),
                        Icons.calendar_today,
                        pickFromDate,
                      ),
                      const SizedBox(height: 8),
                      dateBtn(
                        fmtDate(_toDate),
                        Icons.calendar_today,
                        pickToDate,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: dateBtn(
                          fmtDate(_fromDate),
                          Icons.calendar_today,
                          pickFromDate,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: dateBtn(
                          fmtDate(_toDate),
                          Icons.calendar_today,
                          pickToDate,
                        ),
                      ),
                    ],
                  ),
          ),
          tile(
            'Time',
            isNarrow
                ? Column(
                    children: [
                      dateBtn(fmtTime(_fromTime), Icons.schedule, pickFromTime),
                      const SizedBox(height: 8),
                      dateBtn(fmtTime(_toTime), Icons.schedule, pickToTime),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: dateBtn(
                          fmtTime(_fromTime),
                          Icons.schedule,
                          pickFromTime,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: dateBtn(
                          fmtTime(_toTime),
                          Icons.schedule,
                          pickToTime,
                        ),
                      ),
                    ],
                  ),
          ),
          tile(
            'Status',
            DropdownButtonFormField<String>(
              value: _status,
              items: const [
                'Any',
                'Available',
                'Maintenance',
                'Closed',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _status = v ?? _status),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            width: 200,
          ),
        ],
      ),
    );
  }
}

/// Mobile-only compact bar with a Filter button that opens the filters
/// inside a bottom sheet for a better small-screen experience.
// Removed mobile bottom-sheet filter; header toggle now controls filters inline.

// class _BookingAndSlots extends StatelessWidget {
//   final bool isWide;
//   const _BookingAndSlots({this.isWide = false});
//   @override
//   Widget build(BuildContext context) {
//     if (isWide) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [r
//           Expanded(child: _CalendarCard()),
//           SizedBox(width: 12),
//           Expanded(child: _SlotsCard()),
//         ],
//       );
//     }
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [_CalendarCard(), SizedBox(height: 12), _SlotsCard()],
//     );
//   }
// }

class _CoachListSection extends StatelessWidget {
  const _CoachListSection();
  @override
  Widget build(BuildContext context) {
    Widget row({required String name, required bool blocked}) => Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.orange),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: const Text('Football (U17), Strength & Conditioning'),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: blocked ? Colors.red : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(92, 40),
          ),
          child: Text(blocked ? 'Block' : 'Unblock'),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Coach',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Upgrade to unlock coach ratings & reviews',
                  style: TextStyle(color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        row(name: 'Riya Mehra', blocked: true),
        row(name: 'Aakash Rao', blocked: false),
      ],
    );
  }
}

class _BillingMethodSection extends StatelessWidget {
  const _BillingMethodSection();
  @override
  Widget build(BuildContext context) {
    Widget line(String unit) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(unit)),
          Container(
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: const Text('USD'),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextField(
              decoration: const InputDecoration(
                isDense: true,
                hintText: '10',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billing Method',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        line('Per 30 Min'),
        const SizedBox(height: 8),
        line('Per Hour'),
        const SizedBox(height: 8),
        line('Per Day'),
        const SizedBox(height: 8),
        line('Per Week'),
        const SizedBox(height: 8),
        line('Per Month'),
      ],
    );
  }
}

class _GuestSeatingSection extends StatefulWidget {
  const _GuestSeatingSection();
  @override
  State<_GuestSeatingSection> createState() => _GuestSeatingSectionState();
}

class _GuestSeatingSectionState extends State<_GuestSeatingSection> {
  bool available = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guest Seating',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Not Available'),
              const SizedBox(width: 6),
              Switch(
                value: available,
                onChanged: (v) => setState(() => available = v),
              ),
              const SizedBox(width: 6),
              const Text('Available'),
              const Spacer(),
              SizedBox(
                width: 110,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Capacity'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SponsorshipSection extends StatelessWidget {
  const _SponsorshipSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sponsorship Type',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Sponsorship'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.teal.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _SponsorFilter(label: 'Users'),
                _SponsorFilter(label: 'Rating'),
                _SponsorFilter(label: 'Reviews'),
                _SponsorFilter(label: 'Date Range'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(3, (i) => _sponsorRowMobile()),
        ],
      ),
    );
  }

  static Widget _sponsorRowMobile() => Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
            color: Colors.red,
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _box('Type', 'Bill Board'),
            _box('Inclusions', 'Club'),
            _box('Applicable To Role', 'Player'),
            _box('Per Day', 'USD 100'),
          ],
        ),
      ],
    ),
  );

  static Widget _box(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(value),
      ),
    ],
  );
}

class _SponsorFilter extends StatelessWidget {
  final String label;
  const _SponsorFilter({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
