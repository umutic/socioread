import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const SocioreadApp());
}

class SocioreadApp extends StatelessWidget {
  const SocioreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socioread',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ─── Renk Paleti ────────────────────────────────────────────────────────────
class AppColors {
  static const cream = Color(0xFFFAF6F0);
  static const deepForest = Color(0xFF1A3C2E);
  static const sage = Color(0xFF2D6A4F);
  static const moss = Color(0xFF52B788);
  static const amber = Color(0xFFE8A838);
  static const dustyRose = Color(0xFFD4836A);
  static const softLavender = Color(0xFF9B8FC0);
  static const textDark = Color(0xFF1C1C1E);
  static const textMuted = Color(0xFF6B7280);
}

// ─── Onboarding Data ─────────────────────────────────────────────────────────
class OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color bgGradientStart;
  final Color bgGradientEnd;

  const OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.bgGradientStart,
    required this.bgGradientEnd,
  });
}

const List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    emoji: '📚',
    title: 'Kitap Serüvenini\nOluştur',
    subtitle:
    'Her kitap bir yolculuk. Notlarını, duygularını ve keşiflerini kaydet — hikaye seninle birlikte büyüsün.',
    accentColor: AppColors.moss,
    bgGradientStart: Color(0xFFF0FAF4),
    bgGradientEnd: Color(0xFFE8F5EC),
  ),
  OnboardingPage(
    emoji: '🧠',
    title: 'Dijital Hafıza\nTut',
    subtitle:
    'Sayfa sayfa anların fotoğrafını çek, alıntılarını sakla, düşüncelerini zaman damgasıyla arşivle.',
    accentColor: AppColors.softLavender,
    bgGradientStart: Color(0xFFF5F3FF),
    bgGradientEnd: Color(0xFFEDE9FE),
  ),
  OnboardingPage(
    emoji: '🌍',
    title: 'Okuma\nTopluluğuna Katıl',
    subtitle:
    'Aynı kitabı sevenleri bul, serüvenlerini paylaş ve başkalarının notlarından ilham al.',
    accentColor: AppColors.amber,
    bgGradientStart: Color(0xFFFFFBF0),
    bgGradientEnd: Color(0xFFFFF3D0),
  ),
];

// ─── Ana Onboarding Ekranı ────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _fadeController.reset();
    _fadeController.forward();
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = onboardingPages[_currentPage];
    return Scaffold(
      backgroundColor: page.bgGradientStart,
      body: Container(
        decoration: BoxDecoration(
          color: page.bgGradientStart,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Logo + Skip ──────────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: page.accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('S',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Socioread',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    if (_currentPage < onboardingPages.length - 1)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _pageController.animateToPage(
                            onboardingPages.length - 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        child: Text(
                          'Geç',
                          style: TextStyle(
                            color: page.accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── PageView ─────────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingPages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPageView(
                      page: onboardingPages[index],
                      floatController: _floatController,
                      fadeAnimation: _fadeAnimation,
                      isActive: index == _currentPage,
                    );
                  },
                ),
              ),

              // ── Dots ─────────────────────────────────────────────────────
              _DotsIndicator(
                count: onboardingPages.length,
                current: _currentPage,
                accentColor: page.accentColor,
              ),

              const SizedBox(height: 24),

              // ── İleri / Auth Bölümü ──────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _currentPage < onboardingPages.length - 1
                    ? _NextButton(
                  key: const ValueKey('next'),
                  accentColor: page.accentColor,
                  onTap: _nextPage,
                )
                    : _AuthSection(
                  key: const ValueKey('auth'),
                  accentColor: page.accentColor,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tek Sayfa İçeriği ────────────────────────────────────────────────────────
class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;
  final AnimationController floatController;
  final Animation<double> fadeAnimation;
  final bool isActive;

  const _OnboardingPageView({
    required this.page,
    required this.floatController,
    required this.fadeAnimation,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Floating emoji illustration
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) {
              final offset = math.sin(floatController.value * math.pi) * 10;
              return Transform.translate(
                offset: Offset(0, -offset),
                child: child,
              );
            },
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: page.accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(page.emoji,
                    style: const TextStyle(fontSize: 72)),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Decorative line
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: page.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.2,
                letterSpacing: -0.8,
              ),
            ),
          ),

          const SizedBox(height: 16),

          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dots ─────────────────────────────────────────────────────────────────────
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;
  final Color accentColor;

  const _DotsIndicator({
    required this.count,
    required this.current,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? accentColor : accentColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─── İleri Butonu ─────────────────────────────────────────────────────────────
class _NextButton extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;

  const _NextButton({super.key, required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: _HapticButton(
        onTap: onTap,
        backgroundColor: accentColor,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Devam Et',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Auth Bölümü ─────────────────────────────────────────────────────────────
class _AuthSection extends StatelessWidget {
  final Color accentColor;

  const _AuthSection({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Apple
          _HapticButton(
            onTap: () => _onAuth(context, 'Apple'),
            backgroundColor: AppColors.textDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.apple, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text('Apple ile Devam Et',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Google
          _HapticButton(
            onTap: () => _onAuth(context, 'Google'),
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE0E0E0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleIcon(),
                const SizedBox(width: 10),
                const Text('Google ile Devam Et',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // E-posta
          _HapticButton(
            onTap: () => _onAuth(context, 'E-posta'),
            backgroundColor: accentColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline_rounded, color: accentColor, size: 22),
                const SizedBox(width: 10),
                Text('E-posta ile Devam Et',
                    style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Gizlilik
          Text(
            'Devam ederek Gizlilik Politikası ve Kullanım Şartlarını kabul edersiniz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _onAuth(BuildContext context, String provider) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider ile giriş deneniyor...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Haptic Buton Wrapper ─────────────────────────────────────────────────────
class _HapticButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final Widget child;

  const _HapticButton({
    required this.onTap,
    required this.backgroundColor,
    this.borderColor,
    required this.child,
  });

  @override
  State<_HapticButton> createState() => _HapticButtonState();
}

class _HapticButtonState extends State<_HapticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.03,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _scaleController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Google İkon ─────────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];

    final paint = Paint()..style = PaintingStyle.fill;

    // Simplified colorful circle
    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (i * math.pi / 2) - math.pi / 4,
        math.pi / 2,
        true,
        paint,
      );
    }

    // White center
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);

    // Blue right bar
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - radius * 0.22,
          radius * 0.95, radius * 0.44),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}