import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersHeroCard extends StatefulWidget {
  const OffersHeroCard({super.key, required this.hero});

  final OffersHeroEntity hero;

  @override
  State<OffersHeroCard> createState() => _OffersHeroCardState();
}

class _OffersHeroCardState extends State<OffersHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _dropAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
    _dropAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -280,
          end: 12,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 78,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 12,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 22,
      ),
    ]).animate(_controller);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.55, curve: Curves.easeOut),
    );

    _controller.forward();
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
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _dropAnimation.value),
          child: FadeTransition(opacity: _fadeAnimation, child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(46),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Image.asset(
            'assets/images/offers/banner_offfer.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
