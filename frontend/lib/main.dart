import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Paint Cards Designs Showcase',
      home: BorderShowcaseScreen(),
    );
  }
}


class BorderShowcaseScreen extends StatelessWidget {
  const BorderShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        title: const Text("Flutter CustomPainters", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, 
          crossAxisSpacing: 25,
          mainAxisSpacing: 20,
          children: const [
            ShowcaseItem(title: "1. Neon Sweep", type: BorderType.neonSweep),
            ShowcaseItem(title: "2. The Comet", type: BorderType.comet),
            ShowcaseItem(title: "3. Tech Corners", type: BorderType.techCorners),
            ShowcaseItem(title: "4. Breathing", type: BorderType.breathing),
            ShowcaseItem(title: "5. Dual Spin", type: BorderType.dualSpin),
          ],
        ),
      ),
    );
  }
}

enum BorderType { neonSweep, comet, techCorners, breathing, dualSpin }

class ShowcaseItem extends StatelessWidget {
  final String title;
  final BorderType type;

  const ShowcaseItem({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedBorderCard(type: type),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class AnimatedBorderCard extends StatefulWidget {
  final BorderType type;
  const AnimatedBorderCard({super.key, required this.type});

  @override
  State<AnimatedBorderCard> createState() => _AnimatedBorderCardState();
}

class _AnimatedBorderCardState extends State<AnimatedBorderCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _UniversalBorderPainter(
            animationValue: _controller.value,
            type: widget.type,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.mood, color: Colors.white24, size: 30),
            ),
          ),
        );
      },
    );
  }
}

class _UniversalBorderPainter extends CustomPainter {
  final double animationValue;
  final BorderType type;

  _UniversalBorderPainter({required this.animationValue, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final Paint paint = Paint()..style = PaintingStyle.stroke;

    switch (type) {
      
      // 1. NEON SWEEP
      case BorderType.neonSweep:
        paint.strokeWidth = 10;
        paint.shader = SweepGradient(
          colors: const [Colors.cyan, Colors.purple, Colors.blue, Colors.cyan],
          transform: GradientRotation(animationValue * 2 * pi),
        ).createShader(rect);
        canvas.drawRRect(rRect, paint);
        break;

      // 2. THE COMET
      case BorderType.comet:
        paint.strokeWidth = 10;
        paint.strokeCap = StrokeCap.round; 
        paint.shader = SweepGradient(
          colors: const [Colors.transparent, Colors.transparent, Colors.orangeAccent],
          stops: const [0.0, 0.75, 1.0],
          transform: GradientRotation(animationValue * 2 * pi),
        ).createShader(rect);
        canvas.drawRRect(rRect, paint);
        break;

      // 3. HALF CORNERS DESIGN
      case BorderType.techCorners:
        paint.color = Colors.greenAccent;
        paint.strokeWidth = 5;
        double lineLength = 40;

        // Animating the length
        double animatedLength = lineLength + (sin(animationValue * 2 * pi) * 5);
        
        // Top Left
        canvas.drawLine(rect.topLeft, rect.topLeft + Offset(animatedLength, 0), paint);
        canvas.drawLine(rect.topLeft, rect.topLeft + Offset(0, animatedLength), paint);

        // Top Right
        canvas.drawLine(rect.topRight, rect.topRight + Offset(-animatedLength, 0), paint);
        canvas.drawLine(rect.topRight, rect.topRight + Offset(0, animatedLength), paint);

        // Bottom Left
        canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(animatedLength, 0), paint);
        canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(0, -animatedLength), paint);

        // Bottom Right
        canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(-animatedLength, 0), paint);
        canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(0, -animatedLength), paint);

        break;

      // 4. BREATHING DESIN
      case BorderType.breathing:
        double opacity = (sin(animationValue * 2 * pi) + 1) / 2; 
        paint.color = Colors.redAccent.withOpacity(0.3 + (opacity * 0.7)); // Min opacity 0.3
        paint.strokeWidth = 4 + (opacity * 6); 
        
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawRRect(rRect, paint);
      
        final sharpPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.white;
        canvas.drawRRect(rRect, sharpPaint);
        break;

      // 5. DUAL SPIN DESIGN
      case BorderType.dualSpin:
        paint.strokeWidth = 5;
        paint.strokeCap = StrokeCap.round;
  
        paint.shader = SweepGradient(
          colors:  [Colors.transparent, Colors.cyanAccent],
          transform: GradientRotation(-animationValue * 2 * pi), 
        ).createShader(rect);
        canvas.drawRRect(rRect.inflate(2), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _UniversalBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}