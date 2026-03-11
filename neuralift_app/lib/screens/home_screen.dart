import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'program_screen.dart';
import 'activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Mock veri ---
  final double _gymOccupancy = 0.62; // %62 doluluk
  final double _calorie = 2450;
  final double _protein = 165;
  final double _height = 180;
  final double _weight = 78;
  final double _sleepHours = 8;
  final String _workout = 'Göğüs & Triceps';

  DateTime _selectedDate = DateTime.now();
  final ScrollController _dateScrollController = ScrollController();

  // Tarihler için sahte program haritası
  final Map<String, String> _dayPrograms = {
    'Pazartesi': 'Göğüs & Triceps',
    'Salı': 'Sırt & Biceps',
    'Çarşamba': 'Dinlenme',
    'Perşembe': 'Bacak & Omuz',
    'Cuma': 'Karın & Cardio',
    'Cumartesi': 'Full Body',
    'Pazar': 'Dinlenme',
  };

  static const List<String> _weekDaysTR = [
    '',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  String _dayName(DateTime date) => _weekDaysTR[date.weekday];

  String _programForDate(DateTime date) =>
      _dayPrograms[_dayName(date)] ?? 'Dinlenme';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final baseDate = DateTime(today.year, today.month, today.day);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1421),
      floatingActionButton: _QrFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomBar(
        onActivityTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ActivityScreen()),
        ),
        onProgramTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProgramScreen()),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      'NeuraLift',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Doluluk Göstergesi ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _GymOccupancyCard(occupancy: _gymOccupancy),
              ),
            ),

            // ── Tarih Şeridi ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _formatMonthYear(_selectedDate),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 88,
                      child: ListView.builder(
                        controller: _dateScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 90,
                        itemBuilder: (context, index) {
                          final date = baseDate.add(Duration(days: index));
                          final isSelected = _isSameDay(date, _selectedDate);
                          final isToday = _isSameDay(date, today);
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDate = date),
                            child: _DateCell(
                              date: date,
                              isSelected: isSelected,
                              isToday: isToday,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Seçili Gün Programı Banner ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _SelectedDayBanner(
                  date: _selectedDate,
                  program: _programForDate(_selectedDate),
                  dayName: _dayName(_selectedDate),
                ),
              ),
            ),

            // ── İstatistik Kartları ──────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.55,
                ),
                delegate: SliverChildListDelegate([
                  _StatCard(
                    icon: Icons.local_fire_department_outlined,
                    iconColor: const Color(0xFFFF7043),
                    label: 'Kalori',
                    value: '${_calorie.toInt()}',
                    unit: 'kcal',
                  ),
                  _StatCard(
                    icon: Icons.egg_outlined,
                    iconColor: const Color(0xFF66BB6A),
                    label: 'Protein',
                    value: '${_protein.toInt()}',
                    unit: 'g',
                  ),
                  _StatCard(
                    icon: Icons.height,
                    iconColor: const Color(0xFF42A5F5),
                    label: 'Boy',
                    value: '${_height.toInt()}',
                    unit: 'cm',
                  ),
                  _StatCard(
                    icon: Icons.monitor_weight_outlined,
                    iconColor: const Color(0xFFAB47BC),
                    label: 'Kilo',
                    value: '${_weight.toInt()}',
                    unit: 'kg',
                  ),
                  _StatCard(
                    icon: Icons.bedtime_outlined,
                    iconColor: const Color(0xFF26C6DA),
                    label: 'Uyku',
                    value: '$_sleepHours',
                    unit: 'saat',
                  ),
                  _StatCard(
                    icon: Icons.fitness_center,
                    iconColor: const Color(0xFFFFCA28),
                    label: 'Antrenman',
                    value: _workout,
                    unit: '',
                    isWide: true,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// ── Spor Salonu Doluluk Kartı ─────────────────────────────────────────────────

class _GymOccupancyCard extends StatelessWidget {
  final double occupancy; // 0.0 – 1.0

  const _GymOccupancyCard({required this.occupancy});

  Color get _occupancyColor {
    if (occupancy < 0.4) return const Color(0xFF66BB6A);
    if (occupancy < 0.7) return const Color(0xFFFFCA28);
    return const Color(0xFFEF5350);
  }

  String get _occupancyLabel {
    if (occupancy < 0.4) return 'Sakin';
    if (occupancy < 0.7) return 'Orta Yoğun';
    return 'Kalabalık';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF192336),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF253444), width: 1),
      ),
      child: Row(
        children: [
          // Dairesel gösterim
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: _CircularOccupancyPainter(
                occupancy: occupancy,
                color: _occupancyColor,
              ),
              child: Center(
                child: Text(
                  '${(occupancy * 100).toInt()}%',
                  style: TextStyle(
                    color: _occupancyColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spor Salonu Doluluk',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  _occupancyLabel,
                  style: TextStyle(
                    color: _occupancyColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: occupancy,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF2C3E52),
                    valueColor: AlwaysStoppedAnimation<Color>(_occupancyColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularOccupancyPainter extends CustomPainter {
  final double occupancy;
  final Color color;

  const _CircularOccupancyPainter({
    required this.occupancy,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 7.0;

    // Arka plan halkası
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      Paint()
        ..color = const Color(0xFF2C3E52)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Doluluk halkası
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * occupancy,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CircularOccupancyPainter old) =>
      old.occupancy != occupancy || old.color != color;
}

// ── Tarih Hücresi ─────────────────────────────────────────────────────────────

class _DateCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;

  static const List<String> _shortDays = [
    '',
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  const _DateCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2196F3)
            : isToday
            ? const Color(0xFF2196F3).withValues(alpha: 0.15)
            : const Color(0xFF192336),
        borderRadius: BorderRadius.circular(14),
        border: isToday && !isSelected
            ? Border.all(color: const Color(0xFF2196F3), width: 1.2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _shortDays[date.weekday],
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${date.day}',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Seçili Gün Banner ─────────────────────────────────────────────────────────

class _SelectedDayBanner extends StatelessWidget {
  final DateTime date;
  final String program;
  final String dayName;

  const _SelectedDayBanner({
    required this.date,
    required this.program,
    required this.dayName,
  });

  bool get _isRest => program == 'Dinlenme';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _isRest
            ? const Color(0xFF1F2D40)
            : const Color(0xFF2196F3).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isRest
              ? const Color(0xFF2C3E52)
              : const Color(0xFF2196F3).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isRest ? Icons.self_improvement : Icons.fitness_center,
            color: _isRest ? Colors.white38 : const Color(0xFF2196F3),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$dayName Programı',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  program,
                  style: TextStyle(
                    color: _isRest ? Colors.white60 : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${date.day}/${date.month}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── İstatistik Kartı ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final bool isWide;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF192336),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF253444), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const Spacer(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              isWide
                  ? Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        if (unit.isNotEmpty) ...[
                          const SizedBox(width: 3),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              unit,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── QR FAB ────────────────────────────────────────────────────────────────────

class _QrFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF192336),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF2196F3),
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'QR ile Giriş',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kameranızı turnike QR koduna\ndoğrultun ve geçiş yapın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Kamera / QR tarayıcı entegrasyonu
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 20),
                    label: const Text(
                      'Kamerayı Aç',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.45),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
      ),
    );
  }
}

// ── Alt Navigasyon Çubuğu ─────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final VoidCallback? onActivityTap;
  final VoidCallback? onProgramTap;

  const _BottomBar({this.onActivityTap, this.onProgramTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF192336),
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BarItem(icon: Icons.home_outlined, label: 'Ana Sayfa', active: true),
          _BarItem(
            icon: Icons.directions_run_outlined,
            label: 'Aktivite',
            onTap: onActivityTap,
          ),
          const SizedBox(width: 56), // QR FAB boşluğu
          _BarItem(
            icon: Icons.calendar_month_outlined,
            label: 'Program',
            onTap: onProgramTap,
          ),
          _BarItem(icon: Icons.person_outline, label: 'Profil'),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _BarItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF2196F3) : Colors.white38;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
