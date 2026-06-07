import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const AlzheimerEarlyStageApp());
}

class AlzheimerEarlyStageApp extends StatelessWidget {
  const AlzheimerEarlyStageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alzheimer Early Stage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.paper,
        fontFamily: 'Arial',
      ),
      home: const AppHome(),
    );
  }
}

class AppColors {
  static const ink = Color(0xFF24313D);
  static const muted = Color(0xFF64727F);
  static const paper = Color(0xFFF8FBFB);
  static const panel = Colors.white;
  static const line = Color(0xFFDCE4E8);
  static const teal = Color(0xFF1F7A78);
  static const green = Color(0xFF7AA95C);
  static const coral = Color(0xFFD46F5D);
  static const gold = Color(0xFFC59B3B);
  static const blue = Color(0xFF4D7EA8);
}

enum AppSection {
  overview('Inicio', Icons.home_outlined),
  patient('Paciente', Icons.favorite_border),
  caregiver('Cuidador', Icons.groups_outlined),
  doctor('Medico', Icons.medical_information_outlined),
  games('Minijuegos', Icons.extension_outlined),
  progress('Avances', Icons.timeline_outlined);

  const AppSection(this.label, this.icon);
  final String label;
  final IconData icon;
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  AppSection selected = AppSection.overview;

  String get title {
    return switch (selected) {
      AppSection.overview => 'Panel principal',
      AppSection.patient => 'Modulo Paciente',
      AppSection.caregiver => 'Modulo Cuidador',
      AppSection.doctor => 'Modulo Medico',
      AppSection.games => 'Minijuegos',
      AppSection.progress => 'Avances del proyecto',
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        return Scaffold(
          body: SafeArea(
            child: isWide
                ? Row(
                    children: [
                      Sidebar(
                        selected: selected,
                        onSelected: (section) =>
                            setState(() => selected = section),
                      ),
                      Expanded(
                        child: _MainContent(
                          title: title,
                          selected: selected,
                          onSelected: _select,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      MobileHeader(
                        selected: selected,
                        onSelected: (section) =>
                            setState(() => selected = section),
                      ),
                      Expanded(
                        child: _MainContent(
                          title: title,
                          selected: selected,
                          onSelected: _select,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _select(AppSection section) {
    setState(() => selected = section);
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.selected, required this.onSelected});

  final AppSection selected;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: AppColors.panel,
        border: Border(right: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandBlock(),
          const SizedBox(height: 28),
          ...AppSection.values.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NavButton(
                section: section,
                selected: selected == section,
                onTap: () => onSelected(section),
              ),
            ),
          ),
          const Spacer(),
          const StatusPanel(),
        ],
      ),
    );
  }
}

class MobileHeader extends StatelessWidget {
  const MobileHeader({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AppSection selected;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.panel,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandBlock(compact: true),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppSection.values
                  .map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: NavButton(
                        section: section,
                        selected: selected == section,
                        onTap: () => onSelected(section),
                        compact: true,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandBlock extends StatelessWidget {
  const BrandBlock({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: compact ? 48 : 58,
          height: compact ? 48 : 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'AES',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 14),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Proyecto de grado'),
              Text(
                'Alzheimer Early Stage',
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.section,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final AppSection section;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE9F3F2) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Icon(
                section.icon,
                color: selected ? AppColors.teal : AppColors.muted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                section.label,
                style: TextStyle(
                  color: selected ? AppColors.teal : AppColors.muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 12, color: AppColors.green),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prototipo Flutter',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Base profesional para sustentacion y desarrollo final.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({
    required this.title,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final AppSection selected;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBar(title: title),
          const SizedBox(height: 24),
          switch (selected) {
            AppSection.overview => OverviewView(onSelected: onSelected),
            AppSection.patient => const PatientView(),
            AppSection.caregiver => const CaregiverView(),
            AppSection.doctor => const DoctorView(),
            AppSection.games => const GamesView(),
            AppSection.progress => const ProgressView(),
          },
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 14,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Plataforma de estimulacion cognitiva'),
            Text(
              title,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
                height: 1.05,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.panel,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Paciente demo', style: TextStyle(color: AppColors.muted)),
              SizedBox(width: 12),
              Text('Etapa 1', style: TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key, required this.onSelected});

  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 820;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: isWide
                  ? [
                      Expanded(
                        flex: 6,
                        child: HeroPanel(onSelected: onSelected),
                      ),
                      const SizedBox(width: 18),
                      const Expanded(flex: 4, child: CognitiveSummaryPanel()),
                    ]
                  : [
                      HeroPanel(onSelected: onSelected),
                      const SizedBox(height: 18),
                      const CognitiveSummaryPanel(),
                    ],
            );
          },
        ),
        const SizedBox(height: 18),
        const ResponsiveGrid(
          children: [
            MetricCard(
              title: 'Objetivo general',
              text:
                  'Desarrollar una herramienta integral y accesible para estimulacion cognitiva.',
            ),
            MetricCard(
              title: 'Usuarios',
              text:
                  'Pacientes en etapa 1, cuidadores familiares y profesionales de salud.',
            ),
            MetricCard(
              title: 'Diferenciador',
              text:
                  'Conecta actividades, seguimiento, recordatorios y reportes clinicos.',
            ),
          ],
        ),
      ],
    );
  }
}

class HeroPanel extends StatelessWidget {
  const HeroPanel({super.key, required this.onSelected});

  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Surface(
      elevated: true,
      child: Padding(
        padding: const EdgeInsets.all(34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow(
              'Apoyo al tratamiento del Alzheimer en etapa temprana',
            ),
            const SizedBox(height: 10),
            const Text(
              'Una app accesible para memoria, atencion, lenguaje, calculo y orientacion.',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'El proyecto conecta tres roles: paciente, cuidador y medico. Cada sesion propone ejercicios simples, mide progreso y genera informacion util para acompanar la terapia.',
              style: TextStyle(
                color: AppColors.muted,
                height: 1.6,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 26),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => onSelected(AppSection.games),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Probar minijuego'),
                ),
                OutlinedButton.icon(
                  onPressed: () => onSelected(AppSection.progress),
                  icon: const Icon(Icons.timeline),
                  label: const Text('Ver avances'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CognitiveSummaryPanel extends StatelessWidget {
  const CognitiveSummaryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.teal, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        children: [
          ScoreTile(label: 'Memoria', value: '84%'),
          SizedBox(height: 14),
          ScoreTile(label: 'Atencion', value: '76%'),
          SizedBox(height: 14),
          ScoreTile(label: 'Adherencia', value: '5 dias'),
        ],
      ),
    );
  }
}

class ScoreTile extends StatelessWidget {
  const ScoreTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class PatientView extends StatelessWidget {
  const PatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          eyebrow: 'Modulo Paciente',
          title: 'Sesiones simples, botones claros y progreso visible.',
        ),
        ResponsiveGrid(children: [RoutinePanel(), MemoryBankPanel()]),
      ],
    );
  }
}

class RoutinePanel extends StatelessWidget {
  const RoutinePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelTitle('Rutina de hoy'),
          const SizedBox(height: 12),
          ...[
            ('Memoria visual', true),
            ('Atencion sostenida', false),
            ('Orientacion diaria', false),
          ].map((task) => TaskRow(label: task.$1, checked: task.$2)),
        ],
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.label, required this.checked});

  final String label;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? AppColors.green : AppColors.muted,
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class MemoryBankPanel extends StatelessWidget {
  const MemoryBankPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Banco de recuerdos'),
          BodyText(
            'Espacio para usar fotos, nombres y lugares significativos en ejercicios personalizados.',
          ),
          SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              MemoryChip('Familia'),
              MemoryChip('Casa'),
              MemoryChip('Musica'),
            ],
          ),
        ],
      ),
    );
  }
}

class CaregiverView extends StatelessWidget {
  const CaregiverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          eyebrow: 'Modulo Cuidador',
          title: 'Acompanamiento, recordatorios y datos faciles de entender.',
        ),
        ResponsiveGrid(
          children: [ReminderPanel(), AlertPanel(), CommunityPanel()],
        ),
      ],
    );
  }
}

class ReminderPanel extends StatelessWidget {
  const ReminderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Recordatorios'),
          BulletText('10:00 a. m. - Sesion cognitiva'),
          BulletText('2:00 p. m. - Hidratacion'),
          BulletText('6:00 p. m. - Actividad familiar'),
        ],
      ),
    );
  }
}

class AlertPanel extends StatelessWidget {
  const AlertPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Alertas suaves'),
          BodyText(
            'El sistema puede avisar cambios de uso, irritabilidad reportada o abandono de sesiones.',
          ),
        ],
      ),
    );
  }
}

class CommunityPanel extends StatelessWidget {
  const CommunityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Apoyo entre cuidadores'),
          BodyText(
            'Se proyecta una comunidad moderada con consejos, recursos educativos y experiencias.',
          ),
        ],
      ),
    );
  }
}

class DoctorView extends StatelessWidget {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          eyebrow: 'Modulo Medico',
          title:
              'Reportes clinicos para comparar evolucion y tomar decisiones.',
        ),
        ResponsiveGrid(children: [ClinicalSummaryPanel(), PatternPanel()]),
      ],
    );
  }
}

class ClinicalSummaryPanel extends StatelessWidget {
  const ClinicalSummaryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Resumen clinico'),
          SummaryRow(label: 'Paciente', value: 'Maria Gomez'),
          SummaryRow(label: 'Diagnostico', value: 'Alzheimer etapa inicial'),
          SummaryRow(label: 'Adherencia', value: '82%'),
          SummaryRow(label: 'Riesgo', value: 'Moderado bajo'),
        ],
      ),
    );
  }
}

class PatternPanel extends StatelessWidget {
  const PatternPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelTitle('Patrones detectados'),
          BodyText(
            'Mejor respuesta en actividades visuales. Mayor dificultad en calculo simple despues de sesiones largas.',
          ),
          SizedBox(height: 18),
          ProgressBar(
            label: 'Memoria visual',
            value: 0.84,
            color: AppColors.teal,
          ),
          ProgressBar(label: 'Atencion', value: 0.76, color: AppColors.blue),
          ProgressBar(
            label: 'Calculo simple',
            value: 0.58,
            color: AppColors.coral,
          ),
        ],
      ),
    );
  }
}

class GamesView extends StatelessWidget {
  const GamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          eyebrow: 'Minijuegos cognitivos',
          title: 'Prototipo jugable de memoria visual.',
        ),
        MemoryGame(),
      ],
    );
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final labels = const ['Casa', 'Flor', 'Sol', 'Pan', 'Taza', 'Libro'];
  late List<MemoryCardModel> cards;
  int? firstIndex;
  bool locked = false;
  int tries = 0;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    final values = [...labels, ...labels]..shuffle(Random());
    setState(() {
      cards = values.map((label) => MemoryCardModel(label)).toList();
      firstIndex = null;
      locked = false;
      tries = 0;
      matches = 0;
    });
  }

  Future<void> flipCard(int index) async {
    if (locked || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() => cards[index].isFlipped = true);

    if (firstIndex == null) {
      firstIndex = index;
      return;
    }

    final previousIndex = firstIndex!;
    setState(() => tries += 1);

    if (cards[previousIndex].label == cards[index].label) {
      setState(() {
        cards[previousIndex].isMatched = true;
        cards[index].isMatched = true;
        matches += 1;
        firstIndex = null;
      });
      return;
    }

    setState(() => locked = true);
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    setState(() {
      cards[previousIndex].isFlipped = false;
      cards[index].isFlipped = false;
      firstIndex = null;
      locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isWide
              ? [
                  Expanded(flex: 6, child: _buildBoard(constraints.maxWidth)),
                  const SizedBox(width: 18),
                  Expanded(flex: 4, child: _buildGamePanel()),
                ]
              : [
                  _buildBoard(constraints.maxWidth),
                  const SizedBox(height: 18),
                  _buildGamePanel(),
                ],
        );
      },
    );
  }

  Widget _buildBoard(double maxWidth) {
    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: maxWidth < 520 ? 3 : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) =>
          MemoryCardButton(card: cards[index], onTap: () => flipCard(index)),
    );
  }

  Widget _buildGamePanel() {
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelTitle('Memoria'),
          const BodyText(
            'Encuentra las parejas. El prototipo mide intentos y aciertos para alimentar el seguimiento.',
          ),
          const SizedBox(height: 18),
          GameStat(label: 'Intentos', value: '$tries'),
          GameStat(label: 'Parejas', value: '$matches/6'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: resetGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}

class MemoryCardModel {
  MemoryCardModel(this.label);
  final String label;
  bool isFlipped = false;
  bool isMatched = false;
}

class MemoryCardButton extends StatelessWidget {
  const MemoryCardButton({super.key, required this.card, required this.onTap});

  final MemoryCardModel card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visible = card.isFlipped || card.isMatched;
    return Material(
      color: visible ? Colors.white : AppColors.blue,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: card.isMatched
                  ? AppColors.green
                  : (visible ? AppColors.teal : AppColors.blue),
              width: visible ? 2 : 1,
            ),
          ),
          child: Text(
            visible ? card.label : '?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: visible ? AppColors.ink : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          eyebrow: 'Avances del proyecto',
          title: 'Ruta de desarrollo para presentar progreso academico.',
        ),
        TimelineItem(
          number: '1',
          title: 'Investigacion y problema',
          text:
              'Documento base, contexto del Alzheimer y justificacion en Colombia.',
          state: TimelineState.done,
        ),
        TimelineItem(
          number: '2',
          title: 'Arquitectura de modulos',
          text: 'Paciente, cuidador y medico definidos como roles principales.',
          state: TimelineState.done,
        ),
        TimelineItem(
          number: '3',
          title: 'Prototipo Flutter visible',
          text:
              'Interfaz navegable y primer minijuego funcional para demostracion.',
          state: TimelineState.current,
        ),
        TimelineItem(
          number: '4',
          title: 'Validacion',
          text:
              'Pruebas con usuarios, ajustes de accesibilidad y reportes exportables.',
          state: TimelineState.pending,
        ),
      ],
    );
  }
}

enum TimelineState { done, current, pending }

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.number,
    required this.title,
    required this.text,
    required this.state,
  });

  final String number;
  final String title;
  final String text;
  final TimelineState state;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      TimelineState.done => AppColors.green,
      TimelineState.current => AppColors.gold,
      TimelineState.pending => AppColors.muted,
    };
    final background = switch (state) {
      TimelineState.done => const Color(0xFFE7F2DF),
      TimelineState.current => const Color(0xFFFBF0D2),
      TimelineState.pending => const Color(0xFFEDF1F3),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Surface(
        borderColor:
            state == TimelineState.current ? AppColors.gold : AppColors.line,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                number,
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  BodyText(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 980
            ? 3
            : (constraints.maxWidth > 640 ? 2 : 1);
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: children
              .map(
                (child) => SizedBox(
                  width:
                      (constraints.maxWidth - (16 * (columns - 1))) / columns,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(eyebrow),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.08,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.elevated = false,
    this.borderColor = AppColors.line,
  });

  final Widget child;
  final bool elevated;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: const Color(0xFF2A3E4A).withValues(alpha: 0.12),
                  blurRadius: 45,
                  offset: const Offset(0, 18),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.teal,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          BodyText(text),
        ],
      ),
    );
  }
}

class MemoryChip extends StatelessWidget {
  const MemoryChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF675323),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('${(value * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: color,
            backgroundColor: const Color(0xFFE7ECEE),
          ),
        ],
      ),
    );
  }
}

class GameStat extends StatelessWidget {
  const GameStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.muted, height: 1.55),
    );
  }
}

class BulletText extends StatelessWidget {
  const BulletText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 6, color: AppColors.teal),
          ),
          const SizedBox(width: 10),
          Expanded(child: BodyText(text)),
        ],
      ),
    );
  }
}
