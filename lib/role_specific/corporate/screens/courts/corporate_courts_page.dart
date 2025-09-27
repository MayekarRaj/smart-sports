import 'package:flutter/material.dart';
import 'package:smart_sports/shared/widgets/role_sidebar.dart';
import 'package:smart_sports/role_specific/common/role_router.dart';
import 'package:smart_sports/role_specific/corporate/screens/dashboard/corporate_dashboard_page.dart';

class CorporateCourtsPage extends StatelessWidget {
  const CorporateCourtsPage({super.key});

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
      ),
      drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: RoleSidebar(
            role: UserRole.corporate,
            selectedIndex: 2,
            edgeToEdge: true,
            onSelectIndex: (i) async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 160));
              _navigateFromCourtsSidebar(context, i);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CorporateToggle(),
            const SizedBox(height: 12),
            _ShowSearchRow(isWide: isWide),
            const SizedBox(height: 12),
            const _FilterStrip(),
            const SizedBox(height: 16),
            const _CorporateCard(),
            const SizedBox(height: 16),
            const _BranchTabs(),
            const SizedBox(height: 12),
            const _CourtDetailCard(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                'Booking Status',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 12),
            _BookingAndSlots(isWide: isWide),
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
}

void _navigateFromCourtsSidebar(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateDashboardPage()),
      );
      break;
    case 2:
      // already here
      break;
    default:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CorporateDashboardPage()),
      );
  }
}

// UI pieces below

class _CorporateToggle extends StatelessWidget {
  const _CorporateToggle();
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
        pill('All Corporates', false),
        const SizedBox(width: 8),
        pill('My Corporates', true),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
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
                fillColor: const Color(0xFFF7F7F7),
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
                fillColor: const Color(0xFFF7F7F7),
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

class _CorporateCard extends StatelessWidget {
  const _CorporateCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x14000000))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade300,
                  width: 110,
                  height: 90,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Elite Corporate Sports',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const Icon(Icons.bookmark, color: Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(spacing: 8, children: [_chip('Los Angeles, CA')]),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip('Cricket'),
                        _chip('Basketball'),
                        _chip('Tennis'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    '4.8',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('Corporate Rating'),
                  const SizedBox(height: 8),
                  _kv('Employees', '500'),
                  _kv('Courts', '15'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _btn(context, Icons.share, 'Share')),
              const SizedBox(width: 8),
              Expanded(child: _btn(context, Icons.sports_tennis, 'Events')),
              const SizedBox(width: 8),
              Expanded(child: _btn(context, Icons.group, 'Teams')),
              const SizedBox(width: 8),
              Expanded(child: _btn(context, Icons.reviews, 'Reviews')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black26),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
  Widget _kv(String k, String v) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Text(k, style: const TextStyle(fontSize: 10)),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    ),
  );
  Widget _btn(BuildContext context, IconData icon, String text) =>
      ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
}

class _BranchTabs extends StatelessWidget {
  const _BranchTabs();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _tab('Branch 1', active: true)),
        const SizedBox(width: 8),
        Expanded(child: _tab('Branch 2')),
        const SizedBox(width: 8),
        Expanded(child: _tab('Branch 3')),
      ],
    );
  }

  Widget _tab(String text, {bool active = false}) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: active ? Colors.white : const Color(0xFFF3F4F7),
      borderRadius: BorderRadius.circular(12),
      boxShadow: active
          ? const [BoxShadow(blurRadius: 6, color: Color(0x14000000))]
          : null,
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: active ? Colors.black87 : Colors.black54,
      ),
    ),
  );
}

class _CourtDetailCard extends StatelessWidget {
  const _CourtDetailCard();
  @override
  Widget build(BuildContext context) {
    Widget stat(String k, String v) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(k, style: const TextStyle(color: Colors.blue)),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x14000000))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade300,
                  width: 110,
                  height: 90,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Court 1',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, color: Colors.green, size: 12),
                        const SizedBox(width: 4),
                        const Text('Available'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        stat('Max Players', '30'),
                        const SizedBox(width: 8),
                        stat('Max Teams', '3'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        stat('Guest Cap', '300'),
                        const SizedBox(width: 8),
                        stat('Coach', '3'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: stat('Weekdays', '08:30 - 22:00')),
              const SizedBox(width: 8),
              Expanded(child: stat('Saturday', '11:30 - 20:00')),
              const SizedBox(width: 8),
              Expanded(child: stat('Sunday & Holidays', 'Off')),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingAndSlots extends StatelessWidget {
  final bool isWide;
  const _BookingAndSlots({this.isWide = false});
  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(child: _CalendarCard()),
          SizedBox(width: 12),
          Expanded(child: _SlotsCard()),
        ],
      );
    }
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_CalendarCard(), SizedBox(height: 12), _SlotsCard()],
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();
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
            children: const [
              Icon(Icons.chevron_left),
              Spacer(),
              Text('March 2025', style: TextStyle(fontWeight: FontWeight.w800)),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 35,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (ctx, i) {
              final available = i % 4 != 0;
              final selected = i == 10;
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.orange
                      : available
                      ? Colors.green
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: selected || available
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SlotsCard extends StatelessWidget {
  const _SlotsCard();
  @override
  Widget build(BuildContext context) {
    Widget slot(String title) => Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Available',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'USD 5000 4900',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue),
          ),
        ],
      ),
    );
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
            'Full Slots',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Select Available Slots to make your court booking.'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                slot('Full Month'),
                const SizedBox(width: 10),
                slot('Full Week'),
                const SizedBox(width: 10),
                slot('Full Day'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            _box('Inclusions', 'Corporate'),
            _box('Applicable To Role', 'Employee'),
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
