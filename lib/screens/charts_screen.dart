import 'dart:math' as math;
import 'package:flutter/material.dart';

class StarMetric {
  final String starName;
  final String title;
  final String value;
  final IconData icon;
  final String status;
  final Color statusColor;
  final String avg7d;
  final String trend;
  final Color trendColor;
  final String target;
  final String subtitle;
  final List<double> weekPoints; // 7 normalized values (0.0 - 1.0) for Mon-Sun
  final int activeDayIndex;

  const StarMetric({
    required this.starName,
    required this.title,
    required this.value,
    required this.icon,
    required this.status,
    required this.statusColor,
    required this.avg7d,
    required this.trend,
    required this.trendColor,
    required this.target,
    required this.subtitle,
    required this.weekPoints,
    this.activeDayIndex = 4,
  });
}

const List<StarMetric> _allMetrics = [
  // 0: Rasalhague (α Oph) - Heart Rate (Top Center)
  StarMetric(
    starName: 'Rasalhague (α Oph)',
    title: 'Heart Rate',
    value: '72 BPM',
    icon: Icons.favorite_rounded,
    status: 'NORMAL',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '71 BPM',
    trend: '-2 BPM',
    trendColor: Color(0xFF4EE6AA),
    target: '60 – 100',
    subtitle: 'RESTING PULSE',
    weekPoints: [0.45, 0.42, 0.48, 0.50, 0.65, 0.48, 0.40],
  ),
  // 1: Cebalrai (β Oph) - Blood Pressure (Top Right)
  StarMetric(
    starName: 'Cebalrai (β Oph)',
    title: 'Blood Pressure',
    value: '120/80',
    icon: Icons.speed_rounded,
    status: 'OPTIMAL',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '118/78',
    trend: 'Stable',
    trendColor: Color(0xFF8ED5FF),
    target: '< 120/80',
    subtitle: 'SYS / DIA',
    weekPoints: [0.50, 0.52, 0.48, 0.51, 0.58, 0.50, 0.49],
  ),
  // 2: Han (ζ Oph) - Mood & Morale (Mid Left)
  StarMetric(
    starName: 'Han (ζ Oph)',
    title: 'Mood & Morale',
    value: '8.8/10',
    icon: Icons.sentiment_satisfied_alt_rounded,
    status: 'EXCELLENT',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '8.5/10',
    trend: '+0.4',
    trendColor: Color(0xFF4EE6AA),
    target: '> 7.0',
    subtitle: 'PSYCH EVAL',
    weekPoints: [0.60, 0.55, 0.65, 0.70, 0.88, 0.82, 0.85],
  ),
  // 3: Yed Prior (δ Oph) - Temperature (Lower Left)
  StarMetric(
    starName: 'Yed Prior (δ Oph)',
    title: 'Body Temperature',
    value: '36.5°C',
    icon: Icons.thermostat_rounded,
    status: 'NORMAL',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '36.6°C',
    trend: 'Stable',
    trendColor: Color(0xFF8ED5FF),
    target: '36.5–37.5',
    subtitle: 'CORE TEMP',
    weekPoints: [0.45, 0.48, 0.42, 0.47, 0.50, 0.46, 0.45],
  ),
  // 4: Yed Posterior (ε Oph) - Circadian REM (Lower Mid Left)
  StarMetric(
    starName: 'Yed Posterior (ε Oph)',
    title: 'Circadian REM',
    value: '2h 10m',
    icon: Icons.bedtime_rounded,
    status: 'OPTIMAL',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '1h 55m',
    trend: '+15 min',
    trendColor: Color(0xFF4EE6AA),
    target: '1.5 – 2 h',
    subtitle: 'DEEP REM',
    weekPoints: [0.35, 0.40, 0.45, 0.58, 0.75, 0.65, 0.60],
  ),
  // 5: Sabik (η Oph) - Sleep Duration (Bottom Right) [DEFAULT SELECTED]
  StarMetric(
    starName: 'Sabik (η Oph)',
    title: 'Sleep Duration',
    value: '7h 42m',
    icon: Icons.hotel_rounded,
    status: 'NORMAL',
    statusColor: Color(0xFF4EE6AA),
    avg7d: '7h 36m',
    trend: '+24 min',
    trendColor: Color(0xFF4EE6AA),
    target: '7 – 9 h',
    subtitle: 'HRV-SYNCED',
    weekPoints: [0.32, 0.38, 0.35, 0.48, 0.82, 0.55, 0.42],
  ),
];

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with SingleTickerProviderStateMixin {
  // Initially selected: 5 = Sleep Duration (matching reference design)
  int? _selectedStarIndex = 5;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onStarTapped(int index) {
    setState(() {
      if (_selectedStarIndex == index) {
        _selectedStarIndex = null; // deselect if tapped again
      } else {
        _selectedStarIndex = index; // select new metric
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Earth Horizon
          Positioned(
            left: -20,
            right: -20,
            bottom: -40,
            height: screenSize.height * 0.58,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/earth.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                Container(
                  color: const Color(0xB3000000), // 70% dark space vignette
                ),
              ],
            ),
          ),

          // Main Scrollable Area
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  // Top Header: Back Arrow, Title & Subtitle
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0x33FFFFFF),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withAlpha(40),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFFDFE1F4),
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ophiuchus',
                            style: TextStyle(
                              color: Color(0xFFDFE1F4),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                              height: 1.15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Astronaut Health Constellation',
                            style: TextStyle(
                              color: Color(0xFFCCCDCD),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Interactive Constellation Celestial Stage (370px)
                  Container(
                    height: 370,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0x800A0E1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0x331E4D7B),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x80000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;

                          // 6 Constellation star positions relative to stage:
                          final starOffsets = [
                            Offset(w * 0.44, h * 0.12), // 0: Rasalhague (Top Center)
                            Offset(w * 0.84, h * 0.26), // 1: Cebalrai (Top Right)
                            Offset(w * 0.18, h * 0.30), // 2: Han (Mid Left)
                            Offset(w * 0.14, h * 0.54), // 3: Yed Prior (Lower Left)
                            Offset(w * 0.30, h * 0.76), // 4: Yed Posterior (Lower Mid Left)
                            Offset(w * 0.80, h * 0.70), // 5: Sabik (Bottom Right)
                          ];

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background stars & vector constellation lines
                              CustomPaint(
                                size: Size(w, h),
                                painter: _ConstellationPainter(
                                  starOffsets: starOffsets,
                                  selectedIndex: _selectedStarIndex,
                                ),
                              ),

                              // Render both star dots and label pills with dedicated hit targets
                              for (int i = 0; i < starOffsets.length; i++) ...[
                                _buildStarDot(
                                  index: i,
                                  position: starOffsets[i],
                                  isSelected: _selectedStarIndex == i,
                                ),
                                _buildFloatingPill(
                                  index: i,
                                  position: starOffsets[i],
                                  metric: _allMetrics[i],
                                  isSelected: _selectedStarIndex == i,
                                  stageWidth: w,
                                  stageHeight: h,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Dynamic Bottom Information Panel
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.04),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _selectedStarIndex != null
                        ? _buildMetricDetailCard(_allMetrics[_selectedStarIndex!])
                        : _buildEmptyStateCard(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Interactive Star Dot with hit target
  Widget _buildStarDot({
    required int index,
    required Offset position,
    required bool isSelected,
  }) {
    return Positioned(
      left: position.dx - 22,
      top: position.dy - 22,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onStarTapped(index),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing Radial Glow Halo for Selected Star
              if (isSelected)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 36 * _pulseAnimation.value,
                      height: 36 * _pulseAnimation.value,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x33FFC640),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x66FFDF9F),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // Star Core Dot
              Container(
                width: isSelected ? 14 : 10,
                height: isSelected ? 14 : 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFFFDF9F)
                      : const Color(0xFFDFE1F4),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFFFFC640)
                          : Colors.white,
                      blurRadius: isSelected ? 12 : 6,
                      spreadRadius: isSelected ? 2 : 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Interactive Floating Metric Pill with dedicated position and hit target
  Widget _buildFloatingPill({
    required int index,
    required Offset position,
    required StarMetric metric,
    required bool isSelected,
    required double stageWidth,
    required double stageHeight,
  }) {
    // Exact positioning based on star index to match reference layout
    double? left;
    double? top;
    double? right;
    double? bottom;

    switch (index) {
      case 0: // Rasalhague (Top Center) -> Pill below
        left = position.dx - 40;
        top = position.dy + 16;
        break;
      case 1: // Cebalrai (Top Right) -> Pill below-left
        right = stageWidth - position.dx - 12;
        top = position.dy + 14;
        break;
      case 2: // Han (Mid Left) -> Pill above
        left = position.dx - 16;
        bottom = stageHeight - position.dy + 10;
        break;
      case 3: // Yed Prior (Lower Left) -> Pill below
        left = position.dx - 12;
        top = position.dy + 14;
        break;
      case 4: // Yed Posterior (Lower Mid Left) -> Pill above
        left = position.dx - 16;
        bottom = stageHeight - position.dy + 10;
        break;
      case 5: // Sabik (Bottom Right) -> Pill above-left
        right = stageWidth - position.dx - 12;
        bottom = stageHeight - position.dy + 12;
        break;
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onStarTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF313442)
                : const Color(0xE6262937),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFC640).withAlpha(140)
                  : Colors.white.withAlpha(20),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0x66FFC640)
                    : const Color(0x40000000),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                metric.icon,
                color: isSelected
                    ? const Color(0xFFFFDF9F)
                    : const Color(0xFF8ED5FF),
                size: 11,
              ),
              const SizedBox(width: 4),
              Text(
                metric.value,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFFDF9F)
                      : const Color(0xFFDFE1F4),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Build the Metric Detail Card
  Widget _buildMetricDetailCard(StarMetric metric) {
    return Container(
      key: ValueKey<String>(metric.title),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xE6171B28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Metric Title + Value + Status Badge + Info Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF313442),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withAlpha(30),
                    width: 1,
                  ),
                ),
                child: Icon(
                  metric.icon,
                  color: const Color(0xFF8ED5FF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.title,
                      style: const TextStyle(
                        color: Color(0xFFDFE1F4),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          metric.value,
                          style: const TextStyle(
                            color: Color(0xFFDFE1F4),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF313442),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: metric.statusColor,
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                metric.status,
                                style: TextStyle(
                                  color: metric.statusColor,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF262937),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF87929A),
                  size: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2-Column Body: 65% Chart & 35% Mini Stat Stack
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Trajectory Chart)
              Expanded(
                flex: 65,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xB30A0E1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withAlpha(12),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subheader: 7-DAY TRAJECTORY & Subtitle tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '7-DAY TRAJECTORY',
                            style: TextStyle(
                              color: Color(0xFFBDC8D1),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          Text(
                            metric.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF8ED5FF),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Custom Smooth Trend Curve
                      SizedBox(
                        height: 72,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _TrajectoryChartPainter(
                            points: metric.weekPoints,
                            activeDayIndex: metric.activeDayIndex,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Day Labels: Mon -> Sun
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DayLabel('Mon'),
                          _DayLabel('Tue'),
                          _DayLabel('Wed'),
                          _DayLabel('Thu'),
                          _DayLabel('Fri', isSelected: true),
                          _DayLabel('Sat'),
                          _DayLabel('Sun', isSuccess: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Right Column (3 Mini Stat Cards)
              Expanded(
                flex: 35,
                child: Column(
                  children: [
                    _buildMiniStat(
                      label: 'AVG. (7D)',
                      value: metric.avg7d,
                      icon: metric.icon,
                      valueColor: const Color(0xFFDFE1F4),
                    ),
                    const SizedBox(height: 6),
                    _buildMiniStat(
                      label: 'TREND',
                      value: metric.trend,
                      icon: Icons.trending_up_rounded,
                      valueColor: metric.trendColor,
                    ),
                    const SizedBox(height: 6),
                    _buildMiniStat(
                      label: 'TARGET',
                      value: metric.target,
                      icon: Icons.flag_rounded,
                      valueColor: const Color(0xFFDFE1F4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: Empty State Card when star is deselected
  Widget _buildEmptyStateCard() {
    return Container(
      key: const ValueKey<String>('empty_state'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xE6171B28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF262937),
              border: Border.all(
                color: const Color(0xFF8ED5FF).withAlpha(60),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF8ED5FF),
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Select a Star to Inspect Vitals',
            style: TextStyle(
              color: Color(0xFFDFE1F4),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap any constellation star or telemetry tag above\nto inspect 7-day trajectory, averages, and targets.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF87929A),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xCC0A0E1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withAlpha(10),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF87929A),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, color: const Color(0xFF87929A), size: 10),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Custom Constellation Painter
// ─────────────────────────────────────────────

class _ConstellationPainter extends CustomPainter {
  final List<Offset> starOffsets;
  final int? selectedIndex;

  _ConstellationPainter({
    required this.starOffsets,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (starOffsets.length < 6) return;

    // Outer polygon lines connecting celestial vertices:
    // 2 (Han) -> 0 (Rasalhague) -> 1 (Cebalrai) -> 5 (Sabik) -> 4 (Yed Posterior) -> 3 (Yed Prior) -> 2
    final polygonIndices = [2, 0, 1, 5, 4, 3, 2];

    final dashedPaint = Paint()
      ..color = const Color(0x55FFC640)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < polygonIndices.length - 1; i++) {
      _drawDashedLine(
        canvas,
        starOffsets[polygonIndices[i]],
        starOffsets[polygonIndices[i + 1]],
        dashedPaint,
        dashLength: 4,
        gapLength: 3,
      );
    }

    // Internal diagonals:
    // 2 (Han) to 5 (Sabik) - Subtle cyan cross line
    final cyanPaint = Paint()
      ..color = const Color(0x4000C2FF)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(starOffsets[2], starOffsets[5], cyanPaint);

    // 3 (Yed Prior) to 1 (Cebalrai)
    final subtlePaint = Paint()
      ..color = const Color(0x25FFFFFF)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(starOffsets[3], starOffsets[1], subtlePaint);

    // Subtle background stars specks
    final speckPaint = Paint()..style = PaintingStyle.fill;
    final specks = [
      Offset(size.width * 0.08, size.height * 0.08),
      Offset(size.width * 0.33, size.height * 0.18),
      Offset(size.width * 0.72, size.height * 0.10),
      Offset(size.width * 0.88, size.height * 0.38),
      Offset(size.width * 0.12, size.height * 0.42),
      Offset(size.width * 0.90, size.height * 0.60),
      Offset(size.width * 0.22, size.height * 0.88),
    ];
    for (final s in specks) {
      speckPaint.color = Colors.white.withAlpha(70);
      canvas.drawCircle(s, 1.2, speckPaint);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashLength = 4.0,
    double gapLength = 3.0,
  }) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / distance;
    final unitY = dy / distance;

    double currentDist = 0.0;
    while (currentDist < distance) {
      final start = Offset(p1.dx + unitX * currentDist, p1.dy + unitY * currentDist);
      final remaining = distance - currentDist;
      final step = remaining < dashLength ? remaining : dashLength;
      final end = Offset(start.dx + unitX * step, start.dy + unitY * step);
      canvas.drawLine(start, end, paint);
      currentDist += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}

// ─────────────────────────────────────────────
//  Custom Trajectory Chart Painter
// ─────────────────────────────────────────────

class _TrajectoryChartPainter extends CustomPainter {
  final List<double> points;
  final int activeDayIndex;

  _TrajectoryChartPainter({
    required this.points,
    required this.activeDayIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final dx = size.width / (points.length - 1);
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      // Map 0.0 -> height - 6, 1.0 -> 8
      final y = size.height - 8 - (points[i] * (size.height - 18));
      offsets.add(Offset(i * dx, y));
    }

    // Build smooth cubic bezier path
    final path = Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final controlPoint1 = Offset(p0.dx + dx / 2, p0.dy);
      final controlPoint2 = Offset(p1.dx - dx / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Draw Gradient Fill beneath curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x5500C2FF),
          Color(0x0000C2FF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw main stroke
    final strokePaint = Paint()
      ..color = const Color(0xFF00C2FF)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Draw data points
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < offsets.length; i++) {
      if (i == activeDayIndex) {
        // Highlight active day with gold glow
        dotPaint.color = const Color(0xFFFFC640);
        canvas.drawCircle(offsets[i], 3.5, dotPaint);
      } else {
        dotPaint.color = Colors.white;
        canvas.drawCircle(offsets[i], 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrajectoryChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.activeDayIndex != activeDayIndex;
  }
}

// ─────────────────────────────────────────────
//  Day Label Widget
// ─────────────────────────────────────────────

class _DayLabel extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isSuccess;

  const _DayLabel(
    this.text, {
    this.isSelected = false,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFFBDC8D1);
    if (isSelected) color = const Color(0xFFFFC640);
    if (isSuccess) color = const Color(0xFF4EE6AA);

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 8.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}
