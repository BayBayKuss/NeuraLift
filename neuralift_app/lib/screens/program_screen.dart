import 'package:flutter/material.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final _aiController = TextEditingController();
  final _scrollController = ScrollController();
  bool _aiLoading = false;

  // 7 günlük program verisi
  final List<_DayPlan> _plans = [
    _DayPlan(
      day: 'Pazartesi',
      exercise: 'Göğüs & Triceps',
      sets: 4,
      reps: 12,
      notes: 'Bench press, dips, kablo',
    ),
    _DayPlan(
      day: 'Salı',
      exercise: 'Sırt & Biceps',
      sets: 4,
      reps: 10,
      notes: 'Deadlift, pull-up, curl',
    ),
    _DayPlan(
      day: 'Çarşamba',
      exercise: 'Dinlenme',
      sets: 0,
      reps: 0,
      notes: 'Aktif dinlenme veya yürüyüş',
    ),
    _DayPlan(
      day: 'Perşembe',
      exercise: 'Bacak & Omuz',
      sets: 4,
      reps: 12,
      notes: 'Squat, leg press, lateral raise',
    ),
    _DayPlan(
      day: 'Cuma',
      exercise: 'Karın & Cardio',
      sets: 3,
      reps: 20,
      notes: 'Plank, crunch, 20dk koşu',
    ),
    _DayPlan(
      day: 'Cumartesi',
      exercise: 'Full Body',
      sets: 3,
      reps: 15,
      notes: 'Compound hareketler',
    ),
    _DayPlan(
      day: 'Pazar',
      exercise: 'Dinlenme',
      sets: 0,
      reps: 0,
      notes: 'Tam dinlenme',
    ),
  ];

  int? _expandedIndex;

  @override
  void dispose() {
    _aiController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onAiAsk() async {
    final text = _aiController.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _aiLoading = true);
    // TODO: LLM backend entegrasyonu
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _aiLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1421),
      resizeToAvoidBottomInset: true,
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
          'Haftalık Program',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                // TODO: Programı kaydet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Program kaydedildi.'),
                    backgroundColor: Color(0xFF2196F3),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.check, size: 18, color: Color(0xFF2196F3)),
              label: const Text(
                'Kaydet',
                style: TextStyle(color: Color(0xFF2196F3), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 7 Günlük Liste ────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _plans.length,
              itemBuilder: (context, i) {
                final plan = _plans[i];
                final isExpanded = _expandedIndex == i;
                final isRest = plan.exercise == 'Dinlenme';
                return _DayCard(
                  plan: plan,
                  index: i,
                  isExpanded: isExpanded,
                  isRest: isRest,
                  onTap: () =>
                      setState(() => _expandedIndex = isExpanded ? null : i),
                  onExerciseChanged: (v) =>
                      setState(() => _plans[i].exercise = v),
                  onSetsChanged: (v) => setState(() => _plans[i].sets = v),
                  onRepsChanged: (v) => setState(() => _plans[i].reps = v),
                  onNotesChanged: (v) => setState(() => _plans[i].notes = v),
                );
              },
            ),
          ),

          // ── AI Yardım Alanı ───────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF192336),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 12 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF2196F3),
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'AI Asistan',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Programın hakkında soru sor',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _aiController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _onAiAsk(),
                        decoration: InputDecoration(
                          hintText:
                              'Örn: Bacak günü için alternatif egzersiz öner',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.25),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1F2D40),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2C3E52),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2196F3),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 52,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _aiLoading ? null : _onAiAsk,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          disabledBackgroundColor: const Color(
                            0xFF2196F3,
                          ).withValues(alpha: 0.4),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _aiLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gün Planı Modeli ──────────────────────────────────────────────────────────

class _DayPlan {
  final String day;
  String exercise;
  int sets;
  int reps;
  String notes;

  _DayPlan({
    required this.day,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.notes,
  });
}

// ── Gün Kartı ─────────────────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final _DayPlan plan;
  final int index;
  final bool isExpanded;
  final bool isRest;
  final VoidCallback onTap;
  final ValueChanged<String> onExerciseChanged;
  final ValueChanged<int> onSetsChanged;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<String> onNotesChanged;

  static const List<String> _dayInitials = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  const _DayCard({
    required this.plan,
    required this.index,
    required this.isExpanded,
    required this.isRest,
    required this.onTap,
    required this.onExerciseChanged,
    required this.onSetsChanged,
    required this.onRepsChanged,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isRest ? Colors.white24 : const Color(0xFF2196F3);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF192336),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? accentColor.withValues(alpha: 0.5)
                : const Color(0xFF253444),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            // ── Başlık satırı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Gün etiketi
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isRest
                          ? const Color(0xFF1F2D40)
                          : const Color(0xFF2196F3).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _dayInitials[index],
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
                          plan.day,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plan.exercise,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isRest)
                    Text(
                      '${plan.sets}×${plan.reps}',
                      style: TextStyle(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ── Genişletilmiş düzenleme alanı
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const Divider(color: Color(0xFF253444), height: 1),
                    const SizedBox(height: 14),
                    // Egzersiz adı
                    _EditRow(
                      label: 'Egzersiz',
                      initialValue: plan.exercise,
                      onChanged: onExerciseChanged,
                    ),
                    if (!isRest) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _NumberRow(
                              label: 'Set',
                              value: plan.sets,
                              onChanged: onSetsChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _NumberRow(
                              label: 'Tekrar',
                              value: plan.reps,
                              onChanged: onRepsChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    _EditRow(
                      label: 'Notlar',
                      initialValue: plan.notes,
                      onChanged: onNotesChanged,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Düzenleme Satırı ──────────────────────────────────────────────────────────

class _EditRow extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _EditRow({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_EditRow> createState() => _EditRowState();
}

class _EditRowState extends State<_EditRow> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _ctrl,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF1F2D40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2C3E52), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF2196F3),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Sayı Satırı (Set / Tekrar) ────────────────────────────────────────────────

class _NumberRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _NumberRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1F2D40),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2C3E52), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove, size: 16, color: Colors.white54),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add, size: 16, color: Colors.white54),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
