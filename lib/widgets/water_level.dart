import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:math' as math;

import 'package:smart_controller/constant/constant.dart';

class AdvancedWaterAnimation extends StatefulWidget {
  final double fillPercentage; // 0.0 to 1.0
  final double height;
  final double width;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showPercentage;

  const AdvancedWaterAnimation({
    super.key,
    required this.fillPercentage,
    this.height = 300,
    this.width = 300,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.lightBlue,
    this.showPercentage = true,
  }) : assert(fillPercentage >= 0 && fillPercentage <= 1);

  @override
  State<AdvancedWaterAnimation> createState() => _AdvancedWaterAnimationState();
}

class _AdvancedWaterAnimationState extends State<AdvancedWaterAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(25),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Colors.grey[200]!,
            //     Colors.grey[100]!,
            //   ],
            // ),
            color: Constant.bgPrimary,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // Background wave
                AnimatedBuilder(
                  animation: _controller1,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WaveCustomPainter(
                        waveAnimation: _controller1.value,
                        fillPercentage: widget.fillPercentage,
                        waveColor: widget.secondaryColor.withOpacity(0.5),
                        amplitude: 20,
                        frequency: 2.5,
                      ),
                      size: Size(widget.width, widget.height),
                    );
                  },
                ),
                // Foreground wave
                AnimatedBuilder(
                  animation: _controller2,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WaveCustomPainter(
                        waveAnimation: _controller2.value,
                        fillPercentage: widget.fillPercentage,
                        waveColor: widget.primaryColor.withOpacity(0.7),
                        amplitude: 15,
                        frequency: 3,
                      ),
                      size: Size(widget.width, widget.height),
                    );
                  },
                ),
                if (widget.showPercentage)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Constant.textWithStyle(
                          fontWeight: FontWeight.w900,
                          text:
                              '${(widget.fillPercentage * 100).toStringAsFixed(1)}%',
                          size: 22.sp,
                          fontSpacing: 2,
                          color: Colors.white.withOpacity(0.9),
                          shadow: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        Constant.textWithStyle(
                          fontWeight: FontWeight.w900,
                          text: 'Filled',
                          size: 18.sp,
                          fontSpacing: 2,
                          color: Colors.white.withOpacity(0.9),
                          shadow: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaveCustomPainter extends CustomPainter {
  final double waveAnimation;
  final double fillPercentage;
  final Color waveColor;
  final double amplitude;
  final double frequency;

  WaveCustomPainter({
    required this.waveAnimation,
    required this.fillPercentage,
    required this.waveColor,
    required this.amplitude,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final baseHeight = size.height * (1 - fillPercentage);

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = baseHeight +
          math.sin((x / size.width * frequency * math.pi) +
                  (waveAnimation * 2 * math.pi)) *
              amplitude +
          math.sin((x / size.width * (frequency * 0.5) * math.pi) +
                  (waveAnimation * 4 * math.pi)) *
              (amplitude * 0.5);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    // Add gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        waveColor.withOpacity(0.7),
        waveColor,
      ],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveCustomPainter oldDelegate) {
    return oldDelegate.waveAnimation != waveAnimation ||
        oldDelegate.fillPercentage != fillPercentage;
  }
}

// Example usage
class WaterLevelDemo extends StatelessWidget {
  const WaterLevelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AdvancedWaterAnimation(
          fillPercentage: 0.65,
          primaryColor: Colors.blue,
          secondaryColor: Colors.lightBlue,
          height: 300,
          width: 300,
          showPercentage: true,
        ),
      ),
    );
  }
}
