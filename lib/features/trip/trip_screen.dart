import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late Timer _tripTimer;
  int _elapsedSeconds = 0;
  double _distanceKm = 0.0;
  double _currentCost = 120.0;
  int _currentSpeed = 0;
  final double _targetDistance = 27.1; // Mlolongo to Westlands length
  bool _isFinished = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    _currentSpeed = _random.nextInt(15) + 70; // 70-85 km/h start
    _tripTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
        
        // Randomly adjust speed (-3 to +3 km/h)
        _currentSpeed = (_currentSpeed + (_random.nextInt(7) - 3)).clamp(60, 100);
        
        // Calculate distance added this second (km/h -> km/s)
        double distancePerSecond = _currentSpeed / 3600.0;
        _distanceKm += distancePerSecond;
        
        // Increase cost (e.g. roughly 10 KES per KM after base)
        _currentCost = 120.0 + (_distanceKm * 10);

        if (_distanceKm >= _targetDistance) {
          _isFinished = true;
          _currentSpeed = 0;
          _distanceKm = _targetDistance;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _tripTimer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _elapsedSeconds ~/ 60;
    int seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Trip System'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Expressway Map Background Layer
          Positioned.fill(
            child: CustomPaint(
              painter: _ExpresswayPainter(progress: _distanceKm / _targetDistance),
            ),
          ).animate().fadeIn(duration: 1.seconds),

          // Content Layer
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Central Speedometer
                  _buildSpeedometer(),
                  const SizedBox(height: 48),
                  
                  // Bottom Data Dash
                  _buildTelemetryGrid(),
                  const SizedBox(height: 32),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                         context.push('/fare');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFinished ? AppColors.primary : AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        )
                      ),
                      child: Text(_isFinished ? 'PROCEED TO EXIT' : 'EMERGENCY STOP', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.5)
                      ),
                    ).animate(target: _isFinished ? 1 : 0).shimmer(duration: 1.5.seconds, color: Colors.white),
                  ),
                  const SizedBox(height: 16), // space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedometer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: _currentSpeed / 120.0, // max 120 on dash
            strokeWidth: 8,
            backgroundColor: AppColors.surface,
            color: AppColors.primary,
          ),
        ).animate().scale(curve: Curves.easeOutBack, duration: 800.ms),
        
        // Inner Glow
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ]
          ),
        ),
        
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentSpeed.toString(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 72,
              ),
            ),
            const Text(
              'km/h',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTelemetryGrid() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildDataTile('Distance', '${_distanceKm.toStringAsFixed(2)} km', Icons.route),
              Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
              _buildDataTile('Elapsed', _formattedTime, Icons.timer),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Est. Toll Cost', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              Text(
                'KES ${_currentCost.toStringAsFixed(2)}', 
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildDataTile(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ExpresswayPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  _ExpresswayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..color = AppColors.primary.withOpacity(0.4)
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Create a smooth S-curve for the expressway map representing the path dynamically visually
    final path = Path();
    path.moveTo(size.width * 0.2, -50); // Start off top
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.7, size.width * 0.8, size.height + 50); // End off bottom

    // Draw background road
    canvas.drawPath(path, paintLine);

    // Calculate length of the path to selectively draw the neon progress
    PathMetrics pathMetrics = path.computeMetrics();
    if (pathMetrics.isNotEmpty) {
      PathMetric pathMetric = pathMetrics.first;
      
      // We start at progress = 0.0 at bottom logically? The map usually goes bottom->up or top->down.
      // Let's do bottom -> up. Wait, top -> down is easier. 
      // User progresses from Top to Bottom
      double currentLength = pathMetric.length * progress;
      Path extractedPath = pathMetric.extractPath(0.0, currentLength);
      
      // Draw progressed glowing road over background
      canvas.drawPath(extractedPath, paintProgress);

      if (currentLength > 0) {
        // Find position of the leading dot
        Tangent? tangent = pathMetric.getTangentForOffset(currentLength);
        if (tangent != null) {
          final dotPaint = Paint()
            ..color = AppColors.primary
            ..style = PaintingStyle.fill;
          
          final glowPaint = Paint()
            ..color = AppColors.primary.withOpacity(0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(tangent.position, 20, glowPaint);
          canvas.drawCircle(tangent.position, 8, dotPaint);
          canvas.drawCircle(tangent.position, 14, Paint()..color = AppColors.primary..style=PaintingStyle.stroke..strokeWidth=2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ExpresswayPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
