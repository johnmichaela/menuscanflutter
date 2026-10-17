// import 'dart:math' as math;
// import 'package:flutter/material.dart';

// class WaterDropLoader extends StatefulWidget {
//   final double size;
//   final Color? dropColor;
//   final Color? iconColor;
//   final Duration duration;

//   const WaterDropLoader({
//     super.key,
//     this.size = 140,
//     this.dropColor,
//     this.iconColor,
//     this.duration = const Duration(milliseconds: 2600),
//   });

//   @override
//   State<WaterDropLoader> createState() => _WaterDropLoaderState();
// }

// class _WaterDropLoaderState extends State<WaterDropLoader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;

//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: widget.duration)
//       ..repeat();
//   }

//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final Color drop = widget.dropColor ?? theme.primaryColor;
//     final Color icon = widget.iconColor ?? theme.colorScheme.onPrimary;

//     return SizedBox(
//       width: widget.size,
//       height: widget.size,
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (context, _) {
//           final t = _c.value;                    // 0..1

//           // ---- 3 phases ----
//           // 0.00 → 0.50  : drops fall
//           // 0.50 → 0.75  : cart appears + pulses
//           // 0.75 → 1.00  : cart morphs into product icon
//           final dropProgress = Curves.easeIn.transform(
//             (t / 0.5).clamp(0.0, 1.0),
//           );
//           final cartProgress = Curves.elasticOut.transform(
//             ((t - 0.5) / 0.25).clamp(0.0, 1.0),
//           );
//           final morphProgress = Curves.easeInOut.transform(
//             ((t - 0.75) / 0.25).clamp(0.0, 1.0),
//           );

//           // Which icon to show and how much to blend
//           final showCart = t < 0.75;
//           final iconData = showCart
//               ? Icons.shopping_cart_rounded
//               : Icons.inventory_2_rounded;

//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               // ---- Falling droplets (background layer) ----
//               ..._buildDrops(drop, dropProgress),

//               // ---- Filled basin at the bottom ----
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   width: widget.size * 0.85,
//                   height: widget.size * 0.18 * dropProgress,
//                   decoration: BoxDecoration(
//                     color: drop.withOpacity(0.18),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                 ),
//               ),

//               // ---- Cart / Product icon (foreground layer) ----
//               if (cartProgress > 0)
//                 Transform.scale(
//                   scale: cartProgress,
//                   child: Opacity(
//                     opacity: cartProgress.clamp(0.0, 1.0),
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 220),
//                       transitionBuilder: (child, anim) => ScaleTransition(
//                         scale: anim,
//                         child: FadeTransition(opacity: anim, child: child),
//                       ),
//                       child: Icon(
//                         iconData,
//                         key: ValueKey(iconData),
//                         size: widget.size * 0.34,
//                         color: Color.lerp(
//                           icon,
//                           icon,
//                           morphProgress, // keep same color, but you can blend
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   /// Generates 3 droplets that fall at slightly different times.
//   List<Widget> _buildDrops(Color color, double progress) {
//     final drops = <Widget>[];
//     // Each drop has its own delay offset so they don't fall in sync.
//     const offsets = [0.0, 0.18, 0.36];

//     for (var i = 0; i < offsets.length; i++) {
//       final local = ((progress - offsets[i]) / (1 - offsets[i]))
//           .clamp(0.0, 1.0);
//       if (local <= 0) continue;

//       // Drop travels from top to bottom of the container
//       final top = local * (widget.size * 0.75);
//       // Fade in fast, fade out at the bottom
//       final opacity = local < 0.1
//           ? local * 10
//           : (1 - local).clamp(0.0, 1.0);

//       drops.add(
//         Positioned(
//           top: top,
//           child: Opacity(
//             opacity: opacity,
//             child: Container(
//               width: widget.size * 0.05,
//               height: widget.size * 0.08,
//               decoration: BoxDecoration(
//                 color: color,
//                 // teardrop shape
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                   bottomLeft: Radius.circular(40),
//                   bottomRight: Radius.circular(40),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return drops;
//   }
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A professional staged loader:
///   1) Teardrops fall from the top (staggered)
///   2) A basin "fills" with a liquid surface that gently wobbles
///   3) A cart icon springs in with a tiny overshoot
///   4) The cart morphs into a product icon (scale + fade cross-fade)
///
/// Respects `MediaQuery.disableAnimations` (accessibility) by rendering the
/// final frame statically.
class WaterDropLoader extends StatefulWidget {
  /// Overall square footprint of the animation.
  final double size;

  /// Colour used for drops and the liquid basin. Defaults to theme primary.
  final Color? dropColor;

  /// Colour used for the foreground icon. Defaults to onPrimary.
  final Color? iconColor;

  /// Full loop duration. All phases are fractions of this.
  final Duration duration;

  /// Set to false to run a single cycle instead of looping.
  final bool loop;

  /// Called once the cycle finishes (only meaningful when [loop] is false).
  final VoidCallback? onCompleted;

  const WaterDropLoader({
    super.key,
    this.size = 160,
    this.dropColor,
    this.iconColor,
    this.duration = const Duration(milliseconds: 2400),
    this.loop = true,
    this.onCompleted,
  });

  @override
  State<WaterDropLoader> createState() => _WaterDropLoaderState();
}

class _WaterDropLoaderState extends State<WaterDropLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  // Phase boundaries (fractions of total duration).
  static const double _pDrops    = 0.50; // 0.00 → 0.50 drops fall
  static const double _pCartIn   = 0.25; // 0.50 → 0.75 cart springs in
  static const double _pMorph    = 0.25; // 0.75 → 1.00 cart → product

  // Drop schedule: three drops at staggered offsets + slightly different sizes.
  static const List<double> _dropDelays = [0.00, 0.16, 0.32];
  static const List<double> _dropScales = [1.00, 0.85, 0.70];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    if (widget.loop) {
      _c.repeat();
    } else {
      _c.forward().whenComplete(() => widget.onCompleted?.call());
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drop = widget.dropColor ?? theme.primaryColor;
    final icon = widget.iconColor ?? theme.colorScheme.onPrimary;

    // Accessibility: skip animation when the OS asks for reduced motion.
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      return _StaticFinalFrame(
        size: widget.size,
        drop: drop,
        icon: icon,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;

          // ---------- Phase progress ----------
          final dropT = ((t) / _pDrops).clamp(0.0, 1.0);
          final cartT = ((t - _pDrops) / _pCartIn).clamp(0.0, 1.0);
          final morphT = ((t - _pDrops - _pCartIn) / _pMorph).clamp(0.0, 1.0);

          // ---------- Curves ----------
          final dropEase = Curves.easeInCubic.transform(dropT);
          final cartScale = Curves.elasticOut.transform(cartT);
          final cartFade = Curves.easeOut.transform((cartT * 1.6).clamp(0.0, 1.0));
          final morphEase = Curves.easeInOutCubic.transform(morphT);
          final wobble = math.sin(morphEase * math.pi * 2) *
              (1 - morphEase) *      // damp towards end
              0.02;                  // amplitude

          // ---------- Layout anchors ----------
          final size = widget.size;
          final basinWidth = size * 0.72;
          final basinHeight = size * 0.16;
          final basinBottom = size * 0.08;

          // Liquid height grows only during drop phase.
          final liquidFill = dropEase;
          final liquidHeight = basinHeight * liquidFill;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // ---- 1) Falling droplets ----
              for (int i = 0; i < _dropDelays.length; i++)
                _buildDrop(
                  color: drop,
                  globalDropT: dropT,
                  delay: _dropDelays[i],
                  scale: _dropScales[i],
                  size: size,
                  basinTopY: size - basinBottom - basinHeight,
                ),

              // ---- 2) Liquid basin (bottom) ----
              Positioned(
                bottom: basinBottom,
                child: Transform.translate(
                  offset: Offset(0, wobble * size),
                  child: _Basin(
                    width: basinWidth,
                    height: basinHeight,
                    liquidHeight: liquidHeight,
                    color: drop,
                  ),
                ),
              ),

              // ---- 3) Icon (cart → product) ----
              if (cartT > 0)
                Opacity(
                  opacity: cartFade,
                  child: Transform.scale(
                    scale: cartScale * (1 - 0.08 * morphEase),
                    child: _MorphIcon(
                      size: size * 0.34,
                      color: icon,
                      morph: morphEase,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrop({
    required Color color,
    required double globalDropT,
    required double delay,
    required double scale,
    required double size,
    required double basinTopY,
  }) {
    // Local progress for this drop (0 before its delay).
    final local = ((globalDropT - delay) / (1 - delay)).clamp(0.0, 1.0);
    if (local <= 0) return const SizedBox.shrink();

    // Travel from top (y = 0) down to the basin top.
    final y = Curves.easeInCubic.transform(local) * basinTopY;

    // Fade-in at the very start, fade-out as it merges into liquid.
    final fade = local < 0.08
        ? local / 0.08
        : (1.0 - ((local - 0.85) / 0.15).clamp(0.0, 1.0));

    final w = size * 0.055 * scale;
    final h = size * 0.075 * scale;

    return Positioned(
      top: y,
      child: Opacity(
        opacity: fade.clamp(0.0, 1.0),
        child: CustomPaint(
          size: Size(w, h),
          painter: _TeardropPainter(color: color),
        ),
      ),
    );
  }
}

// ============================================================================
// BASIN — rounded container with a filled liquid surface
// ============================================================================

class _Basin extends StatelessWidget {
  final double width;
  final double height;
  final double liquidHeight;
  final Color color;

  const _Basin({
    required this.width,
    required this.height,
    required this.liquidHeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(height);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Outline of the basin
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.all(radius),
              border: Border.all(
                color: color.withOpacity(0.18),
                width: 1.2,
              ),
            ),
          ),
          // Liquid fill
          ClipRRect(
            borderRadius: BorderRadius.all(radius),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: width,
                height: liquidHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.35),
                      color.withOpacity(0.65),
                    ],
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

// ============================================================================
// MORPHING ICON — cart cross-fades into product
// ============================================================================

class _MorphIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double morph; // 0 = cart, 1 = product

  const _MorphIcon({
    required this.size,
    required this.color,
    required this.morph,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cart (fades out as morph → 1)
          Opacity(
            opacity: (1 - morph).clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: morph * 0.35,
              child: Icon(
                Icons.shopping_cart_rounded,
                size: size,
                color: color,
              ),
            ),
          ),
          // Product (fades in as morph → 1)
          Opacity(
            opacity: morph.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: (1 - morph) * -0.35,
              child: Icon(
                Icons.inventory_2_rounded,
                size: size,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TEARDROP PAINTER — a proper teardrop silhouette
// ============================================================================

class _TeardropPainter extends CustomPainter {
  final Color color;
  _TeardropPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    final w = size.width;
    final h = size.height;

    // Teardrop: pointed top, round bottom.
    p.moveTo(w / 2, 0);
    p.cubicTo(
      w, h * 0.35,
      w * 0.82, h,
      w / 2, h,
    );
    p.cubicTo(
      w * 0.18, h,
      0, h * 0.35,
      w / 2, 0,
    );
    p.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.55),
          color,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant _TeardropPainter old) =>
      old.color != color;
}

// ============================================================================
// STATIC FINAL FRAME — used when reduce-motion is on
// ============================================================================

class _StaticFinalFrame extends StatelessWidget {
  final double size;
  final Color drop;
  final Color icon;

  const _StaticFinalFrame({
    required this.size,
    required this.drop,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: size * 0.08,
            child: Container(
              width: size * 0.72,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: drop.withOpacity(0.18),
                borderRadius: BorderRadius.circular(size * 0.16),
              ),
            ),
          ),
          Icon(
            Icons.inventory_2_rounded,
            size: size * 0.34,
            color: icon,
          ),
        ],
      ),
    );
  }
}



/// A loader where a snake hops from hill to hill, leaving a fading trail.
///
/// Visual:
///   • A rolling sinusoidal hill (drawn with a Path)
///   • A small snake (segments trail the head) that hops between crests
///   • Each landing squashes + stretches the snake for weight
///   • A soft "shadow" under the snake grows/shrinks with hop height
///   • A trail of dots fades behind
///
/// Respects `MediaQuery.disableAnimations`.
class SnakeHillLoader extends StatefulWidget {
  /// Overall footprint.
  final double width;
  final double height;

  /// Snake color. Defaults to `theme.primaryColor`.
  final Color? snakeColor;

  /// Hill outline color. Defaults to `theme.dividerColor`.
  final Color? hillColor;

  /// Full loop duration.
  final Duration duration;

  /// Loop forever (true) or run once (false).
  final bool loop;

  /// Called when a single cycle completes (only when [loop] is false).
  final VoidCallback? onCompleted;

  const SnakeHillLoader({
    super.key,
    this.width = 240,
    this.height = 120,
    this.snakeColor,
    this.hillColor,
    this.duration = const Duration(milliseconds: 2200),
    this.loop = true,
    this.onCompleted,
  });

  @override
  State<SnakeHillLoader> createState() => _SnakeHillLoaderState();
}

class _SnakeHillLoaderState extends State<SnakeHillLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  /// Number of hops per cycle (i.e. how many crests the snake crosses).
  static const int _hops = 4;

  /// Number of trail segments behind the head.
  static const int _segments = 5;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    if (widget.loop) {
      _c.repeat();
    } else {
      _c.forward().whenComplete(() => widget.onCompleted?.call());
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snake = widget.snakeColor ?? theme.primaryColor;
    final hill = widget.hillColor ??
        theme.dividerColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.6 : 1.0,
        );

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      return _StaticFrame(
        width: widget.width,
        height: widget.height,
        snake: snake,
        hill: hill,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;

          // ---- Hop timing ----
          // t goes 0..1 across the whole cycle. Multiply by _hops to get
          // the current hop index + local progress.
          final scaled = t * _hops;
          final hopIndex = scaled.floor();
          final hopT = scaled - hopIndex; // 0..1 local progress in this hop

          // ---- Hill geometry ----
          // We treat the hill as a sinusoid: y = A * sin(2π * x / L)
          // Number of half-waves = _hops so the snake lands on each crest.
          final w = widget.width;
          final h = widget.height;
          final groundY = h * 0.70;
          final amp = h * 0.20;

          // Snake x travels linearly across the whole width.
          final snakeX = t * w;

          // Crest positions are at x = w * (k + 0.5) / _hops for k=0.._hops-1.
          // Between crests, the snake is airborne (parabola).
          final segLen = w / _hops;
          final localX = snakeX - hopIndex * segLen; // 0..segLen
          final airT = (localX / segLen).clamp(0.0, 1.0);

          // Parabolic hop: peak at airT = 0.5, height = hopHeight
          final hopHeight = h * 0.22;
          final hopY = -4 * hopHeight * airT * (1 - airT);

          // Ground Y at snake X (sinusoid)
          final groundHere = groundY - amp * math.sin((snakeX / w) * math.pi * 2);

          // Final snake head position
          final headY = groundHere + hopY;

          // Squash & stretch on landing (last 20% of hop)
          final landT = ((airT - 0.80) / 0.20).clamp(0.0, 1.0);
          final squash = 1 - 0.18 * math.sin(landT * math.pi);
          final stretch = 1 + 0.18 * math.sin(landT * math.pi);

          return CustomPaint(
            painter: _SnakeHillPainter(
              hillColor: hill,
              snakeColor: snake,
              t: t,
              hopIndex: hopIndex,
              hopT: hopT,
              airT: airT,
              headX: snakeX,
              headY: headY,
              squash: squash,
              stretch: stretch,
              segments: _segments,
              hops: _hops,
              amp: amp,
              groundY: groundY,
              width: w,
              height: h,
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// PAINTER
// ============================================================================

class _SnakeHillPainter extends CustomPainter {
  final Color hillColor;
  final Color snakeColor;
  final double t;
  final int hopIndex;
  final double hopT;
  final double airT;
  final double headX;
  final double headY;
  final double squash;
  final double stretch;
  final int segments;
  final int hops;
  final double amp;
  final double groundY;
  final double width;
  final double height;

  _SnakeHillPainter({
    required this.hillColor,
    required this.snakeColor,
    required this.t,
    required this.hopIndex,
    required this.hopT,
    required this.airT,
    required this.headX,
    required this.headY,
    required this.squash,
    required this.stretch,
    required this.segments,
    required this.hops,
    required this.amp,
    required this.groundY,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintHill(canvas, size);
    _paintTrail(canvas, size);
    _paintShadow(canvas, size);
    _paintSnake(canvas, size);
  }

  // ---------- Hill ----------
  void _paintHill(Canvas canvas, Size size) {
    final path = Path();
    const steps = 120;
    for (int i = 0; i <= steps; i++) {
      final x = size.width * (i / steps);
      final y = groundY - amp * math.sin((x / size.width) * math.pi * 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Fill area under the hill with a soft tint.
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..color = hillColor.withOpacity(0.10)
        ..style = PaintingStyle.fill,
    );

    // Hill outline.
    canvas.drawPath(
      path,
      Paint()
        ..color = hillColor.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  // ---------- Trail ----------
  void _paintTrail(Canvas canvas, Size size) {
    // For each trail segment, compute where the snake head was [i] frames ago.
    const dt = 0.035; // seconds-ish in cycle fraction terms
    for (int i = segments; i >= 1; i--) {
      final back = i * dt;
      final tBack = (t - back);
      if (tBack <= 0) continue;

      final scaled = tBack * hops;
      final idx = scaled.floor();
      final segLen = size.width / hops;
      final localX = tBack * size.width - idx * segLen;
      final aT = (localX / segLen).clamp(0.0, 1.0);
      final hopY = -4 * (height * 0.22) * aT * (1 - aT);

      final x = tBack * size.width;
      final gY = groundY - amp * math.sin((x / size.width) * math.pi * 2);
      final y = gY + hopY;

      final fade = 1 - (i / (segments + 1));
      final r = size.width * 0.012 * fade + 1.5;
      final col = snakeColor.withOpacity(0.35 * fade);

      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = col
          ..style = PaintingStyle.fill,
      );
    }
  }

  // ---------- Shadow ----------
  void _paintShadow(Canvas canvas, Size size) {
    // Shadow under the snake: bigger when close to ground, smaller when high.
    final airFrac = airT; // 0 at crest edges, 1 at mid-air? actually 0..1
    // Distance from ground is hopY magnitude. Convert to 0..1.
    final hopY = -4 * (height * 0.22) * airT * (1 - airT);
    final height01 = (hopY.abs() / (height * 0.22)).clamp(0.0, 1.0);
    final shadowScale = 1 - height01 * 0.55;

    final groundHere =
        groundY - amp * math.sin((headX / size.width) * math.pi * 2);

    final rect = Rect.fromCenter(
      center: Offset(headX, groundHere + 4),
      width: size.width * 0.10 * shadowScale,
      height: size.width * 0.030 * shadowScale,
    );
    canvas.drawOval(
      rect,
      Paint()
        ..color = Colors.black.withOpacity(0.15 * shadowScale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  // ---------- Snake ----------
  void _paintSnake(Canvas canvas, Size size) {
    // Head
    final headRadius = size.width * 0.030;
    final headOffset = Offset(headX, headY);

    // Body: draw N circles behind the head along the hill top
    final segRadius = headRadius * 0.85;
    final dx = headRadius * 1.15;

    for (int i = segments; i >= 1; i--) {
      final x = headX - dx * i;
      if (x < 0) continue;

      // Where was the body when the head was at this x?
      // Use hill function directly so body hugs the terrain.
      final gY = groundY - amp * math.sin((x / size.width) * math.pi * 2);

      // Add a tiny sine wiggle so the body feels alive.
      final wiggle =
          math.sin((t * math.pi * 2 * 6) + i * 0.9) * size.width * 0.008;

      final fade = 1 - (i / (segments + 1));
      final r = segRadius * (0.55 + fade * 0.45);

      canvas.drawCircle(
        Offset(x, gY + wiggle),
        r,
        Paint()..color = snakeColor.withOpacity(0.35 + fade * 0.55),
      );
    }

    // Head — squash & stretch on landing.
    canvas.save();
    canvas.translate(headOffset.dx, headOffset.dy);
    canvas.scale(stretch, squash);
    canvas.drawCircle(
      Offset.zero,
      headRadius,
      Paint()..color = snakeColor,
    );
    // Eye
    canvas.drawCircle(
      Offset(headRadius * 0.35, -headRadius * 0.20),
      headRadius * 0.28,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(headRadius * 0.42, -headRadius * 0.18),
      headRadius * 0.14,
      Paint()..color = Colors.black87,
    );
    canvas.restore();

    // Tongue flick — only near landing for charm.
    if (airT < 0.15 || airT > 0.85) {
      final tongueEnd = Offset(
        headOffset.dx + headRadius * 1.6,
        headOffset.dy + math.sin(t * math.pi * 2 * 8) * 1.5,
      );
      canvas.drawLine(
        Offset(headOffset.dx + headRadius * 0.85, headOffset.dy),
        tongueEnd,
        Paint()
          ..color = Colors.redAccent.withOpacity(0.85)
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SnakeHillPainter old) => true;
}

// ============================================================================
// STATIC FRAME (reduce-motion)
// ============================================================================

class _StaticFrame extends StatelessWidget {
  final double width;
  final double height;
  final Color snake;
  final Color hill;

  const _StaticFrame({
    required this.width,
    required this.height,
    required this.snake,
    required this.hill,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StaticFramePainter(snake: snake, hill: hill),
      ),
    );
  }
}

class _StaticFramePainter extends CustomPainter {
  final Color snake;
  final Color hill;
  _StaticFramePainter({required this.snake, required this.hill});

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height * 0.70;
    final amp = size.height * 0.20;

    final path = Path();
    const steps = 120;
    for (int i = 0; i <= steps; i++) {
      final x = size.width * (i / steps);
      final y = groundY - amp * math.sin((x / size.width) * math.pi * 2);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = hill.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Snake head on a crest.
    final x = size.width * 0.625;
    final y = groundY - amp * math.sin((x / size.width) * math.pi * 2);
    canvas.drawCircle(Offset(x, y), size.width * 0.03,
        Paint()..color = snake);
  }

  @override
  bool shouldRepaint(covariant _StaticFramePainter old) => false;
}


/// A circular loader that cycles through a list of icons with a
/// flip + scale + fade transition, plus a soft rotating ring behind it.
///
/// Default cycle: cart → drink → food → event → chat → person → cart …
class IconSwapLoader extends StatefulWidget {
  /// Diameter of the loader.
  final double size;

  /// Icons to cycle through. Defaults to a Qopera-friendly set.
  final List<IconData> icons;

  /// Time each icon stays visible before swapping.
  final Duration interval;

  /// Foreground icon color. Defaults to `theme.primaryColor`.
  final Color? iconColor;

  /// Ring / halo color. Defaults to `theme.primaryColor`.
  final Color? ringColor;

  /// Show the rotating ring behind the icon.
  final bool showRing;

  /// Loop forever (default) or stop after one full cycle.
  final bool loop;

  /// Called when a full cycle finishes (only when [loop] is false).
  final VoidCallback? onCompleted;

  const IconSwapLoader({
    super.key,
    this.size = 96,
    this.icons = const [
      Icons.shopping_cart_rounded,
      Icons.local_cafe_rounded,
      Icons.restaurant_rounded,
      Icons.event_rounded,
      Icons.chat_bubble_rounded,
      Icons.person_rounded,
    ],
    this.interval = const Duration(milliseconds: 900),
    this.iconColor,
    this.ringColor,
    this.showRing = true,
    this.loop = true,
    this.onCompleted,
  });

  @override
  State<IconSwapLoader> createState() => _IconSwapLoaderState();
}

class _IconSwapLoaderState extends State<IconSwapLoader>
    with TickerProviderStateMixin {
  late final AnimationController _ring;
  late final AnimationController _swap;

  int _index = 0;

  @override
  void initState() {
    super.initState();

    // Slow continuous spin for the halo ring.
    _ring = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    // One-shot controller for each icon transition.
    _swap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1.0,
    );

    _startCycle();
  }

  void _startCycle() async {
    while (mounted) {
      await Future.delayed(widget.interval);
      if (!mounted) return;

      // Fade/scale out old icon, then bump to next, then fade/scale in.
      await _swap.reverse();
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % widget.icons.length;
      });
      await _swap.forward();

      // If not looping and we've come back to the start, stop.
      if (!widget.loop && _index == 0) {
        widget.onCompleted?.call();
        return;
      }
    }
  }

  @override
  void dispose() {
    _ring.dispose();
    _swap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = widget.iconColor ?? theme.primaryColor;
    final ringColor = widget.ringColor ?? theme.primaryColor;

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (reduceMotion) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: Icon(
            widget.icons.first,
            size: widget.size * 0.42,
            color: iconColor,
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---- Rotating halo ring ----
          if (widget.showRing)
            AnimatedBuilder(
              animation: _ring,
              builder: (_, __) => Transform.rotate(
                angle: _ring.value * math.pi * 2,
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _RingPainter(color: ringColor),
                ),
              ),
            ),

          // ---- Center disc ----
          Container(
            width: widget.size * 0.72,
            height: widget.size * 0.72,
            decoration: BoxDecoration(
              color: ringColor.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: ringColor.withOpacity(0.20),
                width: 1.2,
              ),
            ),
          ),

          // ---- Swapping icon (flip + scale + fade) ----
          AnimatedBuilder(
            animation: _swap,
            builder: (_, __) {
              // _swap goes 1 → 0 → 1. Map to a "flip" rotation on Y axis.
              // t: 0 = fully out, 1 = fully in.
              final t = _swap.value;
              final flip = (1 - t) * math.pi; // 0 rad at t=1, π at t=0
              final scale = 0.6 + 0.4 * t;
              final opacity = t;

              return Opacity(
                opacity: opacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012) // perspective
                    ..rotateY(flip)
                    ..scale(scale, scale),
                  child: Icon(
                    widget.icons[_index],
                    size: widget.size * 0.42,
                    color: iconColor,
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

// ============================================================================
// RING PAINTER — a dashed arc with a gradient sweep
// ============================================================================

class _RingPainter extends CustomPainter {
  final Color color;
  _RingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.45;

    // Soft outer ring
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = color.withOpacity(0.15);
    canvas.drawCircle(center, radius, base);

    // Gradient arc (top → right) for the "sweep" feel
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.9),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);

    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.2, false, sweep);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.color != color;
}