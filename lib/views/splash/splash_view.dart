import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';
import '../../utils/theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _glowRadius;

  @override
  void initState() {
    super.initState();
    
    // Inject SplashController to trigger timer-based navigation
    Get.put(SplashController());

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutBack,
    ));

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.4, 1.0, curve: Curves.easeOutBack),
    ));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
    ));

    _glowRadius = Tween<double>(begin: 20.0, end: 40.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.bgDark : AppTheme.bgLight,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background blurred blobs
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryDark.withOpacity(isDark ? 0.12 : 0.18),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -50,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentDark.withOpacity(isDark ? 0.12 : 0.18),
                ),
              ),
            ),
            // Blur filter over background shapes
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                child: const SizedBox.shrink(),
              ),
            ),

            // Center Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale and pulsating glow
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoFade,
                        child: Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.cardDark.withOpacity(0.85)
                                : AppTheme.cardLight.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withOpacity(isDark ? 0.35 : 0.25),
                                blurRadius: _glowRadius.value,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/images/splash_logo.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Title & Subtitle with slide & fade transitions
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        Text(
                          'TaskFlow',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Organize your life, beautifully.',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom loading indicators
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryDark),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.storage_rounded,
                          size: 15,
                          color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Persisted locally with SQLite',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
