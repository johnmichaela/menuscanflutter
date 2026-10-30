import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScallopedBadgeClipper extends CustomClipper<Path> {
  final int points;
  final double pointDepth;

  ScallopedBadgeClipper({this.points = 6, this.pointDepth = 0.1});

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * (1 - pointDepth);
    final angleStep = (2 * math.pi) / points;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - math.pi / 2;
      
      // Outer point
      final outerX = center.dx + radius * math.cos(angle);
      final outerY = center.dy + radius * math.sin(angle);
      
      // Inner point (halfway between outer points)
      final innerAngle = angle + angleStep / 2;
      final innerX = center.dx + innerRadius * math.cos(innerAngle);
      final innerY = center.dy + innerRadius * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      // We use quadratic bezier to make the scallops smooth and rounded
      final controlX = center.dx + (innerRadius + radius) / 2 * 1.1 * math.cos(innerAngle);
      final controlY = center.dy + (innerRadius + radius) / 2 * 1.1 * math.sin(innerAngle);
      
      path.quadraticBezierTo(controlX, controlY, innerX, innerY);
      
      // Connect back to next outer point
      final nextOuterAngle = (i + 1) * angleStep - math.pi / 2;
      final nextOuterX = center.dx + radius * math.cos(nextOuterAngle);
      final nextOuterY = center.dy + radius * math.sin(nextOuterAngle);
      
      final nextControlX = center.dx + (innerRadius + radius) / 2 * 1.1 * math.cos(innerAngle);
      final nextControlY = center.dy + (innerRadius + radius) / 2 * 1.1 * math.sin(innerAngle);
      
      if (i == points - 1) {
        path.quadraticBezierTo(nextControlX, nextControlY, nextOuterX, nextOuterY);
      } else {
        path.quadraticBezierTo(nextControlX, nextControlY, nextOuterX, nextOuterY);
      }
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ScallopedTierBadge extends StatelessWidget {
  final String tierLabel; // "vip", "vvp", or "free"
  final double size;

  const ScallopedTierBadge({
    super.key,
    required this.tierLabel,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getBadgeConfig(tierLabel);

    return ClipPath(
      clipper: ScallopedBadgeClipper(points: 9, pointDepth: 0.22),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: config.gradientColors,
          ),
           shape: BoxShape.circle, // The shadow shape (circle is fine, the clip hides the overlap)
        boxShadow: [
          BoxShadow(
            color: config.gradientColors.last.withOpacity(0.45), // Uses the dark tier color for a glowing shadow
            blurRadius: size * 0.15, 
            spreadRadius: size * 0.02,
            offset: Offset(0, size * 0.08), // Push shadow downwards
          ),
        ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Crown / Icon
            Icon(
              config.icon,
              color: config.contentColor,
              size: size * 0.65,
            ),
            // SizedBox(height: size * 0.05),
            // // Text (VIP / VVP / FREE)
            // Text(
            //   config.label,
            //   style: TextStyle(
            //     color: config.contentColor,
            //     fontSize: size * 0.18,
            //     fontWeight: FontWeight.w900,
            //     letterSpacing: 1.2,
            //   ),
            // ),
            // SizedBox(height: size * 0.05),
            // // Stars at the bottom
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(
            //     4,
            //     (index) => Padding(
            //       padding: EdgeInsets.symmetric(horizontal: size * 0.01),
            //       child: Icon(
            //         Icons.star_rounded,
            //         color: config.contentColor.withOpacity(0.7),
            //         size: size * 0.08,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _BadgeConfig _getBadgeConfig(String tier) {
    switch (tier.toLowerCase()) {
      case 'vip':
        // Gold/Bronze tier (Left image)
        return _BadgeConfig(
          label: 'VIP',
          icon: Icons.check, // Crown-like
          gradientColors: [
            // const Color(0xFFFFD54F), // Light gold
            // const Color(0xFFFF8F00), // Dark amber
              const Color(0xFF64B5F6), // Light blue (was 0xFFFFD54F)
              const Color(0xFF1565C0), 
          ],
           contentColor: const Color(0xFFE3F2FD), // Very light icy blue (was 0xFFFFF3E0)
          // contentColor: const Color(0xFFFFF3E0), // Very light peach/white
        );
      case 'vvp':
        // Rose-gold/Copper tier (Right image)
        return _BadgeConfig(
          label: 'VVP',
          icon: Icons.diamond_rounded, // Or Icons.workspace_premium_rounded
          gradientColors: [
             const Color(0xFFFFD54F), // Light gold
            const Color(0xFFFF8F00), // Dark amber
            // const Color(0xFFFFA07A), // Light salmon
            // const Color(0xFFD35400), // Dark rust
          ],
          contentColor: const Color(0xFFFFE0B2), // Light orange
        );
      case 'free':
      default:
        // Silver/Grey tier (Middle image)
        return _BadgeConfig(
          label: 'FREE',
          icon: Icons.person_rounded,
          gradientColors: [
            const Color(0xFFE0E0E0), // Light silver
            const Color(0xFF9E9E9E), // Dark grey
          ],
          contentColor: const Color(0xFFFFFFFF), // White
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final Color contentColor;

  _BadgeConfig({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.contentColor,
  });
}

class _BadgeConfigs {
  final String label;
  final Widget icon;
  final List<Color> gradientColors;
  final Color contentColor;

  _BadgeConfigs({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.contentColor,
  });
}
class ScallopedTierBadges extends StatelessWidget {
  final String tierLabel; // "vip", "vvp", or "free"
  final double size;

  const ScallopedTierBadges({
    super.key,
    required this.tierLabel,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getBadgeConfig(tierLabel);

    return ClipPath(
      clipper: ScallopedBadgeClipper(points: 14, pointDepth: 0.22),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: config.gradientColors,
          ),
           shape: BoxShape.circle, // The shadow shape (circle is fine, the clip hides the overlap)
        boxShadow: [
          BoxShadow(
            color: config.gradientColors.last.withOpacity(0.45), // Uses the dark tier color for a glowing shadow
            blurRadius: size * 0.15, 
            spreadRadius: size * 0.02,
            offset: Offset(0, size * 0.08), // Push shadow downwards
          ),
        ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Crown / Icon
            config.icon,
          //  FaIcon(
          //     config.icon,
          //     color: config.contentColor,
          //     size: size * 0.65,
          //   ),
            SizedBox(height: size * 0.05),
            // Text (VIP / VVP / FREE)
            Text(
              config.label,
              style: TextStyle(
                color: config.contentColor,
                fontSize: size * 0.13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: size * 0.05),
            // Stars at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: size * 0.01),
                  child: Icon(
                    Icons.star_rounded,
                    color: config.contentColor.withOpacity(0.7),
                    size: size * 0.08,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _BadgeConfigs _getBadgeConfig(String tier) {
    switch (tier.toLowerCase()) {
      case 'vip':
        // Gold/Bronze tier (Left image)
        return _BadgeConfigs(
          label: 'VIP',
          icon: FaIcon(FontAwesomeIcons.crown,size: size * 0.25,), // Crown-like
          gradientColors: [
            // const Color(0xFFFFD54F), // Light gold
            // const Color(0xFFFF8F00), // Dark amber
              const Color(0xFF64B5F6), // Light blue (was 0xFFFFD54F)
              const Color(0xFF1565C0), 
          ],
           contentColor: const Color(0xFFE3F2FD), // Very light icy blue (was 0xFFFFF3E0)
          // contentColor: const Color(0xFFFFF3E0), // Very light peach/white
        );
      case 'vvp':
        // Rose-gold/Copper tier (Right image)
        return _BadgeConfigs(
          label: 'VVP',
          icon: FaIcon(FontAwesomeIcons.gem,size: size * 0.25,), // Or Icons.workspace_premium_rounded
          gradientColors: [
             const Color(0xFFFFD54F), // Light gold
            const Color(0xFFFF8F00), // Dark amber
            // const Color(0xFFFFA07A), // Light salmon
            // const Color(0xFFD35400), // Dark rust
          ],
          contentColor: const Color(0xFFFFE0B2), // Light orange
        );
      case 'free':
      default:
        // Silver/Grey tier (Middle image)
        return _BadgeConfigs(
          label: 'ADS',
          icon: FaIcon(FontAwesomeIcons.ban,size: size * 0.25,),
          gradientColors: [
            const Color(0xFFE0E0E0), // Light silver
            const Color(0xFF9E9E9E), // Dark grey
          ],
          contentColor: const Color(0xFFFFFFFF), // White
        );
    }
  }
}