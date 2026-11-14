import 'package:flutter/material.dart';

class MessageItem {
  final String tag;
  final IconData tagIcon;
  final String timeAgo;
  final String? title;
  final String body;
  final Color primaryColor;
  final Color tagBgColor;
  final Color tagTextColor;
  final Color startBgColor;
  final Color endBgColor;
  final Widget leadingIllustration;

  const MessageItem({
    required this.tag,
    required this.tagIcon,
    required this.timeAgo,
    this.title,
    required this.body,
    required this.primaryColor,
    required this.tagBgColor,
    required this.tagTextColor,
    required this.startBgColor,
    required this.endBgColor,
    required this.leadingIllustration,
  });
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final messages = [
      // 1. Daily Motivation (Blue/Sky Theme)
      MessageItem(
        tag: 'Daily Motivation',
        tagIcon: Icons.star_rounded,
        timeAgo: '2 min ago',
        title: 'Your health looks good! 🚀',
        body: "Let's keep your vitals stable and stay mission-ready.",
        primaryColor: const Color(0xFF38BDF8),
        tagBgColor: const Color(0xFF1E2F4D),
        tagTextColor: const Color(0xFFE2E8F0),
        startBgColor: const Color(0xE60B1B36),
        endBgColor: const Color(0xE60B172D),
        leadingIllustration: _buildSparkleAvatar(
          sparkleColor: const Color(0xFFFCD34D),
        ),
      ),

      // 2. Health Reminder (Purple Theme)
      MessageItem(
        tag: 'Health Reminder',
        tagIcon: Icons.notifications_active_rounded,
        timeAgo: '1 h ago',
        title: 'Time for some hydration! 💧',
        body: "Don't forget to drink water and stay energized in space.",
        primaryColor: const Color(0xFFA855F7),
        tagBgColor: const Color(0xFF2A174D),
        tagTextColor: const Color(0xFFE9D5FF),
        startBgColor: const Color(0xE6170E33),
        endBgColor: const Color(0xE6120A2B),
        leadingIllustration: _buildSparkleAvatar(
          sparkleColor: const Color(0xFFFCD34D),
        ),
      ),

      // 3. Message from Earth (Teal/Emerald Theme)
      MessageItem(
        tag: 'Message from Earth',
        tagIcon: Icons.groups_rounded,
        timeAgo: '3 h ago',
        title: null, // quote format
        body: '“Hey! We\'re all thinking of you. Stay strong, Commander. We can\'t wait to see you again!” ❤️❤️',
        primaryColor: const Color(0xFF2DD4BF),
        tagBgColor: const Color(0xFF103E42),
        tagTextColor: const Color(0xFF99F6E4),
        startBgColor: const Color(0xE607242C),
        endBgColor: const Color(0xE6051C22),
        leadingIllustration: _buildEarthMessageGraphic(),
      ),

      // 4. Health Alert (Rose/Red Theme)
      MessageItem(
        tag: 'Health Alert',
        tagIcon: Icons.favorite_rounded,
        timeAgo: '5 h ago',
        title: 'I noticed a change in your sleep pattern.',
        body: "Let's review your recent sleep data and make time for recovery.",
        primaryColor: const Color(0xFFF43F5E),
        tagBgColor: const Color(0xFF3F1522),
        tagTextColor: const Color(0xFFFECDD3),
        startBgColor: const Color(0xE6260B14),
        endBgColor: const Color(0xE61E0810),
        leadingIllustration: _buildSparkleAvatar(
          sparkleColor: const Color(0xFFF43F5E),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Earth Horizon at bottom
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
                  color: const Color(0xA6000000), // 65% dark space overlay
                ),
              ],
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Top Header: Back Arrow, Title & Subtitle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Messages & Reminders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Updates, reminders, and messages from Earth.',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section - Cards Feed
                  for (final item in messages) ...[
                    _buildMessageCard(context, item),
                    const SizedBox(height: 18),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder for each card with glow, gradient, and layout
  static Widget _buildMessageCard(BuildContext context, MessageItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.primaryColor.withAlpha(200),
          width: 1.2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.startBgColor,
            item.endBgColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: item.primaryColor.withAlpha(70),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 0),
          ),
          const BoxShadow(
            color: Color(0x80000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Friendly tap feedback
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Character / Message illustration
                SizedBox(
                  width: 60,
                  height: 60,
                  child: item.leadingIllustration,
                ),

                const SizedBox(width: 12),

                // Middle: Tag + Time + Title + Body
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag Pill + Timestamp Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.tagBgColor,
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: item.primaryColor.withAlpha(100),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.tagIcon,
                                  color: item.primaryColor,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.tag,
                                  style: TextStyle(
                                    color: item.tagTextColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.timeAgo,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      if (item.title != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],

                      const SizedBox(height: 4),

                      Text(
                        item.body,
                        style: TextStyle(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 12,
                          fontWeight: item.title == null
                              ? FontWeight.w500
                              : FontWeight.w400,
                          height: 1.35,
                          fontStyle: item.title == null
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Right: Chevron Icon
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Illustration: AstroPou with 3 sparkles on top right
  static Widget _buildSparkleAvatar({required Color sparkleColor}) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Pou avatar
        Image.asset(
          'assets/images/astropou.png',
          width: 52,
          height: 52,
          fit: BoxFit.contain,
        ),

        // 3 Sparkles Top Right
        Positioned(
          top: -2,
          right: -2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Transform.rotate(
                angle: 0.78, // 45 deg
                child: Container(
                  width: 4,
                  height: 9,
                  decoration: BoxDecoration(
                    color: sparkleColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Transform.rotate(
                angle: 0.2, // 12 deg
                child: Container(
                  width: 5,
                  height: 12,
                  decoration: BoxDecoration(
                    color: sparkleColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Transform.rotate(
                angle: -0.2, // -12 deg
                child: Container(
                  width: 4,
                  height: 9,
                  decoration: BoxDecoration(
                    color: sparkleColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Illustration: Message from Earth postcard graphic
  static Widget _buildEarthMessageGraphic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Slanted Postcard / Envelope Background
        Transform.rotate(
          angle: -0.15,
          child: Container(
            width: 44,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF2DD4BF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        // Foreground Smartphone with Heart
        Transform.rotate(
          angle: 0.1,
          child: Container(
            width: 24,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_rounded,
                color: Color(0xFFF43F5E),
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
