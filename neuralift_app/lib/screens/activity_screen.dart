import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Haftalık antrenman listesi — her gün birden fazla egzersiz olabilir
  final List<_WorkoutDay> _days = [
    _WorkoutDay(
      day: 'Pazartesi',
      label: 'Göğüs & Triceps',
      exercises: [
        _Exercise(name: 'Bench Press', detail: '4×12'),
        _Exercise(name: 'İncline Dumbbell Press', detail: '3×10'),
        _Exercise(name: 'Kablo Fly', detail: '3×15'),
        _Exercise(name: 'Triceps Dips', detail: '3×12'),
        _Exercise(name: 'Skull Crusher', detail: '3×12'),
      ],
    ),
    _WorkoutDay(
      day: 'Salı',
      label: 'Sırt & Biceps',
      exercises: [
        _Exercise(name: 'Deadlift', detail: '4×8'),
        _Exercise(name: 'Pull-Up', detail: '4×10'),
        _Exercise(name: 'Seated Cable Row', detail: '3×12'),
        _Exercise(name: 'Barbell Curl', detail: '3×12'),
        _Exercise(name: 'Hammer Curl', detail: '3×12'),
      ],
    ),
    _WorkoutDay(
      day: 'Çarşamba',
      label: 'Dinlenme',
      isRest: true,
      exercises: [
        _Exercise(name: 'Aktif dinlenme', detail: '20dk yürüyüş'),
        _Exercise(name: 'Esneme hareketleri', detail: '10dk'),
      ],
    ),
    _WorkoutDay(
      day: 'Perşembe',
      label: 'Bacak & Omuz',
      exercises: [
        _Exercise(name: 'Squat', detail: '4×12'),
        _Exercise(name: 'Leg Press', detail: '4×15'),
        _Exercise(name: 'Romanian Deadlift', detail: '3×12'),
        _Exercise(name: 'Lateral Raise', detail: '4×15'),
        _Exercise(name: 'Shoulder Press', detail: '3×10'),
      ],
    ),
    _WorkoutDay(
      day: 'Cuma',
      label: 'Karın & Cardio',
      exercises: [
        _Exercise(name: 'Plank', detail: '3×60sn'),
        _Exercise(name: 'Crunch', detail: '3×20'),
        _Exercise(name: 'Leg Raise', detail: '3×15'),
        _Exercise(name: 'Koşu Bandı', detail: '20dk / orta tempo'),
      ],
    ),
    _WorkoutDay(
      day: 'Cumartesi',
      label: 'Full Body',
      exercises: [
        _Exercise(name: 'Deadlift', detail: '3×8'),
        _Exercise(name: 'Bench Press', detail: '3×10'),
        _Exercise(name: 'Pull-Up', detail: '3×10'),
        _Exercise(name: 'Squat', detail: '3×12'),
        _Exercise(name: 'Core Circuit', detail: '2×15'),
      ],
    ),
    _WorkoutDay(
      day: 'Pazar',
      label: 'Dinlenme',
      isRest: true,
      exercises: [_Exercise(name: 'Tam dinlenme', detail: 'Toparlanma')],
    ),
  ];

  // Tamamlanan egzersizlerin key seti: "Pazartesi_Bench Press"
  final Set<String> _completed = {};

  int? _expandedIndex;

  String _completionText(int dayIndex) {
    final day = _days[dayIndex];
    final total = day.exercises.length;
    final done = day.exercises
        .where((e) => _completed.contains('${day.day}_${e.name}'))
        .length;
    return '$done/$total';
  }

  double _completionRatio(int dayIndex) {
    final day = _days[dayIndex];
    if (day.exercises.isEmpty) return 0;
    final done = day.exercises
        .where((e) => _completed.contains('${day.day}_${e.name}'))
        .length;
    return done / day.exercises.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1421),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Haftalık Aktivite',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_completed.length} tamamlandı',
                style: TextStyle(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: _days.length,
        itemBuilder: (ctx, i) {
          final day = _days[i];
          final isExpanded = _expandedIndex == i;
          final ratio = _completionRatio(i);
          final isRest = day.isRest;
          final accentColor = isRest ? Colors.white24 : const Color(0xFF2196F3);

          return GestureDetector(
            onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF192336),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpanded
                      ? accentColor.withValues(alpha: 0.55)
                      : const Color(0xFF253444),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  // ── Başlık
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        // Gün rozeti
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isRest
                                ? const Color(0xFF1F2D40)
                                : const Color(
                                    0xFF2196F3,
                                  ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              _shortDay(day.day),
                              style: TextStyle(
                                color: isRest
                                    ? Colors.white38
                                    : const Color(0xFF2196F3),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.day,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                day.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // İlerleme
                        if (!isRest)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _completionText(i),
                                style: TextStyle(
                                  color: ratio == 1.0
                                      ? const Color(0xFF66BB6A)
                                      : const Color(
                                          0xFF2196F3,
                                        ).withValues(alpha: 0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 64,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: ratio,
                                    minHeight: 5,
                                    backgroundColor: const Color(0xFF2C3E52),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ratio == 1.0
                                          ? const Color(0xFF66BB6A)
                                          : const Color(0xFF2196F3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (ratio == 1.0 && !isRest)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF66BB6A),
                              size: 20,
                            ),
                          ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white38,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Egzersiz listesi
                  if (isExpanded) ...[
                    const Divider(
                      color: Color(0xFF253444),
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                      itemCount: day.exercises.length,
                      itemBuilder: (ctx, j) {
                        final ex = day.exercises[j];
                        final key = '${day.day}_${ex.name}';
                        final isDone = _completed.contains(key);
                        return InkWell(
                          onTap: () => setState(() {
                            isDone
                                ? _completed.remove(key)
                                : _completed.add(key);
                          }),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 9,
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isDone
                                        ? const Color(0xFF2196F3)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: isDone
                                          ? const Color(0xFF2196F3)
                                          : const Color(0xFF2C3E52),
                                      width: 1.8,
                                    ),
                                  ),
                                  child: isDone
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    ex.name,
                                    style: TextStyle(
                                      color: isDone
                                          ? Colors.white38
                                          : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: Colors.white38,
                                    ),
                                  ),
                                ),
                                Text(
                                  ex.detail,
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.white24
                                        : const Color(
                                            0xFF2196F3,
                                          ).withValues(alpha: 0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _shortDay(String day) {
    const map = {
      'Pazartesi': 'Pzt',
      'Salı': 'Sal',
      'Çarşamba': 'Çar',
      'Perşembe': 'Per',
      'Cuma': 'Cum',
      'Cumartesi': 'Cmt',
      'Pazar': 'Paz',
    };
    return map[day] ?? day.substring(0, 3);
  }
}

// ── Modeller ──────────────────────────────────────────────────────────────────

class _WorkoutDay {
  final String day;
  final String label;
  final bool isRest;
  final List<_Exercise> exercises;

  const _WorkoutDay({
    required this.day,
    required this.label,
    this.isRest = false,
    required this.exercises,
  });
}

class _Exercise {
  final String name;
  final String detail;

  const _Exercise({required this.name, required this.detail});
}
