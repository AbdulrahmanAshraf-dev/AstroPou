import 'package:flutter/material.dart';

enum HealthMetric {
  radiation,
  cardiovascular,
  activity,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HealthMetric? _selectedMetric;

  late final AnimationController _idleController;
  late final Animation<double> _breatheAnimation;
  late final Animation<double> _floatAnimation;

  late final AnimationController _reactionController;
  late final Animation<double> _hopAnimation;

  static const String _defaultMessage =
      "Your health looks good! 🚀\nLet's keep your vitals stable and stay mission-ready.";

  static const List<String> _encouragingMessages = [
    "You're doing great, Commander! 🌟",
    "Keep it up! Your health looks good! 🚀",
    "I'm keeping an eye on your vitals 24/7! 🛸",
  ];

  int _tapMessageIndex = 0;
  String _companionMessage = _defaultMessage;

  @override
  void initState() {
    super.initState();

    // Gentle breathing and floating animation
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.035).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    // Interactive tap reaction (bounce / hop)
    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _hopAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -12.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -12.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60,
      ),
    ]).animate(_reactionController);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  void _onAstroPouTapped() {
    _reactionController.forward(from: 0.0);
    setState(() {
      _selectedMetric = null; // dismiss open card to focus on companion talk
      _companionMessage = _encouragingMessages[_tapMessageIndex];
      _tapMessageIndex = (_tapMessageIndex + 1) % _encouragingMessages.length;
    });
  }

  void _toggleMetric(HealthMetric metric) {
    setState(() {
      if (_selectedMetric == metric) {
        _selectedMetric = null;
        _companionMessage = _defaultMessage;
      } else {
        _selectedMetric = metric;
        switch (metric) {
          case HealthMetric.radiation:
            _companionMessage = "Radiation level is at 80%. Shield integrity is holding strong, stay safe! 🛡️";
            break;
          case HealthMetric.cardiovascular:
            _companionMessage = "Heart rate is stable at 66%. Keep up the calm breathing, Commander! ❤️";
            break;
          case HealthMetric.activity:
            _companionMessage = "Daily activity at 88%! Excellent physical stamina today, Commander! 🏃";
            break;
        }
      }
    });
  }

  void _dismissActiveCard() {
    if (_selectedMetric != null) {
      setState(() {
        _selectedMetric = null;
        _companionMessage = _defaultMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissActiveCard,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Deep Space
            Container(color: Colors.black),

            // Earth Horizon at the lower section
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
                    color: const Color(0x66000000), // rgba(0, 0, 0, 0.4)
                  ),
                ],
              ),
            ),

            // Main Layout Content
            SafeArea(
              child: Column(
                children: [
                  // 1. Top Header Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        // Circular Commander Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/commander_avatar.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Greeting & Health Subtitle
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning, Commander',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Here's your health status for today.",
                              style: TextStyle(
                                color: Color(0xCCFFFFFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Interactive Center Visual Area (Astronaut + Hotspots + Companion)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;

                        // Coordinate anchors for the 3 vitals pins
                        // 1. Radiation (Upper Left Shoulder)
                        final radDot = Offset(w * 0.14, h * 0.17);
                        final radBadge = Offset(w * 0.30, h * 0.11);

                        // 2. Cardiovascular (Chest / Heart)
                        final cardioDot = Offset(w * 0.58, h * 0.30);
                        final cardioBadge = Offset(w * 0.72, h * 0.27);

                        // 3. Activity (Left Thigh)
                        final actDot = Offset(w * 0.38, h * 0.47);
                        final actBadge = Offset(w * 0.24, h * 0.51);

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            // Astronaut Standing in Center
                            Align(
                              alignment: const Alignment(0, -0.05),
                              child: SizedBox(
                                width: w * 0.88,
                                height: h * 0.82,
                                child: Image.asset(
                                  'assets/images/astronaut.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Conditional Connector Lines Painter (only active metric draws)
                            CustomPaint(
                              size: Size(w, h),
                              painter: _CalloutLinesPainter(
                                selectedMetric: _selectedMetric,
                                radiationDot: radDot,
                                radiationBadge: radBadge,
                                cardioDot: cardioDot,
                                cardioBadge: cardioBadge,
                                activityDot: actDot,
                                activityBadge: actBadge,
                              ),
                            ),

                            // 1. Hotspot: Radiation (Clickable 44x44 touch target)
                            Positioned(
                              left: radDot.dx - 22,
                              top: radDot.dy - 22,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _toggleMetric(HealthMetric.radiation),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(
                                    child: _buildGlowingDot(
                                      color: const Color(0xFFD6C669),
                                      isActive: _selectedMetric == HealthMetric.radiation,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Callout Badge 1: Radiation (Animated on tap)
                            Positioned(
                              left: radBadge.dx,
                              top: radBadge.dy - 17,
                              child: AnimatedScale(
                                scale: _selectedMetric == HealthMetric.radiation ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                alignment: Alignment.bottomLeft,
                                child: AnimatedOpacity(
                                  opacity: _selectedMetric == HealthMetric.radiation ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: _selectedMetric != HealthMetric.radiation,
                                    child: _buildCalloutPill(
                                      backgroundColor: const Color(0xCCD6C669),
                                      icon: const _TrefoilRadiationIcon(size: 18),
                                      label: 'radiation',
                                      value: '80%',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 2. Hotspot: Cardiovascular (Clickable 44x44 touch target)
                            Positioned(
                              left: cardioDot.dx - 22,
                              top: cardioDot.dy - 22,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _toggleMetric(HealthMetric.cardiovascular),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(
                                    child: _buildGlowingDot(
                                      color: const Color(0xFFE55353),
                                      isActive: _selectedMetric == HealthMetric.cardiovascular,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Callout Badge 2: Cardiovascular (Animated on tap)
                            Positioned(
                              left: cardioBadge.dx,
                              top: cardioBadge.dy - 17,
                              child: AnimatedScale(
                                scale: _selectedMetric == HealthMetric.cardiovascular ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                alignment: Alignment.bottomLeft,
                                child: AnimatedOpacity(
                                  opacity: _selectedMetric == HealthMetric.cardiovascular ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: _selectedMetric != HealthMetric.cardiovascular,
                                    child: _buildCalloutPill(
                                      backgroundColor: const Color(0x990D415B),
                                      icon: const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                                      label: 'cardiovascular',
                                      value: '66%',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 3. Hotspot: Activity (Clickable 44x44 touch target)
                            Positioned(
                              left: actDot.dx - 22,
                              top: actDot.dy - 22,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _toggleMetric(HealthMetric.activity),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Center(
                                    child: _buildGlowingDot(
                                      color: const Color(0xFF43C566),
                                      isActive: _selectedMetric == HealthMetric.activity,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Callout Badge 3: Activity (Animated on tap)
                            Positioned(
                              left: actBadge.dx - 100,
                              top: actBadge.dy - 17,
                              child: AnimatedScale(
                                scale: _selectedMetric == HealthMetric.activity ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                alignment: Alignment.topRight,
                                child: AnimatedOpacity(
                                  opacity: _selectedMetric == HealthMetric.activity ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: _selectedMetric != HealthMetric.activity,
                                    child: _buildCalloutPill(
                                      backgroundColor: const Color(0xFF125D79),
                                      icon: const Icon(Icons.directions_run, color: Colors.white, size: 16),
                                      label: 'Activity',
                                      value: '88%',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // AstroPou Companion & Speech Bubble (Lower Right)
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Speech Bubble with smooth AnimatedSwitcher
                                  Container(
                                    width: 178,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xD9B2B3B4), // #b2b3b4 from Figma
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      switchInCurve: Curves.easeIn,
                                      switchOutCurve: Curves.easeOut,
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                      child: Text(
                                        _companionMessage,
                                        key: ValueKey<String>(_companionMessage),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Interactive Animated AstroPou Character
                                  GestureDetector(
                                    key: const Key('astropou_companion'),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _onAstroPouTapped,
                                    child: AnimatedBuilder(
                                      animation: Listenable.merge([_idleController, _reactionController]),
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(0, _floatAnimation.value + _hopAnimation.value),
                                          child: Transform.scale(
                                            scale: _breatheAnimation.value,
                                            alignment: Alignment.bottomCenter,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 95,
                                        height: 95,
                                        child: Image.asset(
                                          'assets/images/astropou.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 3. Bottom Mission Status Card
                  _buildMissionStatusCard(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Glowing Hotspot Dot with Active State Indicator
  static Widget _buildGlowingDot({
    required Color color,
    bool isActive = false,
    double size = 18,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: Colors.white, width: 2.0) : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isActive ? 0.9 : 0.6),
            blurRadius: isActive ? 14 : 10,
            spreadRadius: isActive ? 5 : 3,
          ),
        ],
      ),
    );
  }

  // Helper: Callout Badge Pill
  static Widget _buildCalloutPill({
    required Color backgroundColor,
    required Widget icon,
    required String label,
    required String value,
  }) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: Mission Status Bottom Card
  static Widget _buildMissionStatusCard() {
    return Container(
      height: 62,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0x35FFFFFF), // rgba(255, 255, 255, 0.21)
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF2F5A89), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.rocket_launch_outlined,
            color: Color(0xFF6B9AC4),
            size: 26,
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mission Day 99',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ISS Mission . Health Monitoring',
                style: TextStyle(
                  color: Color(0xCCFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF43C566),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x9943C566),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Normal',
                style: TextStyle(
                  color: Color(0xFF43C566),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Connector Lines Painter (renders line ONLY for selected metric)
class _CalloutLinesPainter extends CustomPainter {
  final HealthMetric? selectedMetric;
  final Offset radiationDot;
  final Offset radiationBadge;
  final Offset cardioDot;
  final Offset cardioBadge;
  final Offset activityDot;
  final Offset activityBadge;

  _CalloutLinesPainter({
    required this.selectedMetric,
    required this.radiationDot,
    required this.radiationBadge,
    required this.cardioDot,
    required this.cardioBadge,
    required this.activityDot,
    required this.activityBadge,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedMetric == HealthMetric.radiation) {
      final radPaint = Paint()
        ..color = const Color(0xFFD6C669)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(radiationDot, radiationBadge, radPaint);
    } else if (selectedMetric == HealthMetric.cardiovascular) {
      final cardioPaint = Paint()
        ..color = const Color(0xFFE55353)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(cardioDot, cardioBadge, cardioPaint);
    } else if (selectedMetric == HealthMetric.activity) {
      final actPaint = Paint()
        ..color = const Color(0xFF43C566)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(activityDot, activityBadge, actPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CalloutLinesPainter oldDelegate) {
    return oldDelegate.selectedMetric != selectedMetric;
  }
}

// Custom Trefoil Radiation Symbol Painter
class _TrefoilRadiationIcon extends StatelessWidget {
  final double size;

  const _TrefoilRadiationIcon({
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrefoilPainter(),
    );
  }
}

class _TrefoilPainter extends CustomPainter {
  static const Color _color = Color(0xFF7A6000);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    // Center circle
    final centerRadius = size.width * 0.16;
    canvas.drawCircle(center, centerRadius, paint);

    // 3 blades
    final rIn = size.width * 0.22;
    final rOut = size.width * 0.46;
    const bladeAngle = 60 * 3.1415926535 / 180;

    for (int i = 0; i < 3; i++) {
      final startAngle = (-90 + i * 120 - 30) * 3.1415926535 / 180;
      final path = Path();
      path.arcTo(
        Rect.fromCircle(center: center, radius: rOut),
        startAngle,
        bladeAngle,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: rIn),
        startAngle + bladeAngle,
        -bladeAngle,
        false,
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
