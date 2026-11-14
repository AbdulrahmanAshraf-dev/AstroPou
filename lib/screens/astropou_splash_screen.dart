import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class AstroPouSplashScreen extends StatefulWidget {
  const AstroPouSplashScreen({super.key});

  @override
  State<AstroPouSplashScreen> createState() => _AstroPouSplashScreenState();
}

class _AstroPouSplashScreenState extends State<AstroPouSplashScreen> {
  static const List<String> _messages = [
    "Hey, space buddy! Ready for an amazing mission together? 🚀",
    "Space missions are exciting, but your health comes first! 💙",
    "I'll help you keep an eye on your health throughout the journey.",
    "Remember to check in, stay active, and take care of yourself!",
    "Even among the stars, you're never alone. We're in this together! 🌍",
    "Ready to explore? Let's make this mission amazing!",
  ];

  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),

          Positioned(
            left: -20,
            right: -20,
            bottom: -50,
            height: screenSize.height * 0.62,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/earth.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                Container(
                  color: const Color(0xA6000000),
                ),
              ],
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.05),
            child: SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(
                'assets/images/astropou.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          Align(
            alignment: const Alignment(-0.60, -0.25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: const BoxConstraints(
                minWidth: 160,
                maxWidth: 200,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xB3FFFFFF), // rgba(255, 255, 255, 0.7)
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Text(
                  _messages[_currentMessageIndex],
                  key: ValueKey<int>(_currentMessageIndex),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),

          // Explore Button at Bottom
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 340),
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0167C9),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
